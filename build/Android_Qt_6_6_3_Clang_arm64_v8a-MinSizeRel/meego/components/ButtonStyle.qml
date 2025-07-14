import QtQuick
import "UIConstants.js" as UI

Style {
    // Font
    property string fontFamily: UI.FONT_FAMILY
    property int fontPixelSize: UI.FONT_DEFAULT_SIZE
    property int fontCapitalization: Font.MixedCase
    property int fontWeight: Font.Bold
    property int checkedFontWeight: Font.Bold
    property int horizontalAlignment: Text.AlignHCenter

    // Text Color
    property color textColor: inverted ? UI.COLOR_BUTTON_INVERTED_FOREGROUND : UI.COLOR_BUTTON_FOREGROUND
    property color pressedTextColor: UI.COLOR_BUTTON_SECONDARY_FOREGROUND
    property color disabledTextColor: UI.COLOR_BUTTON_DISABLED_FOREGROUND
    property color checkedTextColor: UI.COLOR_BUTTON_INVERTED_FOREGROUND

    // Dimensions
    property int buttonWidth: UI.BUTTON_WIDTH
    property int buttonHeight: UI.BUTTON_HEIGHT

    // Mouse
    property real mouseMarginRight: 0.0
    property real mouseMarginLeft: 0.0
    property real mouseMarginTop: 0.0
    property real mouseMarginBottom: 0.0

    // Background
    property int backgroundMarginRight: parseInt(22 * ScaleFactor)
    property int backgroundMarginLeft: parseInt(22 * ScaleFactor)
    property int backgroundMarginTop: parseInt(22 * ScaleFactor)
    property int backgroundMarginBottom: parseInt(22 * ScaleFactor)

    /* The position property can take one of the following values:

        [horizontal-left] [horizontal-center] [horizontal-right]

        [vertical-top]
        [vertical-center]
        [vertical-bottom]
     */
    property string position: ""

    property url background: "qrc:/images/meegotouch-button" + __invertedString + "-background.png" + (position ? "-" + position : "")
    property url pressedBackground: "qrc:/images/meegotouch-button" + __invertedString + "-background-pressed.png" + (position ? "-" + position : "")
    property url disabledBackground: "qrc:/images/meegotouch-button" + __invertedString + "-background-disabled.png" + (position ? "-" + position : "")
    property url checkedBackground: "qrc:/images/meegotouch-button" + __invertedString + "-background-selected.png" + (position ? "-" + position : "")
    property url checkedDisabledBackground: "qrc:/images/meegotouch-button" + __invertedString + "-background-disabled-selected.png" + (position ? "-" + position : "")
    property url dialog: "qrc:/images/meegotouch-dialog-button-negative.png"
    property url pressedDialog: "qrc:/images/meegotouch-dialog-button-negative-pressed.png"
}
