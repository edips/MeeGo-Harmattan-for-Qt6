import QtQuick 2.1

Style {
    id: root

    property real leftMargin: orientation.orientation === "Portrait" ? 0 : 427 * ScaleFactor
    property real rightMargin: orientation.orientation === "Portrait" ? 0 : 0
    property real topMargin: orientation.orientation === "Portrait" ? 246 * ScaleFactor : 0

    property real bottomMargin: 0

    property real leftPadding: 16 * ScaleFactor
    property real rightPadding: 16 * ScaleFactor
    property real topPadding: 16 * ScaleFactor
    property real bottomPadding: 16 * ScaleFactor

    // fader properties
    property double dim: 0.9
    property int fadeInDuration: parseInt(350 * ScaleFactor) // ms
    property int fadeOutDuration: parseInt(350 * ScaleFactor) // ms
    property int fadeInDelay: 0 // ms
    property int fadeOutDelay: 0 // ms
    property int fadeInEasingType: Easing.InOutQuint
    property int fadeOutEasingType: Easing.InOutQuint
    property url faderBackground: "qrc:/images/meegotouch-menu-dimmer.png"

    property int pressDelay: 0 // ms

    property url background: "qrc:/images/meegotouch-menu-background.png" + __invertedString
//    property url pressedBackground: "qrc:/images/meegotouch-menu" + __invertedString + "-background-pressed.png"
//    property url disabledBackground: "qrc:/images/meegotouch-menu" + __invertedString + "-background-disabled.png"
}
