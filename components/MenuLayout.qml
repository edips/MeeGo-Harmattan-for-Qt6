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
import com.meego.components 1.0

Item {
    id: root
    anchors.left: parent!==undefined?parent.left:undefined
    anchors.right: parent!==undefined?parent.right:undefined
    height: menuItemColumn.height

    default property alias menuChildren: menuItemColumn.children

    Column {
        id: menuItemColumn

        anchors.left: parent.left
        anchors.right: parent.right
        height: childrenRect.height

        function closeLayout() {
            root.parent.closeMenu();
        }
    }
}
