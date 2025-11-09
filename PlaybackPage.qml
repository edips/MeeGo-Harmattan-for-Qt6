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
    id: playbackPage

    property bool playing: false

    function play()
    {
        playing = true
    }

    function stop()
    {
        playing = false
    }

    Button {
        id: changeToolbarButton
        text: "Play"
        width: 320
        anchors.centerIn: parent
        onClicked: if(!playing){ play(); title="Stop" } else { stop(); title= "Play"; }
    }

    tools: Item {
        id: playbackToolbar
        anchors.fill: parent

        ToolIcon {
            iconId: "toolbar-back"; onClicked: pageStack.pop();
            anchors.left: parent.left
            anchors.top: parent.top
        }

        Item {
            anchors.fill: parent

            ToolIcon {
                id: playButton
                anchors.centerIn: parent
                iconId: "toolbar-mediacontrol-play"
                onClicked: playbackPage.play();
            }

            ToolIcon {
                id: stopButton
                anchors.centerIn: parent
                iconId: "toolbar-mediacontrol-stop"
                opacity: 0
                onClicked: playbackPage.stop();
            }

            ToolIcon {
                iconId: "toolbar-mediacontrol-next"
                anchors.left: playButton.right
                anchors.leftMargin: 64
                anchors.top: parent.top
            }

            ToolIcon {
                iconId: "toolbar-mediacontrol-next"
                anchors.right: playButton.left
                anchors.rightMargin: 64
                anchors.top: parent.top
            }
        }

        states: [
            State {
                name: "playState"
                when: playbackPage.playing
                PropertyChanges {
                    target: playButton
                    opacity: 0
                }
                PropertyChanges {
                    target: stopButton
                    opacity: 1
                }
            },
            State {
                name: "stopState"
                when: !playbackPage.playing
                PropertyChanges {
                    target: playButton
                    opacity: 1
                }
                PropertyChanges {
                    target: stopButton
                    opacity: 0
                }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation { property: "opacity"; duration: 400 }
            }
        ]
    }
}
