// MThemeDaemonProtocol.h
#ifndef MTHEMEDAEMONPROTOCOL_H
#define MTHEMEDAEMONPROTOCOL_H

#include <QDataStream>
#include <QImage>
#include <QSharedPointer>
#include <QSize>
#include <QStringList>
#include <QList>
#include <QHash>

namespace M {
namespace MThemeDaemonProtocol {

constexpr qint32 protocolVersion = 1;
extern const QString ServerAddress;

struct PacketData {
    virtual ~PacketData() = 0;
};

class Packet {
public:
    enum PacketType {
        Unknown = 0,
        RequestRegistrationPacket = 1,
        ProtocolVersionPacket = 2,
        PixmapUsedPacket = 7,
        RequestPixmapPacket = 8,
        ReleasePixmapPacket = 9,
        PixmapUpdatedPacket = 10,
        RequestNewPixmapDirectoryPacket = 16,
        RequestClearPixmapDirectoriesPacket = 17,
        ThemeChangedPacket = 33,
        ThemeChangeAppliedPacket = 34,
        ThemeChangeCompletedPacket = 35,
        MostUsedPixmapsPacket = 36,
        AckMostUsedPixmapsPacket = 37,
        QueryThemeDaemonStatusPacket = 129,
        ThemeDaemonStatusPacket = 130,
        ErrorPacket = 255
    };

    Packet() = default;
    Packet(PacketType type, quint64 seq, PacketData *data = nullptr);
    ~Packet();

    PacketType type() const { return m_type; }
    void setType(PacketType type) { m_type = type; }

    quint64 sequenceNumber() const { return m_seq; }
    void setSequenceNumber(quint64 seq) { m_seq = seq; }

    const PacketData *data() const { return m_data.data(); }
    void setData(PacketData *data);

private:
    quint64 m_seq = 0;
    QSharedPointer<PacketData> m_data;
    PacketType m_type = Unknown;
};

struct PixmapHandle {
    PixmapHandle();
    bool isValid() const;

    Qt::HANDLE xHandle = nullptr;
    Qt::HANDLE eglHandle = nullptr;
    QByteArray shmHandle;
    QSize size;
    QImage::Format format = QImage::Format_Invalid;
    int numBytes = 0;

    bool directMap = false;
};

struct PixmapIdentifier : PacketData {
    PixmapIdentifier() = default;
    PixmapIdentifier(const QString &imageId, const QSize &size);
    ~PixmapIdentifier() override;

    QString imageId;
    QSize size;

    bool operator==(const PixmapIdentifier &other) const;
    bool operator!=(const PixmapIdentifier &other) const;
};

uint qHash(const PixmapIdentifier &id, uint seed = 0);

struct NumberPacketData : PacketData {
    explicit NumberPacketData(qint32 value);
    ~NumberPacketData() override;
    qint32 value;
};

struct StringPacketData : PacketData {
    explicit StringPacketData(const QString &string);
    ~StringPacketData() override;
    QString string;
};

struct StringBoolPacketData : PacketData {
    StringBoolPacketData(const QString &string, bool b);
    ~StringBoolPacketData() override;

    QString string;
    bool b = false;
};

struct PixmapHandlePacketData : PacketData {
    PixmapHandlePacketData();
    PixmapHandlePacketData(const PixmapIdentifier &identifier, const PixmapHandle &pixmapHandle);
    PixmapHandlePacketData(const PixmapHandlePacketData &handle);
    ~PixmapHandlePacketData() override;

    PixmapIdentifier identifier;
    PixmapHandle pixmapHandle;
};

struct ClientInfo {
    QString name;
    QList<PixmapIdentifier> pixmaps;
    QList<PixmapIdentifier> requestedPixmaps;
    QList<PixmapIdentifier> releasedPixmaps;
};

struct ClientList : PacketData {
    explicit ClientList(const QList<ClientInfo> &clients);
    ~ClientList() override;
    QList<ClientInfo> clients;
};

struct ThemeChangeInfoPacketData : PacketData {
    ThemeChangeInfoPacketData(const QStringList &themeInheritance, const QStringList &themeLibraryNames);
    ~ThemeChangeInfoPacketData() override;

    QStringList themeInheritance;
    QStringList themeLibraryNames;
};

struct MostUsedPixmapsPacketData : PacketData {
    MostUsedPixmapsPacketData() = default;
    MostUsedPixmapsPacketData(const QList<PixmapHandlePacketData> &addedHandles,
                              const QList<PixmapIdentifier> &removedIdentifiers);
    ~MostUsedPixmapsPacketData() override;

    QList<PixmapHandlePacketData> addedHandles;
    QList<PixmapIdentifier> removedIdentifiers;
};

struct RequestedPixmapPacketData : PacketData {
    RequestedPixmapPacketData(const PixmapIdentifier &id, qint32 priority);
    ~RequestedPixmapPacketData() override;

    PixmapIdentifier id;
    qint32 priority = 0;
};

} // namespace MThemeDaemonProtocol
} // namespace M

QDataStream &operator<<(QDataStream &stream, const M::MThemeDaemonProtocol::Packet &packet);
void writePacketData(QDataStream &stream, const M::MThemeDaemonProtocol::Packet &packet);
QDataStream &operator>>(QDataStream &stream, M::MThemeDaemonProtocol::Packet &packet);
void readPacketData(QDataStream &stream, M::MThemeDaemonProtocol::Packet &packet);

QDataStream &operator<<(QDataStream &stream, const M::MThemeDaemonProtocol::PixmapHandlePacketData &handle);
QDataStream &operator>>(QDataStream &stream, M::MThemeDaemonProtocol::PixmapHandlePacketData &handle);

QDataStream &operator<<(QDataStream &stream, const M::MThemeDaemonProtocol::PixmapIdentifier &id);
QDataStream &operator>>(QDataStream &stream, M::MThemeDaemonProtocol::PixmapIdentifier &id);

#endif // MTHEMEDAEMONPROTOCOL_H
