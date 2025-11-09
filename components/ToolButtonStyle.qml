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
    buttonWidth: 186
    buttonHeight: 40
    // Font
    fontPixelSize: 22
    fontCapitalization: Font.MixedCase
    fontWeight: Font.Bold
    horizontalAlignment: Text.AlignHCenter
    // Background
    backgroundMarginRight: 15
    backgroundMarginLeft: 15
    backgroundMarginTop: 15
    backgroundMarginBottom: 15
    property bool backgroundVisible: true
    background: backgroundVisible ? "qrc:/images/meegotouch-button-navigationbar-button" + __invertedString + "-background.png" : ""
    pressedBackground: backgroundVisible ? "qrc:/images/meegotouch-button-navigationbar-button" + __invertedString + "-background-pressed.png" : ""
    disabledBackground: backgroundVisible ? "qrc:/images/meegotouch-button-navigationbar-button" + __invertedString + "-background-disabled.png" : ""
}
