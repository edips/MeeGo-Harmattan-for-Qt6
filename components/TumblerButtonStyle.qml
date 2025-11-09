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
import "constants.js" as UI

ButtonStyle {
    // Text Color
    textColor: inverted ? UI.COLOR_BUTTON_INVERTED_FOREGROUND : UI.COLOR_BUTTON_FOREGROUND
    pressedTextColor: UI.COLOR_BUTTON_SECONDARY_FOREGROUND
    disabledTextColor: inverted ? UI.COLOR_BUTTON_INVERTED_DISABLED_FOREGROUND : UI.COLOR_BUTTON_DISABLED_FOREGROUND

    // Background
    background: "qrc:/images/meegotouch-button" + __invertedString + "-background"
    pressedBackground: "qrc:/images/" + __colorString + "meegotouch-button" + __invertedString + "-background-pressed.png"
    disabledBackground: "qrc:/images/" + __colorString + "meegotouch-button" + __invertedString + "-background-disabled.png"
}
