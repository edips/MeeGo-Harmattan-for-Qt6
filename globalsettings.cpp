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

/***************************************************************************
  Copyright          : Edip Ahmet Taşkın
  Email                : geosoft66@gmail.com
 ***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

#include "globalsettings.h"
#include <QDebug>
#include <QCoreApplication>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStringList>
#include <QQmlEngine>
#include <QDir>

GlobalSettings::GlobalSettings(QObject *parent)
    : QObject(parent)
    , mMenuFocus( false )
    , mDialogFocus( false )
    , mContextmenuFocus( false )
    , mSheetFocus( false )
{
    // Initialize Values
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
}

// Save Settings
GlobalSettings::~GlobalSettings()
{
}

// menuFocus
bool GlobalSettings::menuFocus() const
{
    return mMenuFocus;
}
void GlobalSettings::setMenuFocus( const bool &menuFocus )
{
    if ( mMenuFocus == menuFocus )
        return;
    mMenuFocus = menuFocus;
    Q_EMIT menuFocusChanged( menuFocus );
}

// sheetFocus
bool GlobalSettings::sheetFocus() const
{
    return mSheetFocus;
}
void GlobalSettings::setSheetFocus( const bool &sheetFocus )
{
    if ( mSheetFocus == sheetFocus )
        return;
    mSheetFocus = sheetFocus;
    Q_EMIT sheetFocusChanged( sheetFocus );
}

// contextmenuFocus
bool GlobalSettings::contextmenuFocus() const
{
    return mContextmenuFocus;
}
void GlobalSettings::setContextmenuFocus( const bool &contextmenuFocus )
{
    if ( mContextmenuFocus == contextmenuFocus )
        return;
    mContextmenuFocus = contextmenuFocus;
    Q_EMIT contextmenuFocusChanged( contextmenuFocus );
}

// DialogFocus
bool GlobalSettings::dialogFocus() const
{
    return mDialogFocus;
}
void GlobalSettings::setDialogFocus( const bool &dialogFocus )
{
    if ( mDialogFocus == dialogFocus )
        return;
    mDialogFocus = dialogFocus;
    Q_EMIT dialogFocusChanged( dialogFocus );
}


