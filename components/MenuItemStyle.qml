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
import "UIConstants.js" as UI
import "constants.js" as UIConst

Style {
    id: root
    // Font
    property string fontFamily: UI.DefaultFontFamily
    property int fontPixelSize: UIConst.LIST_TITLE_FONT_SIZE
    property int fontCapitalization: Font.MixedCase
    property int fontWeight: Font.Bold
    property int height: 48

    // Text Color
    property color textColor: inverted ? UI.COLOR_BUTTON_INVERTED_FOREGROUND : UI.COLOR_BUTTON_FOREGROUND
    property color pressedTextColor: inverted ? UI.COLOR_BUTTON_INVERTED_FOREGROUND : UI.COLOR_BUTTON_FOREGROUND
    property color disabledTextColor: "#797979"
    property color checkedTextColor: UI.COLOR_INVERTED_FOREGROUND

    property real leftMargin: 16
    property real rightMargin: 16
    property real topMargin: 0
    property real bottomMargin: 0
    property bool centered: true

    property string position: ""

    property url background: "qrc:/images/meegotouch-list" + __invertedString + "-background" + (position ? "-" + position : "")
    property url pressedBackground: "qrc:/images/" + __colorString + "meegotouch-list" + __invertedString + "-background-pressed" + (position ? "-" + position : "")
    property url selectedBackground: "qrc:/images/" + __colorString + "meegotouch-list" + __invertedString + "-background-selected" + (position ? "-" + position : "")
//    TODO: Add disabled state once the graphics are available
//    property url disabledBackground: "qrc:/images/meegotouch-list" + __invertedString + "-background-disabled" + (position ? "-" + position : "")
}
