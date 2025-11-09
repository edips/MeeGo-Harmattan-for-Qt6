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

import QtQuick 2.1
import "UIConstants.js" as UI

Style {
    // Font
    // --- CHANGE START ---
    // Changed UiConstants.DefaultFontFamily to UI.FONT_FAMILY
    property string fontFamily: UI.FONT_FAMILY
    // --- CHANGE END ---
    property int fontPixelSize: UI.FONT_DEFAULT_SIZE
    property int fontCapitalization: Font.MixedCase
    property int fontWeight: Font.Normal

    // Text
    property color textColor: "black"
    property int textStyle: Text.Sunken
    property color textStyleColor: "#111111"

    // Dimensions
    property int buttonWidth: 40 // DEPRECATED
    property int buttonPaddingLeft: 4
    property int buttonPaddingRight: 4
    property int buttonHeight: 48

    // Mouse
    property real mouseMarginLeft: (position == "horizontal-left") ? 6 : 0
    property real mouseMarginTop: 4
    property real mouseMarginRight: (position == "horizontal-right") ? 6 : 0
    property real mouseMarginBottom: 17

    // Background
    property int backgroundMarginLeft: 19
    property int backgroundMarginTop: 15
    property int backgroundMarginRight: 19
    property int backgroundMarginBottom: 15

    // Position can take one of the following values:
    // [horizontal-left] [horizontal-center] [horizontal-right]
    property string position: ""

    property string __suffix: (position ? "-" + position : "")

    property url background: "qrc:/images/meegotouch-text-editor" + __suffix + ".png"
    property url pressedBackground: "qrc:/images/meegotouch-text-editor-pressed" + __suffix + ".png"
    property url checkedBackground: "qrc:/images/meegotouch-text-editor-selected" + __suffix + ".png"
}
