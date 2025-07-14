import QtQuick
import "."
import "UIConstants.js" as UI

Item {
    id: button

    // Common public API
    property bool checked: false
    property bool checkable: false
    property alias pressed: mouseArea.pressed
    property alias text: label.text
    property url iconSource
    property alias platformMouseAnchors: mouseArea.anchors

    signal clicked

    // Used in ButtonGroup.js to set the segmented look on the buttons.
    property string __buttonType

    // Styling for the Button
    property Style platformStyle: ButtonStyle {}

    // Deprecated, TODO remove
    property alias style: button.platformStyle

    implicitWidth: platformStyle.buttonWidth
    implicitHeight: platformStyle.buttonHeight
    width: implicitWidth

    property alias font: label.font

    //private property
    property bool __dialogButton: false

    BorderImage {
        id: background
        anchors.fill: parent
        border {
            left: button.platformStyle.backgroundMarginLeft
            top: button.platformStyle.backgroundMarginTop
            right: button.platformStyle.backgroundMarginRight
            bottom: button.platformStyle.backgroundMarginBottom
        }

        source: __dialogButton ? (pressed ? button.platformStyle.pressedDialog : button.platformStyle.dialog) : !enabled ? (checked ? button.platformStyle.checkedDisabledBackground : button.platformStyle.disabledBackground) : pressed ? button.platformStyle.pressedBackground : checked ? button.platformStyle.checkedBackground : button.platformStyle.background
    }

    Image {
        id: icon
        anchors.left: label.visible ? parent.left : undefined
        anchors.leftMargin: label.visible ? UI.MARGIN_XLARGE : 0
        anchors.centerIn: label.visible ? undefined : parent

        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -1

        source: button.iconSource

        visible: source !== ""
    }

    Label {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        //anchors.left: icon.visible ? icon.right : parent.left
        //anchors.leftMargin: icon.visible ? UI.PADDING_XLARGE : UI.BUTTON_LABEL_MARGIN
        //anchors.right: parent.right
        //anchors.rightMargin: UI.BUTTON_LABEL_MARGIN

        horizontalAlignment: icon.visible ? Text.AlignLeft : button.platformStyle.horizontalAlignment
        elide: Text.ElideRight

        font.family: button.platformStyle.fontFamily
        font.weight: checked ? button.platformStyle.checkedFontWeight : button.platformStyle.fontWeight
        font.pixelSize: button.platformStyle.fontPixelSize
        font.capitalization: button.platformStyle.fontCapitalization
        color: !enabled ? button.platformStyle.disabledTextColor : pressed ? button.platformStyle.pressedTextColor : checked ? button.platformStyle.checkedTextColor : button.platformStyle.textColor
        text: ""
        visible: text !== ""
    }

    MouseArea {
        id: mouseArea
        anchors {
            fill: parent
            rightMargin: (platformStyle.position != "horizontal-center" && platformStyle.position != "horizontal-left") ? platformStyle.mouseMarginRight : 0
            leftMargin: (platformStyle.position != "horizontal-center" && platformStyle.position != "horizontal-right") ? platformStyle.mouseMarginLeft : 0
            topMargin: (platformStyle.position != "vertical-center" && platformStyle.position != "vertical-bottom") ? platformStyle.mouseMarginTop : 0
            bottomMargin: (platformStyle.position != "vertical-center" && platformStyle.position != "vertical-top") ? platformStyle.mouseMarginBottom : 0
        }
        onClicked: if (button.checkable)
            button.checked = !button.checked
    }
    Component.onCompleted: mouseArea.clicked.connect(clicked)
}
