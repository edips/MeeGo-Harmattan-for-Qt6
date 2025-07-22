import QtQuick 2.1

Style {
    // Mouse
    property real mouseMarginLeft: 6 * ScaleFactor
    property real mouseMarginTop: 8 * ScaleFactor
    property real mouseMarginRight: 6 * ScaleFactor
    property real mouseMarginBottom: 10 * ScaleFactor

    // Background
    property int backgroundMarginLeft: 0
    property int backgroundMarginTop: 0
    property int backgroundMarginRight: 0
    property int backgroundMarginBottom: parseInt(14 * ScaleFactor) // XXX: need to crop images

    property int arrowMargin: parseInt(16 * ScaleFactor) // XXX: need to crop images

    // Images
    property url topTailBackground: "qrc:/images/meegotouch-text-editor-top-tail.png"
    property url bottomTailBackground: "qrc:/images/meegotouch-text-editor-bottom-tail.png"
}
