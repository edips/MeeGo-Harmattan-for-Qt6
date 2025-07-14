#include "mRemoteThemeDaemonClient.h"

#include <QCoreApplication>
#include <QFileInfo>
#include <QPainter>
#include <QSettings>
#include <QThread>
#include <QTime>
#include <QUuid>

#ifdef HAVE_MEEGOGRAPHICSSYSTEM
#include <QtMeeGoGraphicsSystemHelper>
#include <fcntl.h>
#include <errno.h>
#include <sys/types.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/msg.h>
#include <sys/shm.h>
#include <sys/ipc.h>
#endif

#ifdef Q_OS_WIN
#include <qt_windows.h>
#else
#include <unistd.h>
#endif

using namespace M::MThemeDaemonProtocol;

MRemoteThemeDaemonClient::MRemoteThemeDaemonClient(const QString &serverAddress, QObject *parent)
    : MAbstractThemeDaemonClient(parent),
    m_sequenceCounter(0),
    m_priority(100),
    m_socket(this),
    m_stream(),
    m_pixmapCache(),
    m_mostUsedPixmaps()
{
    // Use Qt6.6 QDataStream version (Qt_6_6 is current)
    m_stream.setVersion(QDataStream::Qt_6_6);

    connect(&m_socket, &QLocalSocket::readyRead, this, &MRemoteThemeDaemonClient::connectionDataAvailable);

    const QString address = serverAddress.isEmpty() ? ServerAddress : serverAddress;
    if (connectToServer(address, 2000)) {
        m_stream.setDevice(&m_socket);
        negotiateProtocolVersion();

        QString applicationName = QCoreApplication::instance()->applicationName();
        if (applicationName.isEmpty()) {
            applicationName = QUuid::createUuid().toString(QUuid::WithoutBraces);
        }
        registerApplication(applicationName);
        initializePriority(applicationName);
    } else {
        qWarning() << "RemoteThemeDaemonClient: Failed to connect to theme server (that's OK if you're on a PC)";
    }
}

MRemoteThemeDaemonClient::~MRemoteThemeDaemonClient()
{
    // Tell the themedaemon server to release all requested pixmaps
    for (auto it = m_pixmapCache.constBegin(); it != m_pixmapCache.constEnd(); ++it) {
        ++m_sequenceCounter;
        m_stream << Packet(Packet::ReleasePixmapPacket,
                           m_sequenceCounter,
                           new PixmapIdentifier(it.key()));
    }

    m_socket.disconnectFromServer();
    qDeleteAll(m_pixmapCache);
    m_pixmapCache.clear();
}

QPixmap MRemoteThemeDaemonClient::requestPixmap(const QString &id, const QSize &requestedSize)
{
    QSize size = requestedSize;
    if (size.width() < 1)
        size.setWidth(0);
    if (size.height() < 1)
        size.setHeight(0);

    const PixmapIdentifier pixmapId(id, size);
    QPixmap *pixmap = m_pixmapCache.value(pixmapId, nullptr);
    if (pixmap) {
        return *pixmap; // already cached
    }

    // Not cached yet: create new pixmap pointer & insert
    pixmap = new QPixmap();
    m_pixmapCache.insert(pixmapId, pixmap);

    if (m_mostUsedPixmaps.contains(pixmapId)) {
        *pixmap = pixmapFromMostUsed(pixmapId);
        if (!pixmap->isNull()) {
            m_mostUsedPixmaps.remove(pixmapId);
        }
    } else {
        ++m_sequenceCounter;
        m_stream << Packet(Packet::RequestPixmapPacket,
                           m_sequenceCounter,
                           new RequestedPixmapPacketData(pixmapId, priority()));
        const Packet reply = waitForPacket(m_sequenceCounter);
        processOnePacket(reply);
    }

    if (pixmap->isNull()) {
        delete pixmap;
        m_pixmapCache.remove(pixmapId);
        return QPixmap();
    }

    return *pixmap;
}

bool MRemoteThemeDaemonClient::isConnected() const
{
    return m_socket.state() == QLocalSocket::ConnectedState;
}

void MRemoteThemeDaemonClient::connectionDataAvailable()
{
    const bool blocked = m_socket.blockSignals(true);
    while (m_socket.bytesAvailable()) {
        processOnePacket(readOnePacket());
    }
    m_socket.blockSignals(blocked);
}

