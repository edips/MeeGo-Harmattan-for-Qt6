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
