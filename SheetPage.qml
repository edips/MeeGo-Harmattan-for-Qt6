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
    id: sheetPage
    anchors.margins: UiConstants.DefaultMargin

    tools: ToolBarLayout {
        ToolIcon { iconId: "toolbar-back"; onClicked: pageStack.pop(); }
        ToolIcon { iconId: "toolbar-view-menu";}
    }

    Flickable {
        anchors.fill: parent
        contentWidth: col.width
        contentHeight: col.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: col
            spacing: 30

            Button {
                text: "Launch Sheet"
                onClicked: sheet.open()
            }

            Button {
                text: "Launch empty Sheet"
                onClicked: emptySheet.open()
            }

            Label {
                id: label
            }
        }
    }

    Sheet {
        id: sheet

        acceptButtonText: "Save"
        rejectButtonText: "Cancel"
        rejectButton.enabled: !disableCancelButton.checked

        title: BusyIndicator {
            anchors.centerIn: parent; running: sheet.status == DialogStatus.Open;
        }

        content: Flickable {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.topMargin: 10
            contentWidth: col2.width
            contentHeight: col2.height
            flickableDirection: Flickable.VerticalFlick

            Column {
                id: col2
                anchors.top: parent.top
                spacing: 10
                Button {
                    id: disableCancelButton
                    text: "Disable cancel button"
                    checkable: true
                }
                Button {
                    text: "Three"
                }
                Button {
                    text: "Four"
                }
                Button {
                    text: "Five"
                }
                TextField {
                    text: "Six"
                }
                Button {
                    text: "Seven"
                }
                Button {
                    text: "Eight"
                }
                Button {
                    text: "Nine"
                }
                TextField {
                    text: "Ten"
                }

            }
        }
        onAccepted: label.text = "Accepted!"
        onRejected: label.text = "Rejected!"
    }

    Sheet {
        id: emptySheet

        acceptButtonText: "Accept"
        rejectButtonText: "Cancel"

        title: BusyIndicator {
            anchors.centerIn: parent; running: emptySheet.status == DialogStatus.Open;
        }

        content: Rectangle {
                width: 200
                height: 200
                Label {
                    id: labelEmpty
                    text: "Empty sheet"
                }
        }

        onAccepted: label.text = "Accepted!"
        onRejected: label.text = "Rejected!"
    }
}