Packet MRemoteThemeDaemonClient::waitForPacket(quint64 sequenceNumber)
{
    m_socket.flush();

    QObject::disconnect(&m_socket, &QLocalSocket::readyRead, this, &MRemoteThemeDaemonClient::connectionDataAvailable);

    while (m_socket.waitForReadyRead(3000)) {
        while (m_socket.bytesAvailable()) {
            const Packet packet = readOnePacket();
            if (packet.sequenceNumber() == sequenceNumber) {
                QObject::connect(&m_socket, &QLocalSocket::readyRead, this, &MRemoteThemeDaemonClient::connectionDataAvailable);
                connectionDataAvailable();
                return packet;
            }
            processOnePacket(packet);
        }
    }

    QObject::connect(&m_socket, &QLocalSocket::readyRead, this, &MRemoteThemeDaemonClient::connectionDataAvailable);
    return Packet();
}

void MRemoteThemeDaemonClient::processOnePacket(const Packet &packet)
{
    switch (packet.type()) {
    case Packet::PixmapUpdatedPacket: {
        const PixmapHandlePacketData *handle = static_cast<const PixmapHandlePacketData *>(packet.data());
        if (m_pixmapCache.contains(handle->identifier)) {
            QPixmap *pixmap = m_pixmapCache.value(handle->identifier);
            *pixmap = createPixmapFromHandle(handle->pixmapHandle);
        }
        break;
    }

    case Packet::MostUsedPixmapsPacket: {
        const MostUsedPixmapsPacketData *mostUsedPacket = static_cast<const MostUsedPixmapsPacketData*>(packet.data());
        addMostUsedPixmaps(mostUsedPacket->addedHandles);
        if (!mostUsedPacket->removedIdentifiers.empty()) {
            removeMostUsedPixmaps(mostUsedPacket->removedIdentifiers);
            m_stream << Packet(Packet::AckMostUsedPixmapsPacket, packet.sequenceNumber());
        }
        break;
    }

    case Packet::ErrorPacket:
        qWarning() << "Packet::ErrorPacket:" << static_cast<const StringPacketData*>(packet.data())->string;
        break;

    case Packet::ThemeChangedPacket:
    case Packet::ThemeChangeCompletedPacket:
    default:
        break;
    }
}

Packet MRemoteThemeDaemonClient::readOnePacket()
{
    Packet packet;
    m_stream >> packet;
    return packet;
}

void MRemoteThemeDaemonClient::addMostUsedPixmaps(const QList<PixmapHandlePacketData> &handles)
{
    for (const PixmapHandlePacketData &handle : handles) {
        if (!m_mostUsedPixmaps.contains(handle.identifier)) {
            m_mostUsedPixmaps.insert(handle.identifier, handle.pixmapHandle);
        }
    }
}

void MRemoteThemeDaemonClient::removeMostUsedPixmaps(const QList<PixmapIdentifier> &identifiers)
{
    for (const PixmapIdentifier &identifier : identifiers) {
        m_mostUsedPixmaps.remove(identifier);
    }
}

bool MRemoteThemeDaemonClient::connectToServer(const QString &serverAddress, int timeout)
{
    QElapsedTimer timer;
    timer.start();

    while (true) {
        m_socket.connectToServer(serverAddress);
        if (m_socket.state() == QLocalSocket::ConnectedState) {
            return true;
        }
        if (timeout > 0 && timer.elapsed() >= timeout) {
            return false;
        }
        QThread::sleep(1);
    }
}

void MRemoteThemeDaemonClient::registerApplication(const QString &applicationName)
{
    ++m_sequenceCounter;
    m_stream << Packet(Packet::RequestRegistrationPacket,
                       m_sequenceCounter,
                       new StringPacketData(applicationName));
    const Packet reply = waitForPacket(m_sequenceCounter);
    if (reply.type() == Packet::ThemeChangedPacket) {
        // Ignored for now
    } else {
        handleUnexpectedPacket(reply);
    }
}

qint32 MRemoteThemeDaemonClient::priority() const
{
    return m_priority;
}

void MRemoteThemeDaemonClient::initializePriority(const QString &applicationName)
{
    QSettings settings("/etc/meegotouch/themedaemonpriorities.conf", QSettings::IniFormat);
    if (settings.status() == QSettings::NoError) {
        m_priority = settings.value("ForegroundApplication/priority", m_priority).toInt();
        settings.beginGroup("SpecificApplicationPriorities");
        if (!applicationName.isEmpty() && settings.contains(applicationName)) {
            m_priority = settings.value(applicationName).toInt();
        }
        settings.endGroup();
    }
}

