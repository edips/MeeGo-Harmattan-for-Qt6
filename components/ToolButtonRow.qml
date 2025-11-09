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
import "UIConstants.js" as UI

Row{
    id: row

    property bool __expanding: true // Layout hint used but ToolBarLayout

    width: Math.min(parent.width, childrenRect.width)
    spacing: UI.PADDING_LARGE
    anchors.verticalCenter: parent.verticalCenter
}

