// MLocalThemeDaemonClient.h
#ifndef MLOCALTHEMEDAEMONCLIENT_H
#define MLOCALTHEMEDAEMONCLIENT_H

#include <QObject>
#include <QHash>
#include <QPixmap>
#include <QString>
#include <QImage>
#include <QDir>
#include <QSize>

#include "mAbstractThemeDaemonClient.h"

#ifdef HAVE_MLITE
#include <mgconfitem.h>
#endif

class MLocalThemeDaemonClient : public MAbstractThemeDaemonClient {
    Q_OBJECT

public:
    explicit MLocalThemeDaemonClient(const QString &testPath = {}, QObject *parent = nullptr);
    ~MLocalThemeDaemonClient() override;

    QPixmap requestPixmap(const QString &id, const QSize &requestedSize) override;

private:
    QImage readImage(const QString &id) const;
    void buildHash(const QDir &rootDir, const QStringList &nameFilter);

    struct PixmapIdentifier {
        PixmapIdentifier();
        PixmapIdentifier(const QString &imageId, const QSize &size);

        QString imageId;
        QSize size;

        bool operator==(const PixmapIdentifier &other) const;
        bool operator!=(const PixmapIdentifier &other) const;
    };

    QHash<PixmapIdentifier, QPixmap> m_pixmapCache;
    QHash<QString, QString> m_filenameHash;

#ifdef HAVE_MLITE
    MGConfItem themeItem;
#endif

    friend uint qHash(const MLocalThemeDaemonClient::PixmapIdentifier &id);
    friend class tst_MLocalThemeDaemonClient;
};

#endif // MLOCALTHEMEDAEMONCLIENT_H
