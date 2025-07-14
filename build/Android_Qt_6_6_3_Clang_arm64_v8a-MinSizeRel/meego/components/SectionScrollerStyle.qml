import QtQuick 1.1
import "UIConstants.js" as UI

Style {

    // Font
    property int fontPixelSize: UI.FONT_XXSMALL
    property bool fontBoldProperty: true

    // Color
    property color textColorHighlighted: "#fff"
    property color textColor: "#888"

    property string dividerImage: "qrc:/images/meegotouch-scroll-bubble-divider"+__invertedString
    property string backgroundImage: "qrc:/images/meegotouch-scroll-bubble-background"+__invertedString
    property string arrowImage: "qrc:/images/meegotouch-scroll-bubble-arrow"+__invertedString
}
