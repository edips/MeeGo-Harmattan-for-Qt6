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
    property int fontPixelSize: UI.FONT_XXSMALL
    property bool fontBoldProperty: true

    // Color
    property color textColorHighlighted: "#fff"
    property color textColor: "#888"

    property string dividerImage: "qrc:/images/meegotouch-scroll-bubble-divider"+__invertedString
    property string backgroundImage: "qrc:/images/meegotouch-scroll-bubble-background"+__invertedString
    property string arrowImage: "qrc:/images/meegotouch-scroll-bubble-arrow"+__invertedString
}
