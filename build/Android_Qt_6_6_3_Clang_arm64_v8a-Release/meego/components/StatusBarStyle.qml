import QtQuick
import "."

Style {
    // Background
    property url background: "qrc:/images/meegotouch-statusbar-"// + ((screen.currentOrientation === Screen.Portrait || screen.currentOrientation === Screen.PortraitInverted) ? "portrait" : "landscape") + __invertedString + "-background"

    // Fremantle only buttons to replace Harmattan swipe functionality
    property url closeButton: "qrc:/images/icon-f-statusbar-close"
    property url homeButton: "qrc:/images/icon-f-statusbar-home"

    // Default separation between elements
    property int paddingSmall: parseInt(6 * ScaleFactor)

    // StatusBar default font and colors
    property string defaultFont: "Arial"//theme.constants.Fonts.FONT_FAMILY

    // Indicators fonts and colors
    property string indicatorFont: defaultFont
    property int indicatorFontSize: parseInt(12 * ScaleFactor)//theme.constants.Fonts.FONT_SMALL
    property string indicatorColor: "red"

    property int helpFontSize: parseInt(12 * ScaleFactor)//theme.constants.Fonts.FONT_DEFAULT

    // transitions
    property int visibilityTransitionDuration: 250

    // Fremantle help transitions
    property int showHelpDuration: 1600
    property int helpTransitionDuration: 400

    // Fremantle Battery indicators
    property int batteryLevels: 8
    property int batteryPeriod: 3500
    property url batteryFrames: "qrc:/images/icon-s-status-battery"

    // Fremantle Cell indicators
    property url cellStatus: "qrc:/images/icon-s-status-"
    property url cellRangeMode: "qrc:/images/icon-s-status-"
    property url cellSignalFrames: "qrc:/images/icon-s-status-network"

    // Fremantle Network indicators
    property int wlanPeriod: 2000
    property int numberOfWlanFrames: 5
    property int cellPeriod: 2000
    property int numberOfCellFrames: 8
}
