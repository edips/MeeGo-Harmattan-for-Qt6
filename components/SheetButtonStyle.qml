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

ButtonStyle {
    buttonWidth: UI.BUTTON_WIDTH
    buttonHeight: UI.BUTTON_HEIGHT
    
    // Font
    fontPixelSize: UI.FONT_DEFAULT_SIZE
    fontCapitalization: Font.MixedCase
    fontWeight: Font.Bold
    horizontalAlignment: Text.AlignHCenter

    // Background
    property int backgroundMarginRight: 25
    property int backgroundMarginLeft: 25
    property int backgroundMarginTop: 0
    property int backgroundMarginBottom: 0
    
    background: "image://theme/meegotouch-sheet-button"+__invertedString+"-background"
    pressedBackground: "image://theme/meegotouch-sheet-button"+__invertedString+"-background-pressed"
    disabledBackground: "image://theme/meegotouch-sheet-button"+__invertedString+"-background-disabled"
}
