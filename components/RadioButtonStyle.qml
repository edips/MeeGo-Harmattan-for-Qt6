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
    // Background
    property url background: "qrc:/images/meegotouch-button-radiobutton"+__invertedString+"-background"+".png"
    property url backgroundSelected: "qrc:/images/" + __colorString + "meegotouch-button-radiobutton"+__invertedString+"-background-selected"+".png"
    property url backgroundPressed: "qrc:/images/" + __colorString + "meegotouch-button-radiobutton"+__invertedString+"-background-pressed"+".png"
    property url backgroundDisabled: "qrc:/images/" + __colorString + "meegotouch-button-radiobutton"+__invertedString+"-background-disabled"+".png"

    // Mouse area margins
    property int mouseMarginTop: 0
    property int mouseMarginLeft: 0
    property int mouseMarginRight: 0
    property int mouseMarginBottom: 0
    property int elideMode: Text.ElideNone
}
