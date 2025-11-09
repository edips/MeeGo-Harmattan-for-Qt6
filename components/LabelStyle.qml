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
    // Color
    property color textColor: inverted ? UI.COLOR_INVERTED_FOREGROUND : UI.COLOR_FOREGROUND
    property color selectedTextColor: UI.COLOR_INVERTED_FOREGROUND
    //property color selectionColor: theme.selectionColor
    property color selectionColor: "#0078d7"
    // Font
    property string fontFamily: UI.FONT_FAMILY
    property int fontPixelSize: UI.FONT_DEFAULT_SIZE
}
