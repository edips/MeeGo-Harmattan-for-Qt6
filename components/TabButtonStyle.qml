/****************************************************************************
**
** Originally part of the MeeGo Harmattan Qt Components project
** © 2011 Nokia Corporation and/or its subsidiary(-ies). All rights reserved.
**
** Licensed under the BSD License.
** See the original license text for redistribution and use conditions.
**
** Ported from MeeGo Harmattan (Qt 4.7) to Qt 6 by Edip Ahmet Taskin, 2025.
**
****************************************************************************/

import QtQuick
import com.meego.components 1.0
import "UIConstants.js" as UI

ButtonStyle {
    /* The orientation of the button which can take one of the two values:
        [portrait] [landscape]
    */
    property string screenOrientation: orientation.orientation === "Portrait" ? "portrait" : "landscape"

    fontCapitalization: Font.MixedCase 
    fontPixelSize: UI.FONT_DEFAULT_SIZE
    fontWeight: Font.Normal
    checkedFontWeight: Font.Bold

    buttonHeight: Device.gridUnit

    textColor: inverted ? "#CDCDCD" : "#505050"
    pressedTextColor: inverted ? "#ffffff" : "#505050"
    checkedTextColor: inverted ? "#ffffff" : "#000000"

    background: "qrc:/images/meegotouch-tab-" + screenOrientation + "-bottom" + __invertedString + "-background" + (position ? "-" + position : "") + ".png"

    pressedBackground: "qrc:/images/meegotouch-tab-" + screenOrientation + "-bottom" + __invertedString + "-background-pressed" + (position ? "-" + position : "") + ".png"
    disabledBackground: "qrc:/images/meegotouch-tab-" + screenOrientation + "-bottom" + __invertedString + "-background" + (position ? "-" + position : "") + ".png"
    checkedBackground: "qrc:/images/meegotouch-tab-" + screenOrientation + "-bottom" + __invertedString + "-background-selected" + (position ? "-" + position : "") + ".png"
    checkedDisabledBackground: "qrc:/images/meegotouch-tab" + screenOrientation + "-bottom" + __invertedString + "-background" + (position ? "-" + position : "") + ".png"
}
