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

Rectangle {
    id: detailHeader

    height: (screen.currentOrientation == Screen.Portrait || screen.currentOrientation == Screen.PortraitInverted) ? 56 : 48
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    color: "#000000"
    property alias text: label.text
    property alias textColor: label.color

    Label {
        id: label
        anchors.left: parent.left
        anchors.leftMargin: UiConstants.DefaultMargin
        anchors.right: parent.right
        anchors.rightMargin: UiConstants.DefaultMargin
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideRight
        smooth: true
        color: "white"
        font: UiConstants.HeaderFont
    }
}

