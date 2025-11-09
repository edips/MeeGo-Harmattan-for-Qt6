/****************************************************************************
**
** Originally part of the MeeGo Harmattan Qt Components project
** © 2011 Nokia Corporation and/or its subsidiary(-ies). All rights reserved.
**
** Licensed under the BSD License.
** See the original license text for redistribution and use conditions.
**
** Ported from MeeGo Harmattan (Qt 4.7) to Qt 6 by Edip Ahmet Taskin, 2025.
**
****************************************************************************/
#include "mDeclarativeImageprovider.h"

#include <themedaemon/mLocalThemeDaemonClient.h>
#include <themedaemon/mRemoteThemeDaemonClient.h>

#include <QSysInfo>
#include <QPixmap>
#include <QByteArray>
#include <QDebug>

MDeclarativeImageProvider::MDeclarativeImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Pixmap),
    m_themeDaemonClient(nullptr)
{
    bool useRemoteThemeDaemon = qEnvironmentVariableIsEmpty("M_FORCE_LOCAL_THEME");

#if defined(Q_OS_MACOS) || defined(Q_OS_WINDOWS) || defined(FORCE_LOCAL_THEME)
    useRemoteThemeDaemon = false;
#endif

    MRemoteThemeDaemonClient *remoteThemeDaemonClient = nullptr;

    if (useRemoteThemeDaemon) {
        remoteThemeDaemonClient = new MRemoteThemeDaemonClient();
    }

    if (remoteThemeDaemonClient && remoteThemeDaemonClient->isConnected()) {
        m_themeDaemonClient = remoteThemeDaemonClient;
    } else {
        delete remoteThemeDaemonClient;
        m_themeDaemonClient = new MLocalThemeDaemonClient();
    }
}

MDeclarativeImageProvider::~MDeclarativeImageProvider()
{
    delete m_themeDaemonClient;
}

QPixmap MDeclarativeImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    const QPixmap pixmap = m_themeDaemonClient->requestPixmap(id, requestedSize);
    if (!pixmap.isNull() && size) {
        *size = pixmap.size();
    }
    return pixmap;
}
