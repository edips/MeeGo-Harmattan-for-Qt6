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
import com.meego.components 1.0
import "components/"
import "components/UIConstants.js" as UiConstants

Page {
    id: orientationPage
    anchors.margins: UiConstants.DefaultMargin

    Item {
        id: landscapePanel
        anchors.centerIn: parent

        Row {
            anchors.centerIn: parent
            spacing: 16
            Button {
                text: "First Landscape Button"
            }

            Button {
                text: "Second Landscape Button"
            }
        }
    }

    Item {
        id: portraitPanel
        visible: false
        anchors.centerIn: parent

        Button {
            anchors.centerIn: parent
            text: "Portrait Button"
        }
    }

    states: [
        State {
            name: "inLandscape"
            when: !(orientation.orientation === "Portrait")
            PropertyChanges {
                target: landscapePanel
                visible: true
            }
            PropertyChanges {
                target: portraitPanel
                visible: false
            }
        },
        State {
            name: "inPortrait"
            when: orientation.orientation === "Portrait"
            PropertyChanges {
                target: landscapePanel
                visible: false
            }
            PropertyChanges {
                target: portraitPanel
                visible: true
            }
        }
    ]


    tools: ToolBarLayout {

        ToolIcon {
            iconId: "toolbar-back"; onClicked: pageStack.pop();
        }

        Text {
            id: orientationText
            text: "Landscape"
            font.pixelSize: 24
        }

        ToolIcon {
            iconId: "toolbar-view-menu"
        }

        states: [
            State {
                name: "inLandscape"
                when: !(orientation.orientation === "Portrait")
                PropertyChanges {
                    target: orientationText
                    text: "Landscape"
                }
            },
            State {
                name: "inPortrait"
                when: orientation.orientation === "Portrait"
                PropertyChanges {
                    target: orientationText
                    text: "Portrait"
                }
            }
        ]
    }
}
