// MenuItem is a component that is used in menus.

import QtQuick 2.1
import com.meego.components 1.0
import "UIConstants.js" as UI

Item {
    id: root

    // Common API
    property string text
    signal clicked
    property alias pressed: mouseArea.pressed

    // platformStyle API
    property Style platformStyle: MenuItemStyle{
        position: __isOnlyVisibleChild() ? ""
      : __firstVisibleChild() === root ? "vertical-top.png"
      : __lastVisibleChild() === root ? "vertical-bottom.png"
      : "vertical-center.png"
    }
    property alias style: root.platformStyle // Deprecated

    width: parent ? parent.width: 0
    height: ( root.platformStyle.height === 0 ) ?
            root.platformStyle.topMargin + menuText.contentHeight + root.platformStyle.bottomMargin :
            root.platformStyle.topMargin + root.platformStyle.height + root.platformStyle.bottomMargin

    function __isOnlyVisibleChild() {
        var childList = root.parent.children;
        for (var i = 0; i < childList.length; i++) {
            var child = childList[i];
            if (child !== root && child.visible)
                return false;
        }
        return root.visible;
    }

    function __firstVisibleChild() {
        var childList = root.parent.children;
        for (var i = 0; i < childList.length; i++) {
            var child = childList[i];
            if (child.visible)
                return child;
        }
        return null;
    }

    function __lastVisibleChild() {
        var childList = root.parent.children;
        for (var i = childList.length - 1; i >= 0; i--) {
            var child = childList[i];
            if (child.visible)
                return child;
        }
        return null;
    }

/*
    Rectangle {
       id: backgroundRec
       // ToDo: remove hardcoded values
       color: pressed ? "darkgray" : "transparent"
       anchors.fill : root
       opacity : 0.5
    }
*/
    BorderImage {
       id: backgroundImage
       source:   // !enabled ? root.platformStyle.disabledBackground :
                 !pressed ? root.platformStyle.background :
                 (root.platformStyle.__colorString === "") ? root.platformStyle.pressedBackground : root.platformStyle.selectedBackground;

       anchors.fill : root
       border { left: parseInt(22 * ScaleFactor); top: parseInt(22 * ScaleFactor);
                right: parseInt(22 * ScaleFactor); bottom: parseInt(22 * ScaleFactor) }
    }

    Text {
        id: menuText
        text: parent.text
        elide: Text.ElideRight
        font.family : root.platformStyle.fontFamily
        font.pixelSize : root.platformStyle.fontPixelSize
        font.weight: root.platformStyle.fontWeight
        color: !root.enabled ? root.platformStyle.disabledTextColor :
                root.pressed ? root.platformStyle.pressedTextColor :
                root.platformStyle.textColor

        anchors.topMargin : root.platformStyle.topMargin
        anchors.bottomMargin : root.platformStyle.bottomMargin
        anchors.leftMargin : root.platformStyle.leftMargin
        anchors.rightMargin : root.platformStyle.rightMargin

        anchors.top : root.platformStyle.centered ? undefined : root.top
        anchors.bottom : root.platformStyle.centered ? undefined : root.bottom
        anchors.left : root.left
        anchors.right : root.right
//        anchors.centerIn : parent.centerIn
        anchors.verticalCenter : root.platformStyle.centered ? parent.verticalCenter : undefined
  }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: { if (parent.enabled) parent.clicked();}
    }

    onClicked: if (parent) parent.closeLayout();
}
