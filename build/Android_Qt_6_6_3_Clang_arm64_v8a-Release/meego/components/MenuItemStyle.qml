import QtQuick 2.1
import "UIConstants.js" as UI

Style {
    id: root
    // Font
    property string fontFamily: UI.DefaultFontFamily
    property int fontPixelSize: UI.FONT_DEFAULT_SIZE
    property int fontCapitalization: Font.MixedCase
    property int fontWeight: Font.Bold
    property int height: parseInt(80 * ScaleFactor)

    // Text Color
    property color textColor: inverted ? UI.COLOR_BUTTON_INVERTED_FOREGROUND : UI.COLOR_BUTTON_FOREGROUND
    property color pressedTextColor: inverted ? UI.COLOR_BUTTON_INVERTED_FOREGROUND : UI.COLOR_BUTTON_FOREGROUND
    property color disabledTextColor: "#797979"
    property color checkedTextColor: UI.COLOR_INVERTED_FOREGROUND

    property real leftMargin: 24 * ScaleFactor
    property real rightMargin: 24 * ScaleFactor
    property real topMargin: 0
    property real bottomMargin: 0
    property bool centered: true

    property string position: ""

    property url background: "qrc:/images/meegotouch-list" + __invertedString + "-background" + (position ? "-" + position : "")
    property url pressedBackground: "qrc:/images/" + __colorString + "meegotouch-list" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
    property url selectedBackground: "qrc:/images/" + __colorString + "meegotouch-list" + __invertedString + "-background-selected" + (position ? "-" + position : "")
//    TODO: Add disabled state once the graphics are available
//    property url disabledBackground: "qrc:/images/meegotouch-list" + __invertedString + "-background-disabled" + (position ? "-" + position : "")
}
