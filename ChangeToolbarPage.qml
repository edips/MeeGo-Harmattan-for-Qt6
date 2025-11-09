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
    id: changeToolbarPage

    Button {
        id: changeToolbarButton
        text: "Change toolbar"
        checkable: true
        width: 320
        anchors.centerIn: parent
    }

    tools: Item {
        id: toolbar
        anchors.fill: parent
        clip: true

        ToolIcon {
            iconId: "toolbar-back"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: pageStack.pop()
        }

        ToolBarLayout {
            id: messagingPanel

            ToolIcon {
                id: newChat
                anchors.centerIn: parent
                iconId: "toolbar-new-chat"
            }

            ToolIcon {
                id: newMessageButton
                anchors.right: newChat.left
                anchors.rightMargin: 64
                anchors.verticalCenter: parent.verticalCenter
                iconId: "toolbar-new-message"
            }

            ToolIcon {
                id: shareButton
                iconId: "toolbar-share"
                anchors.left: newChat.right
                anchors.leftMargin: 64
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolBarLayout {
            id: searchPanel

            ToolIcon {
                id: searchButton
                anchors.centerIn: parent
                iconId: "toolbar-search"
            }

            ToolIcon {
                id: toolsButton
                anchors.right: searchButton.left
                anchors.rightMargin: 64
                anchors.verticalCenter: parent.verticalCenter
                iconId: "toolbar-tools"
            }

            ToolIcon {
                id: sendEmailButton
                iconId: "toolbar-send-email"
                anchors.left: searchButton.right
                anchors.leftMargin: 64
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolIcon {
            iconId: "toolbar-view-menu"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }

        states: [
            State {
                name: "searchPanelState"
                when: changeToolbarButton.checked
                PropertyChanges {
                    target: messagingPanel
                    opacity: 0
                    y: -50
                }

                PropertyChanges {
                    target: searchPanel
                    opacity: 1
                    y: 0
                }
            },
            State {
                name: "messagingPanelState"
                when: !changeToolbarButton.checked
                PropertyChanges {
                    target: messagingPanel
                    opacity: 1
                    y: 0
                }

                PropertyChanges {
                    target: searchPanel
                    opacity: 0
                    y: -50
                }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation { property: "opacity"; duration: 200 }
                NumberAnimation { property: "y"; duration: 200 }
            }
        ]
    }
}
