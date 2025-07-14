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

    property int __screenWidth: (screen.rotation === 0 || screen.rotation === 180 ? screen.displayWidth : screen.displayHeight) - 2 * UI.MARGIN_XLARGE
    property int __visibleButtons
    property bool __expanding: true // Layout hint used but ToolBarLayout
    property int __maxButtonSize: UI.BUTTON_WIDTH

    width: Math.min(__visibleButtons * UI.BUTTON_WIDTH, __screenWidth)
    Component.onCompleted: {
        Private.create(root, {
            "orientation": Qt.Horizontal,
            "exclusive": exclusive,
            "styleComponent": platformStyle? platformStyle : style,
            "singlePos": "",
            "firstPos": "horizontal-left",
            "middlePos": "horizontal-center",
            "lastPos": "horizontal-right",
            "resizeChildren": function(self) {
               self.__visibleButtons = Private.visibleButtons;
               var extraPixels = self.width % Private.visibleButtons;
               var buttonSize = Math.min(__maxButtonSize, (self.width - extraPixels) / Private.visibleButtons);
               Private.buttons.forEach(function(item, i) {
                   if (!item || !item.visible || !Private.isButton(item))
                       return;
                   if (extraPixels > 0) {
                       item.width = buttonSize + 1;
                       extraPixels--;
                   } else {
                       item.width = buttonSize;
                   }
               });
           }
        });
        //Private.updateButtons;
    }

    Component.onDestruction: {
        Private.destroy();
    }
}
