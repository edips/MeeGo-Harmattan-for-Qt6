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

import "ButtonGroup.js" as Private
import "UIConstants.js" as UI

Column {
    id: root

    property bool exclusive: true
    property Item checkedButton

    property Component platformStyle: null
    property Component style: null

    width: UI.BUTTON_WIDTH

    Component.onCompleted: {
        Private.create(root, {
            "orientation": Qt.Vertical,
            "exclusive": exclusive,
            "styleComponent": platformStyle? platformStyle : style,
            "singlePos": "",
            "firstPos": "vertical-top",
            "middlePos": "vertical-center",
            "lastPos": "vertical-bottom",
            "resizeChildren": function(self) {
                Private.buttons.forEach(function(item, i) {
                    if (Private.isButton(item) && item.visible) {
                        item.anchors.left = self.left;
                        item.anchors.right = self.right;
                    }
                });
            }
        });
    }

    Component.onDestruction: {
        Private.destroy();
    }
}
