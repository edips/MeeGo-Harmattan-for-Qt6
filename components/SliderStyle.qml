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

Style {
    // Font
    property string fontFamily: UI.DefaultFontFamily
    property int fontPixelSize: UI.FONT_DEFAULT_SIZE

    // Color
    property color textColor: !inverted? UI.COLOR_INVERTED_FOREGROUND : UI.COLOR_FOREGROUND

    // Background
    property url valueBackground: "qrc:/images/meegotouch-slider-handle-value"+"-background.png"
    property url labelArrowDown: "qrc:/images/meegotouch-slider-handle-label-arrow-down.png"//+__invertedString
    property url labelArrowUp: "qrc:/images/meegotouch-slider-handle-label-arrow-up.png"//+__invertedString
    property url labelArrowLeft: "qrc:/images/meegotouch-slider-handle-label-arrow-left.png"//+__invertedString
    property url labelArrowRight: "qrc:/images/meegotouch-slider-handle-label-arrow-right.png"//+__invertedString
    property url handleBackground: "qrc:/images/meegotouch-slider-handle"+"-background-horizontal.png"
    property url handleBackgroundPressed: "qrc:/images/meegotouch-slider-handle"+"-background-pressed-horizontal.png"
    property url grooveItemBackground: "qrc:/images/meegotouch-slider"+"-background-horizontal.png"
    property url grooveItemElapsedBackground: "qrc:/images/" + "meegotouch-slider-elapsed" + "-background-horizontal.png"

    // Mouse
    property real mouseMarginRight: 0.0
    property real mouseMarginLeft: 0.0
    property real mouseMarginTop: 0.0
    property real mouseMarginBottom: 0.0
}
