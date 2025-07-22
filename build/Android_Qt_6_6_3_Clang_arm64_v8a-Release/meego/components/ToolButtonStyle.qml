import QtQuick 2.1
import "UIConstants.js" as UI

ButtonStyle {
    /*
    buttonWidth: 50
    buttonHeight: 42

    // Font
    fontPixelSize: 14
    fontCapitalization: Font.MixedCase
    fontWeight: Font.Bold
    horizontalAlignment: Text.AlignHCenter

    // Background
    backgroundMarginRight: 8
    backgroundMarginLeft: 8
    backgroundMarginTop: 8
    backgroundMarginBottom: 8
    property bool backgroundVisible: true
    */



    buttonWidth: parseInt(186 * ScaleFactor)
    buttonHeight: parseInt(42 * ScaleFactor)
    
    // Font
    fontPixelSize: parseInt(22 * ScaleFactor)
    fontCapitalization: Font.MixedCase
    fontWeight: Font.Bold
    horizontalAlignment: Text.AlignHCenter

    // Background
    backgroundMarginRight: parseInt(15 * ScaleFactor)
    backgroundMarginLeft: parseInt(15 * ScaleFactor)
    backgroundMarginTop: parseInt(15 * ScaleFactor)
    backgroundMarginBottom: parseInt(15 * ScaleFactor)
    property bool backgroundVisible: true


    
    background: backgroundVisible ? "qrc:/images/meegotouch-button-navigationbar-button" + __invertedString + "-background.png" : ""
    pressedBackground: backgroundVisible ? "qrc:/images/meegotouch-button-navigationbar-button" + __invertedString + "-background-pressed.png" : ""
    disabledBackground: backgroundVisible ? "qrc:/images/meegotouch-button-navigationbar-button" + __invertedString + "-background-disabled.png" : ""
}
