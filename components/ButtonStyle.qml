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

Style {
    // Font
    property string fontFamily: UI.FONT_FAMILY
    property int fontPixelSize: UI.FONT_DEFAULT_SIZE
    property int fontCapitalization: Font.MixedCase
    property int fontWeight: Font.Bold
    property int checkedFontWeight: Font.Bold
    property int horizontalAlignment: Text.AlignHCenter

    // Text Color
    property color textColor: inverted ? UI.COLOR_BUTTON_INVERTED_FOREGROUND : UI.COLOR_BUTTON_FOREGROUND
    property color pressedTextColor: UI.COLOR_BUTTON_SECONDARY_FOREGROUND
    property color disabledTextColor: UI.COLOR_BUTTON_DISABLED_FOREGROUND
    property color checkedTextColor: UI.COLOR_BUTTON_INVERTED_FOREGROUND

    // Dimensions
    property int buttonWidth: UI.BUTTON_WIDTH
    property int buttonHeight: UI.BUTTON_HEIGHT
    property int iconSize: Device.gridUnit <= 48 ? 20 : 24

    // Mouse
    property real mouseMarginRight: 0.0
    property real mouseMarginLeft: 0.0
    property real mouseMarginTop: 0.0
    property real mouseMarginBottom: 0.0

    // Background
    property int backgroundMarginRight: 25
    property int backgroundMarginLeft: 25
    property int backgroundMarginTop: 0
    property int backgroundMarginBottom: 0

    /* The position property can take one of the following values:

        [horizontal-left] [horizontal-center] [horizontal-right]

        [vertical-top]
        [vertical-center]
        [vertical-bottom]
     */
    property string position: ""

    property url background: "qrc:/images/meegotouch-button" + __invertedString + "-background" + (position ? "-" + position : "") + ".png"
    property url pressedBackground: "qrc:/images/meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "") + ".png"
    property url disabledBackground: "qrc:/images/meegotouch-button" + __invertedString + "-background-disabled" + (position ? "-" + position : "") + ".png"
    property url checkedBackground: "qrc:/images/meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "") + ".png"
    property url checkedDisabledBackground: "qrc:/images/meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "") + ".png"
    property url dialog: "qrc:/images/meegotouch-dialog-button-negative.png"
    property url pressedDialog: "qrc:/images/meegotouch-dialog-button-negative-pressed.png"



    property url positiveDialog: "qrc:/images/meegotouch-dialog-button-positive"
    property url pressedPositiveDialog:  "qrc:/images/meegotouch-dialog-button-positive-pressed"
    property url negativeDialog: "qrc:/images/meegotouch-dialog-button-negative"
    property url pressedNegativeDialog:  "qrc:/images/meegotouch-dialog-button-negative-pressed"
}


