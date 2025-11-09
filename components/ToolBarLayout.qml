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
import "."
import "UIConstants.js" as UI
import "ToolBarLayout.js" as Layout

Item {
    id: toolbarLayout

    width: visible && parent ? parent.width : 0
    height: visible && parent ? parent.height : 0

    onChildrenChanged: Layout.childrenChanged()
    Component.onCompleted: Layout.layout()

    // The onWidthChanged and onHeightChanged handlers are connected to the layout function
    // using Qt.callLater to prevent an infinite loop that would otherwise occur.
    onWidthChanged: Qt.callLater(Layout.layout)
    onHeightChanged: Qt.callLater(Layout.layout)
}
