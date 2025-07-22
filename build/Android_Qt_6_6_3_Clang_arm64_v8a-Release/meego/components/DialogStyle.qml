// DialogStyle.qml (Qt6)
import QtQuick
import "UIConstants.js" as UI

Style {
    // Margins for dialog container
    property real leftMargin: 88 * ScaleFactor
    property real rightMargin: 88 * ScaleFactor
    property real topMargin: 45 * ScaleFactor
    property real bottomMargin: 16 * ScaleFactor
    property bool centered: false

    // Title bar styling
    property int titleBarHeight: parseInt(56 * ScaleFactor)
    property color titleBarColor: "white"
    property int titleElideMode: Text.ElideRight

    // Buttons area layout
    property int buttonsTopMargin: parseInt(10 * ScaleFactor)
    property int buttonsBottomMargin: 0
    property int buttonsColumnSpacing: parseInt(10 * ScaleFactor)

    // Dialog fade/dim properties
    property real dim: 0.9
    property int fadeInDuration: 250
    property int fadeOutDuration: 250
    property int fadeInDelay: 0
    property int fadeOutDelay: 100

    // Qt6 easings are similar
    property var fadeInEasingType: Easing.InQuint
    property var fadeOutEasingType: Easing.OutQuint
}
