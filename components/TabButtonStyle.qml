import QtQuick 2.1
import com.meego.components 1.0
import "UIConstants.js" as UI

ButtonStyle {
    /* The orientation of the button which can take one of the two values:
        [portrait] [landscape]
    */
    //property string screenOrientation: (screen.currentOrientation === Screen.Portrait || screen.currentOrientation === Screen.PortraitInverted) ? "portrait" : "landscape"

    property string screenOrientation: "portrait"

    fontCapitalization: Font.MixedCase 
    fontPixelSize: parseInt(24 * ScaleFactor)
    fontWeight: Font.Normal
    checkedFontWeight: Font.Bold

    buttonHeight: screenOrientation == "portrait"? parseInt(72 * ScaleFactor) : parseInt(56 * ScaleFactor)

    textColor: inverted ? "#CDCDCD" : "#505050"
    pressedTextColor: inverted ? "#ffffff" : "#505050"
    checkedTextColor: inverted ? "#ffffff" : "#000000"

    background: "qrc:/images/meegotouch-tab-" + screenOrientation + "-bottom" + __invertedString + "-background.png" + (position ? "-" + position : "")

    pressedBackground: "qrc:/images/meegotouch-tab-" + screenOrientation + "-bottom" + __invertedString + "-background-pressed.png" + (position ? "-" + position : "")
    disabledBackground: "qrc:/images/meegotouch-tab-" + screenOrientation + "-bottom" + __invertedString + "-background.png" + (position ? "-" + position : "")
    checkedBackground: "qrc:/images/meegotouch-tab-" + screenOrientation + "-bottom" + __invertedString + "-background-selected.png" + (position ? "-" + position : "")
    checkedDisabledBackground: "qrc:/images/meegotouch-tab" + screenOrientation + "-bottom" + __invertedString + "-background.png" + (position ? "-" + position : "")
}
