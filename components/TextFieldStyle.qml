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

Item {
    property alias textFont: textProperties.font
    property color textColor: UI.COLOR_FOREGROUND
    property color selectedTextColor: UI.COLOR_INVERTED_FOREGROUND
    //property color selectionColor: theme.selectionColor
    property color selectionColor: "#0078d7"

    property color promptTextColor: UI.COLOR_SECONDARY_FOREGROUND

    property url background: "qrc:/images/meegotouch-textedit-background.png"
    property url backgroundSelected: "qrc:/images/" + "meegotouch-textedit-background-selected.png"
    //property url backgroundSelected: "qrc:/images/" + theme.colorString + "meegotouch-textedit-background-selected.png"
    property url backgroundDisabled: "qrc:/images/meegotouch-textedit-background-disabled.png"
    property url backgroundError: "qrc:/images/meegotouch-textedit-background-error.png"
    property real backgroundCornerMargin: UI.CORNER_MARGINS

    property real paddingLeft: UI.PADDING_XLARGE
    property real paddingRight: UI.PADDING_XLARGE
    property real paddingTop // DEPRECATED
    property real paddingBottom // DEPRECATED

    property real baselineOffset: 2
    property real defaultWidth: 100

    property real touchExpansionMargin: UI.TOUCH_EXPANSION_MARGIN

    Text {
        id: textProperties
        font.family: UI.DefaultFontFamilyLight
        font.pixelSize: UI.FONT_DEFAULT
        visible: false
    }

}