void MRemoteThemeDaemonClient::negotiateProtocolVersion()
{
    m_stream << Packet(Packet::ProtocolVersionPacket,
                       m_sequenceCounter,
                       new NumberPacketData(protocolVersion));
    Packet reply = waitForPacket(m_sequenceCounter);
    if (reply.type() == Packet::ProtocolVersionPacket) {
        const NumberPacketData *protocolVersionData = static_cast<const NumberPacketData *>(reply.data());
        if (protocolVersionData->value != protocolVersion) {
            qCritical("Running themedaemon and this client do not support the same protocol version.\n"
                      "Maybe you need to restart the themedaemon server or to upgrade your installation.\n"
                      "Exiting.");
            std::exit(EXIT_FAILURE);
        }
    } else {
        handleUnexpectedPacket(reply);
    }
}

void MRemoteThemeDaemonClient::handleUnexpectedPacket(const Packet &packet)
{
    if (packet.type() == Packet::ErrorPacket) {
        const StringPacketData *errorString = static_cast<const StringPacketData*>(packet.data());
        qCritical() << "Themedaemon replied with error packet:\n" << errorString->string << "\nExiting.";
        std::exit(EXIT_FAILURE);
    } else {
        qCritical() << "Received unexpected packet (type" << static_cast<int>(packet.type()) << ") from themedaemon. Exiting.";
        std::exit(EXIT_FAILURE);
    }
}

QPixmap MRemoteThemeDaemonClient::pixmapFromMostUsed(const PixmapIdentifier &pixmapId)
{
    auto it = m_mostUsedPixmaps.find(pixmapId);
    if (it != m_mostUsedPixmaps.end()) {
        ++m_sequenceCounter;
        m_stream << Packet(Packet::PixmapUsedPacket,
                           m_sequenceCounter,
                           new PixmapIdentifier(pixmapId.imageId, pixmapId.size));
        return createPixmapFromHandle(it.value());
    }
    return QPixmap();
}

QPixmap MRemoteThemeDaemonClient::createPixmapFromHandle(const PixmapHandle &pixmapHandle)
{
#ifdef HAVE_MEEGOGRAPHICSSYSTEM
    const bool isMeeGoRunning = QMeeGoGraphicsSystemHelper::isRunningRuntime() &&
                                (QMeeGoGraphicsSystemHelper::runningGraphicsSystemName() == QStringLiteral("meego") ||
                                 QMeeGoGraphicsSystemHelper::runningGraphicsSystemName() == QStringLiteral("raster"));
    if (isMeeGoRunning && pixmapHandle.eglHandle) {
        int fd = -1;
        if (pixmapHandle.directMap)
            fd = open(pixmapHandle.shmHandle.constData(), O_RDONLY);
        else
            fd = shm_open(pixmapHandle.shmHandle.constData(), O_RDONLY, 0444);

        if (fd == -1) {
            qFatal("Failed to open shared memory: %s, %s", strerror(errno), pixmapHandle.shmHandle.constData());
        }

        void *addr = mmap(nullptr, pixmapHandle.numBytes, PROT_READ, MAP_SHARED, fd, 0);
        close(fd);
        if (addr == MAP_FAILED) {
            qFatal("mmap failed: %s", strerror(errno));
        }

        QImage image(static_cast<const uchar*>(addr), pixmapHandle.size.width(), pixmapHandle.size.height(), pixmapHandle.format);

        return QMeeGoGraphicsSystemHelper::pixmapFromEGLSharedImage(pixmapHandle.eglHandle, image);
    }
#endif

#if defined(Q_OS_UNIX) && !defined(Q_OS_WIN)
    if (!pixmapHandle.xHandle) {
        if (pixmapHandle.eglHandle) {
            qWarning("Valid eglHandle received but not running with meego compatible graphicssystem.");
            return QPixmap();
        } else {
            qWarning("No valid handle to create pixmap from received.");
            return QPixmap();
        }
    }

    // Qt6 does not have fromX11Pixmap.
    // You must implement conversion from native X11 Pixmap (XID) to QPixmap manually.

    qWarning("Warning: pixmapHandle.xHandle received but fromX11Pixmap() no longer exists in Qt6.");
    // Fallback: return an empty pixmap or implement native X11 pixmap conversion here.
    return QPixmap();

#else
    QPixmap *pixmapPointer = reinterpret_cast<QPixmap*>(pixmapHandle.xHandle);
    return *pixmapPointer;
#endif

}
