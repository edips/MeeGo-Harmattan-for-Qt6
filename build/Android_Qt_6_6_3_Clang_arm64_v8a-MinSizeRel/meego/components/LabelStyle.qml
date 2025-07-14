import QtQuick
import "UIConstants.js" as UI

Style {
    // Color
    property color textColor: inverted ? UI.COLOR_INVERTED_FOREGROUND : UI.COLOR_FOREGROUND

    // Font
    property string fontFamily: UI.FONT_FAMILY
    property int fontPixelSize: UI.FONT_DEFAULT_SIZE
}
