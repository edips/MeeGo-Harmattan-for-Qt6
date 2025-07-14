#ifndef MDECLARATIVEIMAGEPROVIDER_H
#define MDECLARATIVEIMAGEPROVIDER_H

#include <QQuickImageProvider>

class MAbstractThemeDaemonClient;

class MDeclarativeImageProvider : public QQuickImageProvider
{
public:
    MDeclarativeImageProvider();
    ~MDeclarativeImageProvider() override;

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize) override;

private:
    MAbstractThemeDaemonClient *m_themeDaemonClient = nullptr;
};

#endif // MDECLARATIVEIMAGEPROVIDER_H
