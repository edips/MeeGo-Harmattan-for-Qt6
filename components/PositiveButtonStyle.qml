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
    textColor: UI.COLOR_BUTTON_INVERTED_FOREGROUND
    pressedTextColor: UI.COLOR_BUTTON_SECONDARY_FOREGROUND
    disabledTextColor: UI.COLOR_BUTTON_INVERTED_DISABLED_FOREGROUND
    checkedTextColor: UI.COLOR_BUTTON_INVERTED_FOREGROUND

    // Background
    background: "qrc:/images/meegotouch-button-positive-background.png"
    pressedBackground: "qrc:/images/meegotouch-button-positive-background-pressed.png"
    disabledBackground: "qrc:/images/meegotouch-button-positive-background-disabled.png"
    checkedBackground: "qrc:/images/meegotouch-button-positive-background-selected.png"
    checkedDisabledBackground: "qrc:/images/meegotouch-button-positive-background-disabled-selected.png"
}
