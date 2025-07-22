import QtQuick
import "."

WindowStyle {
    property bool cornersVisible: false

    // Background
    property url background: ""

    // Background color is used when no background is set.
    property color backgroundColor: "#E0E1E2" // theme.inverted ? "#000000" :

    property url landscapeBackground: background
    property url portraitBackground: background
    property url portraiteBackground: background

    property int backgroundFillMode: Image.Tile
}
