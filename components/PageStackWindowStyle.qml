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

WindowStyle {
    property bool cornersVisible: false

    // Background
    property url background: ""

    // Background color is used when no background is set.
    property color backgroundColor: "#E0E1E2" // theme.inverted ? "#000000" :

    property url landscapeBackground: background
    property url portraitBackground: background
    property url portraiteBackground: background

    property int backgroundFillMode: Image.Tile
}
