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
import "UIConstants.js" as UI

SliderTemplate {
    id: slider

    property Style platformStyle: SliderStyle{}

    //Deprecated, TODO Remove this on w13
    property alias style: slider.platformStyle

    opacity: enabled ? UI.OPACITY_ENABLED : UI.OPACITY_DISABLED

    __handleItem: Image {
        height: 48
        width: 48
        source: pressed? platformStyle.handleBackgroundPressed : platformStyle.handleBackground;
    }

    __grooveItem: BorderImage {
            source: platformStyle.grooveItemBackground
            border { left: 6; top: 4; right: 6; bottom: 4 }
            height: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
    }

    __valueTrackItem: BorderImage {
        source: platformStyle.grooveItemElapsedBackground
        border { left: 6; top: 4; right: 6; bottom: 4 }
        height: 10

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
    }

    __valueIndicatorItem: BorderImage {
        id: indicatorBackground
        source: platformStyle.valueBackground
        border { left: 12; top: 12; right: 12; bottom: 12 }

        width: label.width + 28
        height: 40

        Image {
            id: arrow
        }

        state: slider.valueIndicatorPosition
        states: [
            State {
                name: "Top"
                PropertyChanges {
                    target: arrow
                    source: platformStyle.labelArrowDown
                }
                AnchorChanges {
                    target: arrow
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            },
            State {
                name: "Bottom"
                PropertyChanges {
                    target: arrow
                    source: platformStyle.labelArrowUp
                }
                AnchorChanges {
                    target: arrow
                    anchors.bottom: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                AnchorChanges {
                    target: indicatorBackground
//                    anchors.
                }
            },
            State {
                name: "Left"
                PropertyChanges {
                    target: arrow
                    source: platformStyle.labelArrowLeft
                }
                AnchorChanges {
                    target: arrow
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            },
            State {
                name: "Right"
                PropertyChanges {
                    target: arrow
                    source: platformStyle.labelArrowRight
                }
                AnchorChanges {
                    target: arrow
                    anchors.right: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        ]

        Text {
            id: label
            anchors.centerIn: parent
            text: slider.valueIndicatorText
            color: slider.platformStyle.textColor
            font.pixelSize: slider.platformStyle.fontPixelSize
            font.family: slider.platformStyle.fontFamily
        }

        // Native libmeegotouch slider value indicator pops up 100ms after pressing
        // the handle... but hiding happens without delay.
        visible: slider.valueIndicatorVisible && slider.pressed
        Behavior on visible {
            enabled: !indicatorBackground.visible
            PropertyAnimation {
                duration: 100
            }
        }
    }
}
