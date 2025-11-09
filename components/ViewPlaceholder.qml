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

Label {
    enabled: false
    opacity: enabled ? 1.0 : 0.0
    anchors.horizontalCenter: parent.horizontalCenter
    horizontalAlignment: Text.AlignHCenter
    width: parent.width - UiConstants.DefaultMargin * 2
    y: (parent.height - height) / 2
    x: UiConstants.DefaultMargin
    wrapMode: Text.Wrap
    color: "#848284" //theme.inverted ? "#8c8c8c" : "#848284"
    font.family: UiConstants.DefaultFontFamilyLight
    font.pixelSize: 85
}
