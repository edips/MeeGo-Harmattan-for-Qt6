import QtQuick 2.1
import "UIConstants.js" as UI

Style {
    // Font
    property string fontFamily: UiConstants.DefaultFontFamily
    property int fontPixelSize: UI.FONT_DEFAULT_SIZE
    property int fontCapitalization: Font.MixedCase
    property int fontWeight: Font.Normal

    // Text
    property color textColor: "black"
    property int textStyle: Text.Sunken
    property color textStyleColor: "#111111"

    // Dimensions
    property int buttonWidth: parseInt(40 * ScaleFactor) // DEPRECATED
    property int buttonPaddingLeft: parseInt(8 * ScaleFactor)
    property int buttonPaddingRight: parseInt(8 * ScaleFactor)
    property int buttonHeight: parseInt(56 * ScaleFactor)

    // Mouse
    property real mouseMarginLeft: (position == "horizontal-left") ? 6  * ScaleFactor: 0
    property real mouseMarginTop: 8 * ScaleFactor
    property real mouseMarginRight: (position == "horizontal-right") ? 6 * ScaleFactor : 0
    property real mouseMarginBottom: 10 * ScaleFactor

    // Background
    property int backgroundMarginLeft: parseInt(19 * ScaleFactor)
    property int backgroundMarginTop: parseInt(15 * ScaleFactor)
    property int backgroundMarginRight: parseInt(19 * ScaleFactor)
    property int backgroundMarginBottom: parseInt(15 * ScaleFactor)

    // Position can take one of the following values:
    // [horizontal-left] [horizontal-center] [horizontal-right]
    property string position: ""

    property string __suffix: (position ? "-" + position : "")

    property url background: "image://theme/meegotouch-text-editor" + __suffix
    property url pressedBackground: "image://theme/meegotouch-text-editor-pressed" + __suffix
    property url checkedBackground: "image://theme/meegotouch-text-editor-selected" + __suffix
}
