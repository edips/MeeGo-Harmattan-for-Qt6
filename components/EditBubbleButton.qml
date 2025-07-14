import QtQuick 2.1
import com.meego.components 1.0

BorderImage {
    id: button

    signal clicked()
    property alias text: label.text
    property bool selected: false
    smooth: true

    property Style platformStyle: EditBubbleButtonStyle {}

    width: label.width + platformStyle.buttonPaddingLeft +
           platformStyle.buttonPaddingRight +
           platformStyle.backgroundMarginLeft +
           platformStyle.backgroundMarginRight
    height: platformStyle.buttonHeight +
            platformStyle.backgroundMarginTop +
            platformStyle.backgroundMarginBottom

    // XXX: meegotouch-text-editor-selected image is missing
    source: mouseArea.pressed ?
                platformStyle.pressedBackground :
            (selected && platformStyle.position !== "") ?
                platformStyle.checkedBackground :
                platformStyle.background

    border {
        left: platformStyle.backgroundMarginLeft
        top: platformStyle.backgroundMarginTop
        right: platformStyle.backgroundMarginRight
        bottom: platformStyle.backgroundMarginBottom
    }

    Text {
        id: label
        anchors.centerIn: parent

        color: platformStyle.textColor

        font.family: platformStyle.fontFamily
        font.weight: platformStyle.fontWeight
        font.pixelSize: platformStyle.fontPixelSize
        font.capitalization: platformStyle.fontCapitalization

        style: platformStyle.textStyle
        styleColor: platformStyle.textStyleColor
    }

    MouseArea {
        id: mouseArea
        enabled: button.enabled
        anchors {
            fill: parent
            leftMargin: platformStyle.mouseMarginLeft
            topMargin: platformStyle.mouseMarginTop
            rightMargin: platformStyle.mouseMarginRight
            bottomMargin: platformStyle.mouseMarginBottom
        }
    }
    Component.onCompleted: mouseArea.clicked.connect(clicked)
}
