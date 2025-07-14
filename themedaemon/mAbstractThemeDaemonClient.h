// MAbstractThemeDaemonClient.h
#ifndef MABSTRACTTHEMEDAEMONCLIENT_H
#define MABSTRACTTHEMEDAEMONCLIENT_H

#include <QObject>
#include <QPixmap>
/**
 * \brief Interface for a client to request pixmaps from the themedaemon server.
 */
class MAbstractThemeDaemonClient : public QObject
{
    Q_OBJECT

public:
    explicit MAbstractThemeDaemonClient(QObject *parent = nullptr);
    ~MAbstractThemeDaemonClient() override;
    /**
     * \param id            Identifier of the pixmap.
     * \param requestedSize Requested size of the pixmap. If the size is invalid,
     *                      the returned pixmap will have the original size. Otherwise
     *                      the pixmap gets scaled to the requested size.
     */

    virtual QPixmap requestPixmap(const QString &id, const QSize &requestedSize) = 0;
};

#endif // MABSTRACTTHEMEDAEMONCLIENT_H
