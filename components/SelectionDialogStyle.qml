import QtQuick
import "UIConstants.js" as UI

DialogStyle {
    property alias titleBarFont: titleText.font
    property int titleBarHeight: parseInt(44 * ScaleFactor)
    property color titleBarColor: "white"
    property int titleBarIndent: parseInt(17 * ScaleFactor)
    property int titleBarLineMargin: parseInt(10 * ScaleFactor)

    property bool __portrait: (screen.currentOrientation === 1) || (screen.currentOrientation === 4)

    property int leftMargin:  __portrait ? parseInt(11 * ScaleFactor) : parseInt(160 * ScaleFactor)
    property int rightMargin: __portrait ? parseInt(11 * ScaleFactor) : parseInt(160 * ScaleFactor)

    property alias itemFont: itemText.font
    property int fontXLarge: parseInt(32 * ScaleFactor)
    property int fontLarge: parseInt(28 * ScaleFactor)
    property int fontDefault: parseInt(24 * ScaleFactor)
    property int fontSmall: parseInt(20 * ScaleFactor)
    property int fontXSmall: parseInt(18 * ScaleFactor)
    property int fontXXSmall: parseInt(16 * ScaleFactor)

    property color colorForeground: "#191919"
    property color colorSecondaryForeground: "#8c8c8c"
    property color colorBackground: "#ffffff"
    property color colorSelect: "#7fb133"

    property color commonLabelColor: "white"

    property int itemHeight: parseInt(64 * ScaleFactor)
    property color itemTextColor: "white"
    property color itemSelectedTextColor: "white"
    property int itemLeftMargin: parseInt(16 * ScaleFactor)
    property int itemRightMargin: parseInt(16 * ScaleFactor)

    property int contentSpacing: parseInt(10 * ScaleFactor)

    property int pressDelay: parseInt(350 * ScaleFactor) // ms

    // Background
    property string itemBackground: ""
    property color itemBackgroundColor: "transparent"
    property color itemSelectedBackgroundColor: "#3D3D3D"
    property string itemSelectedBackground: "" // "qrc:/images/meegotouch-list-fullwidth-background-selected"
    property string itemPressedBackground: "qrc:/images/meegotouch-panel-inverted-background-pressed.png"

    property int buttonsTopMargin: parseInt(30 * ScaleFactor) // ToDo: evaluate correct value

    Text {
        id: titleText
        font.family: UI.FONT_FAMILY
        font.pixelSize: UI.FONT_XLARGE
        font.capitalization: Font.MixedCase
        font.bold: false
    }

    Text {
        id: itemText
        font.family: UI.FONT_FAMILY
        font.pixelSize: UI.FONT_DEFAULT_SIZE
        font.capitalization: Font.MixedCase
        font.bold: true
    }
  }
