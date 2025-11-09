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

// DialogStyle.qml (Qt6)
import QtQuick
import "UIConstants.js" as UI

Style {
    // Margins for dialog container
    property real leftMargin: 24
    property real rightMargin: 24
    property real topMargin: 24
    property real bottomMargin: 8
    property bool centered: false

    // Title bar styling
    property int titleBarHeight: 20
    property color titleBarColor: "white"
    property int titleElideMode: Text.ElideRight

    // Buttons area layout
    property int buttonsTopMargin: 24
    property int buttonsBottomMargin: 8
    property int buttonsColumnSpacing: 8

    // Dialog fade/dim properties
    property real dim: 0.9
    property int fadeInDuration: 250
    property int fadeOutDuration: 250
    property int fadeInDelay: 0
    property int fadeOutDelay: 100

    // Qt6 easings are similar
    property var fadeInEasingType: Easing.InQuint
    property var fadeOutEasingType: Easing.OutQuint
}
