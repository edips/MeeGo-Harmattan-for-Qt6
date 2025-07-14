// MRemoteThemeDaemonClient.h
#ifndef MREMOTETHEMEDAEMONCLIENT_H
#define MREMOTETHEMEDAEMONCLIENT_H

#include <QObject>
#include <QHash>
#include <QLocalSocket>
#include <QPixmap>
#include <QString>
#include <QDataStream>

#include "mAbstractThemeDaemonClient.h"
#include "mThemeDaemonProtocol.h"

class MRemoteThemeDaemonClient : public MAbstractThemeDaemonClient {
    Q_OBJECT

public:
    explicit MRemoteThemeDaemonClient(const QString &serverAddress = {}, QObject *parent = nullptr);
    ~MRemoteThemeDaemonClient() override;

    QPixmap requestPixmap(const QString &id, const QSize &requestedSize) override;
    bool isConnected() const;

private slots:
    void connectionDataAvailable();

private:
    M::MThemeDaemonProtocol::Packet waitForPacket(quint64 sequenceNumber);
    void processOnePacket(const M::MThemeDaemonProtocol::Packet &packet);
    M::MThemeDaemonProtocol::Packet readOnePacket();

    void addMostUsedPixmaps(const QList<M::MThemeDaemonProtocol::PixmapHandlePacketData> &handles);
    void removeMostUsedPixmaps(const QList<M::MThemeDaemonProtocol::PixmapIdentifier> &identifiers);

    bool connectToServer(const QString &serverAddress, int timeout);
    void registerApplication(const QString &applicationName);
    qint32 priority() const;
    void initializePriority(const QString &applicationName);
    void negotiateProtocolVersion();
    void handleUnexpectedPacket(const M::MThemeDaemonProtocol::Packet &packet);

    QPixmap pixmapFromMostUsed(const M::MThemeDaemonProtocol::PixmapIdentifier &pixmapId);
    static QPixmap createPixmapFromHandle(const M::MThemeDaemonProtocol::PixmapHandle &pixmapHandle);

    quint64 m_sequenceCounter = 0;
    qint32 m_priority = 0;
    QLocalSocket m_socket;
    QDataStream m_stream;

    QHash<M::MThemeDaemonProtocol::PixmapIdentifier, QPixmap*> m_pixmapCache;
    QHash<M::MThemeDaemonProtocol::PixmapIdentifier, M::MThemeDaemonProtocol::PixmapHandle> m_mostUsedPixmaps;

    friend class tst_MRemoteThemeDaemonClient;
};

#endif // MREMOTETHEMEDAEMONCLIENT_H
