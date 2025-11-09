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

Window {
    id: root
    width: 480
    height: 854
    visible: true

    property alias color: background.color

    default property alias content: windowContent.data

    // Read only property true if window is in portrait
    //property alias inPortrait: window.portrait

    // Extendend API (for fremantle only)
    property bool allowSwitch: true
    property bool allowClose: true

    property Style platformStyle: WindowStyle {}

    signal orientationChangeAboutToStart
    signal orientationChangeStarted
    signal orientationChangeFinished

    Rectangle {
        id: background
        anchors.fill: parent
        color: platformStyle.colorBackground
    }

    Item {
        id: window
        property bool portrait
        focus: true
        Keys.onReleased: event=> {
            if (event.key === Qt.Key_Back) {
                event.accepted = true
                console.log("Back pressed")
                // Do not quit app
            }
        }

        //on Android, the screen resolution is resized by the system
        //width: window.portrait ? screen.displayHeight : screen.displayWidth
        //height: window.portrait ? screen.displayWidth : screen.displayHeight
        width: parent.width //screen.displayWidth
        height: parent.height//screen.displayHeight

        anchors.centerIn: parent

        Item {
            id: windowContent
            width: parent.width
            height: parent.height - heightDelta

            // Used for resizing windowContent when virtual keyboard appears
            property int heightDelta: 0

            objectName: "windowContent"
            clip: true
        }

        SoftwareInputPanel {
            id: softwareInputPanel
            active: false//inputContext.customSoftwareInputPanelVisible
            anchors.bottom: parent.bottom

            onHeightChanged: {
                windowContent.heightDelta = height;
            }

            Loader {
                id: softwareInputPanelLoader
                width: parent.width
                source: ""//inputContext.customSoftwareInputPanelComponent
            }
        }
    }
}
