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

Style {
    id: root
    property real leftMargin: orientation.orientation === "Portrait" ? 0 : 427
    property real rightMargin: orientation.orientation === "Portrait" ? 0 : 0
    property real topMargin: orientation.orientation === "Portrait" ? 246 : 0
    property real bottomMargin: 0
    property real leftPadding: 16
    property real rightPadding: 16
    property real topPadding: 16
    property real bottomPadding: 16
    // fader properties
    property double dim: 0.9
    property int fadeInDuration: 350 // ms
    property int fadeOutDuration: 350 // ms
    property int fadeInDelay: 0 // ms
    property int fadeOutDelay: 0 // ms
    property int fadeInEasingType: Easing.InOutQuint
    property int fadeOutEasingType: Easing.InOutQuint
    property url faderBackground: "qrc:/images/meegotouch-menu-dimmer.png"
    property int pressDelay: 0 // ms
    property url background: "qrc:/images/meegotouch-menu-background.png" + __invertedString
//    property url pressedBackground: "qrc:/images/meegotouch-menu" + __invertedString + "-background-pressed.png"
//    property url disabledBackground: "qrc:/images/meegotouch-menu" + __invertedString + "-background-disabled.png"
}
