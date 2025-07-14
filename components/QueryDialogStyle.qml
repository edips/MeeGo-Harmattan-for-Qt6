import QtQuick
import "UIConstants.js" as UI

DialogStyle {
    property string titleFontFamily: UI.FONT_FAMILY
    property int titleFontPixelSize: UI.FONT_XLARGE
    property int titleFontCapitalization: Font.MixedCase
    property bool titleFontBold: true
    property color titleTextColor: "white"

    property int contentFieldMinSize: parseInt(24 * ScaleFactor)

    //spacing
    property int contentTopMargin: parseInt(21 * ScaleFactor)
    property int buttonTopMargin: parseInt(38 * ScaleFactor)

    property int titleColumnSpacing: parseInt(17 * ScaleFactor)

    //properties inherited by DialogStyle
    buttonsColumnSpacing: parseInt(16 * ScaleFactor)
    leftMargin: parseInt(33 * ScaleFactor)
    rightMargin: parseInt(33 * ScaleFactor)

    property string messageFontFamily: UI.FONT_FAMILY
    property int messageFontPixelSize: UI.FONT_DEFAULT
    property color messageTextColor: "#ffffff"

    // fader properties
    property double dim: 0.9
    property int fadeInDuration: 250 // ms
    property int fadeOutDuration: 250 // ms

    property int fadeInDelay: 0 // ms
    property int fadeOutDelay: 100 // ms


}
