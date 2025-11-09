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

Text {
    id: root

    // Styling for the Button
    property Style platformStyle: LabelStyle {}

    //Deprecated, TODO Remove this on w13
    //property alias style: root.platformStyle

    font.family: platformStyle.fontFamily
    font.pixelSize: platformStyle.fontPixelSize
    color: platformStyle.textColor

    wrapMode: Text.Wrap
}
