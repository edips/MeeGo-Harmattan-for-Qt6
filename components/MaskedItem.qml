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

import QtQuick 2.0

Item {
    id: rootMaskedItem

    property Item mask: null

    default property list<Item> contentChildren: []

    Item {
        id: visualContentHost
        width: parent.width
        height: parent.height
        clip: true
    }

    onContentChildrenChanged: {
        for (var i = visualContentHost.children.length - 1; i >= 0; --i) {
            visualContentHost.children[i].parent = null;
        }

        for (var j = 0; j < contentChildren.length; ++j) {
            contentChildren[j].parent = visualContentHost;
        }
    }

    width: mask ? mask.width : parent.width
    height: parent.height
}
