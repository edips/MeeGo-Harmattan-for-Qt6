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

// ToolButton is a push-button style button intended for use with toolbars.

import QtQuick

Button {
    id: root

    property Style platformStyle: SheetButtonStyle {}

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    implicitWidth: platformStyle.buttonWidth
    implicitHeight: platformStyle.buttonHeight
}
