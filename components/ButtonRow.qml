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
import "."

import "ButtonGroup.js" as Private
import "UIConstants.js" as UI

Row {
    id: root

    property bool exclusive: true
    property Item checkedButton

    property Component platformStyle: null
    property Component style: null

    // Removed __screenWidth property as it's no longer directly used for root.width
    // The width of the ButtonRow should fill its parent's width for proper layout.
    width: parent.width // Make ButtonRow fill its parent's width

    property int __visibleButtons
    property bool __expanding: true // Layout hint used but ToolBarLayout
    property int __maxButtonSize: UI.BUTTON_WIDTH

    // Set visible to true by default, if it was set to false for debugging
    visible: true

    onWidthChanged: {
        if (width > 0) {
            Qt.callLater(function() { Private.resizeChildren(root) });
        }
    }

    Component.onCompleted: {
        Private.create(root, {
            "orientation": Qt.Horizontal,
            "exclusive": exclusive,
            "styleComponent": platformStyle ? platformStyle : style,
            "singlePos": "",
            "firstPos": "horizontal-left",
            "middlePos": "horizontal-center",
            "lastPos": "horizontal-right",
            "resizeChildren": function(self) {
                self.__visibleButtons = Private.visibleButtons;
                if (self.__visibleButtons === 0) {
                    return;
                }
                var extraPixels = self.width % self.__visibleButtons;
                var buttonSize = (self.width - extraPixels) / self.__visibleButtons;
                if (buttonSize > __maxButtonSize) {
                    buttonSize = __maxButtonSize;
                    extraPixels = self.width - (buttonSize * self.__visibleButtons);
                }
                Private.buttons.forEach(function(item, i) {
                    if (item.visible && Private.isButton(item)) {
                        if (extraPixels > 0) {
                            item.width = buttonSize + 1;
                            extraPixels--;
                        } else {
                            item.width = buttonSize;
                        }
                    }
                });
            }
        });
        if (width > 0) {
            Private.resizeChildren(root);
        }
    }

    // Keep the Connections to orientation.orientationChanged if you still need to react to orientation string changes
    // for other logic in ButtonGroup.js, but it won't directly affect ButtonRow's width anymore.
    Connections {
        target: orientation // 'orientation' is the context property from main.cpp
        function onOrientationChanged() {
            //console.log("ButtonRow.qml: Orientation changed to", orientation.orientation);
            Private.updateButtons(); // Trigger update when orientation changes
        }
    }

    Component.onDestruction: {
        Private.destroy();
    }
}
