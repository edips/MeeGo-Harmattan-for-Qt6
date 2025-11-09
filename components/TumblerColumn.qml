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

import QtQuick

Item {
    property variant items
    property string label
    property int selectedIndex: 0
    property bool enabled: true

    // private
    property bool privateIsAutoWidth: false
    property bool privateLoopAround: true
}
