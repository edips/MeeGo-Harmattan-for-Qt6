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
    id: root
    width: parent ? parent.width : 0
    height: 250
    color: "black"
    opacity: 0.9

    Text {
        id: label
        font.pixelSize: 43
        text: "Software Input Panel"
        anchors.centerIn: parent
        color: "white"
        opacity: 0.0
    }

    MouseArea {
        // Block clicks from falling through the simulator
        anchors.fill: parent
        onClicked: {
            root.parent.focus = true;
            inputContext.simulateSipClose();
        }
    }
}
