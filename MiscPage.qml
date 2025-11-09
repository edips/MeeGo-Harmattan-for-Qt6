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
    id: miscPage
    tools: commonTools
    anchors.margins: UiConstants.DefaultMargin

    Flickable {
        id: topFlick
        anchors {fill: parent}
        contentWidth: parent.width
        contentHeight: row.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: row
            spacing:10
            width: parent.width

            Label {
                id: label1
                text: "Busy Indicator"
            }
            Row {
                spacing: 10
                anchors.horizontalCenter:parent.horizontalCenter

                BusyIndicator {
                    id: indicator1
                    platformStyle: BusyIndicatorStyle { size: "small" }
                }
                BusyIndicator {
                    id: indicator2
                    running: indicator1.running
                }
                BusyIndicator {
                    id: indicator3
                    platformStyle: BusyIndicatorStyle { size: "large" }
                    running:  indicator1.running
                }
            }
            Button {
                id: button1
                text: "Toggle running"
                onClicked: indicator1.running = !indicator2.running
                anchors.horizontalCenter:parent.horizontalCenter
            }
            Item {width:16; height:16}
            Label {
                id: label2
                text: "Progress Bar"
            }
            ProgressBar {
                id: progressBar
                width: parent.width
                value: slider1.value
            }
            Button {
                id: button2
                text: "Toggle running"
                onClicked: {
                    progressBar.indeterminate = !progressBar.indeterminate;
                    slider1.enabled = !slider1.enabled;
                }
                anchors.horizontalCenter:parent.horizontalCenter
            }
            Slider {
                id: slider1
                width: parent.width
            }

            Item {width:16; height:16}
            Label {
                id: label3
                text: "Scroll Decorator"
            }
            Item {
                width: 250
                height: 150
                Flickable {
                    id: flick
                    contentWidth: 400
                    contentHeight: 400
                    width: parent.width
                    height: parent.height
                    contentX: 70
                    contentY: 120
                    clip: true

                    Rectangle {
                        anchors.fill: parent
                        color: "lightgrey"
                        Text {
                            text: "Flick me!"
                            anchors.centerIn: parent
                        }
                    }
                }
                ScrollDecorator {
                    id: scrollDecorator
                    flickableItem: flick
                }
                Rectangle {
                    anchors.fill: flick
                    border.color: "#333"
                    color: "transparent"
                }
                anchors.horizontalCenter:parent.horizontalCenter
            }
            Item {width:16; height:16}
            Label {
                id: label4
                text: "Switch"
            }
            Grid {
                id: grid1
                columns: 2
                spacing: 20

                Switch {
                    id: switch2
                    checked: true
                }
                Switch {
                    id: switch1
                    checked: false
                    platformStyle: SwitchStyle {
                        inverted: true
                    }
                }
                Text {
                    text: "default: enabled"
                    font.pixelSize: 15
                }
                Text {
                    text: "default: disabled"
                    font.pixelSize: 15
                }
                anchors.horizontalCenter:parent.horizontalCenter
            }
            anchors.horizontalCenter:parent.horizontalCenter
        }
    }

    ScrollDecorator {
        flickableItem: topFlick
    }
}
