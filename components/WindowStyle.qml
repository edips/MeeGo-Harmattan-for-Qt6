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
import "."

Style {
    property color colorBackground: "#E0E1E2"

    // pseudo buttons size
    property int buttonWidth: 30//theme.constants.QtcCore.WINDOW_BUTTON_WIDTH
    property int buttonHeight: 50//theme.constants.QtcCore.WINDOW_BUTTON_HEIGHT

    // pseudo buttons position
    property double buttonVerticalMargin: 0
    property double buttonHorizontalMargin: 0

    // ppseudo buttons index
    property int buttonZIndex: 0//theme.constants.QtcCore.STATUS_BAR_Z_INDEX
}
