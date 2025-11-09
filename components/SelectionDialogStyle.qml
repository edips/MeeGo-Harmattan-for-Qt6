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

DialogStyle {
    property alias titleBarFont: titleText.font
    property int titleBarHeight: 44
    property color titleBarColor: "white"
    property int titleBarIndent: 17
    property int titleBarLineMargin: 10

    // Removed __portrait conditional and set a small, consistent margin
    property int leftMargin:  5 // Adjusted to match the tighter margin in the image
    property int rightMargin: 5 // Adjusted to match the tighter margin in the image

    property alias itemFont: itemText.font
    property int fontXLarge: 32
    property int fontLarge: 28
    property int fontDefault: 24
    property int fontSmall: 20
    property int fontXSmall: 18
    property int fontXXSmall: 16

    property color colorForeground: "#191919"
    property color colorSecondaryForeground: "#8c8c8c"
    property color colorBackground: "#ffffff"
    property color colorSelect: "#7fb133"

    property color commonLabelColor: "white"

    property int itemHeight: 64
    property color itemTextColor: "white"
    property color itemSelectedTextColor: "white"
    property int itemLeftMargin: 16
    property int itemRightMargin: 16

    property int contentSpacing: 10

    property int pressDelay: 350 // ms

    // Background
    property string itemBackground: ""
    property color itemBackgroundColor: "transparent"
    property color itemSelectedBackgroundColor: "#3D3D3D"
    property string itemSelectedBackground: "" // "qrc:/images/meegotouch-list-fullwidth-background-selected"
    property string itemPressedBackground: "qrc:/images/meegotouch-panel-inverted-background-pressed.png"

    property int buttonsTopMargin: 30 // ToDo: evaluate correct value

    Text {
        id: titleText
        font.family: UI.FONT_FAMILY
        font.pixelSize: UI.FONT_XLARGE
        font.capitalization: Font.MixedCase
        font.bold: false
    }

    Text {
        id: itemText
        font.family: UI.FONT_FAMILY
        font.pixelSize: UI.FONT_DEFAULT_SIZE
        font.capitalization: Font.MixedCase
        font.bold: true
    }
}
