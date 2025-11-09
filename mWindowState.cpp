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

#include "mWindowState.h"
#include <QGuiApplication>
#include <QWindow>

MWindowState* MWindowState::instance()
{
    static MWindowState self;
    return &self;
}

MWindowState::MWindowState(QObject *parent)
    : QObject(parent)
{
    auto app = qGuiApp;
    if (app) {
        connect(app, &QGuiApplication::focusWindowChanged,
                this, &MWindowState::onApplicationFocusWindowChanged);
        onApplicationFocusWindowChanged(app->focusWindow());
    }
}

MWindowState::~MWindowState()
{
    if (m_trackedWindow) {
        disconnect(m_trackedWindow, &QWindow::activeChanged,
                   this, &MWindowState::onWindowActiveChanged);
    }
}

bool MWindowState::active() const
{
    return m_active;
}

void MWindowState::updateActive(bool newActive)
{
    if (m_active != newActive) {
        m_active = newActive;
        emit activeChanged();
    }
}

void MWindowState::onApplicationFocusWindowChanged(QWindow *newFocusedWindow)
{
    if (newFocusedWindow == m_trackedWindow)
        return;

    if (m_trackedWindow) {
        disconnect(m_trackedWindow, &QWindow::activeChanged,
                   this, &MWindowState::onWindowActiveChanged);
    }

    m_trackedWindow = newFocusedWindow;

    if (m_trackedWindow) {
        connect(m_trackedWindow, &QWindow::activeChanged,
                this, &MWindowState::onWindowActiveChanged);
        updateActive(m_trackedWindow->isActive());
    } else {
        updateActive(false);
    }
}

void MWindowState::onWindowActiveChanged()
{
    if (m_trackedWindow)
        updateActive(m_trackedWindow->isActive());
    else
        updateActive(false);
}
