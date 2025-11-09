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
    id: root
    anchors.margins: UiConstants.DefaultMargin
    tools:
        ToolBarLayout {
        ToolIcon {
            iconId: "toolbar-back"
            anchors.left: parent.left

            onClicked: { myMenu.close(); pageStack.pop(); }
        }

        ToolIcon {
            iconId: "toolbar-view-menu"; onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
            anchors.right: parent==undefined ? undefined : parent.right
        }
    }

    Component {
        id: redVkb

        Rectangle {
            id: rec
            color: "red"
            height: 100

            Item {
                anchors.centerIn: parent
                Button {
                    id: addA
                    width: 150
                    anchors.right: removeA.left
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Add 'A'"
                    onClicked: inputContext.softwareInputPanelEvent = "A"
                }

                Button {
                    id: removeA
                    width: 150
                    anchors.verticalCenter: parent.verticalCenter
                    text: inputContext.targetInputFor(redVkb).backspaceTitle
                    onClicked: inputContext.softwareInputPanelEvent = "Backspace"
                }
            }
        }
    }

    Component {
        id: expandableVkb

        Rectangle {
            color: "blue"
            height: 150

            Button {
                anchors.centerIn: parent
                text: "Extend"

                onClicked: {
                    if(parent.height == 300) {
                        parent.height = 150
                        text = "Extend"
                    } else {
                        parent.height = 300
                        text = "Shrink"
                    }
                }
            }

        }
    }

    Flickable {
        id: container
        anchors.fill: parent
        contentWidth: col.width
        contentHeight: col.height
        flickableDirection: Flickable.VerticalFlick
        pressDelay: 100
        Column {
            id: col

            width: container.width

            Label {
                text: "Default VKB:"
            }

            TextField {
                anchors {left: parent.left; right: parent.right;}
            }

            Label {
                text: "Default VKB with numbers only:"
            }

            TextField {
                anchors {left: parent.left; right: parent.right;}
                inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
            }

            Label {
                text: "Custom VKB:"
            }

            TextField {
                id: aTextField
                anchors {left: parent.left; right: parent.right;}
                //platformCustomSoftwareInputPanel: redVkb
                //platformEnableEditBubble: false
                property string backspaceTitle: "Delete"


            }

            Label {
                text: "Custom VKB which can extend:"
            }

            Row {
                anchors {left: parent.left; right: parent.right;}

                TextField {
                    id: blueTextField
                    //platformCustomSoftwareInputPanel: expandableVkb
                    //platformEnableEditBubble: false
                }

                Button {
                    id: activateButton
                    width: 200
                    text: "activate"
                    onClicked: blueTextField.forceActiveFocus()
                }
            }
        }
    }
}
