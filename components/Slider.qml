import QtQuick 2.1
import com.meego.components 1.0
import "UIConstants.js" as UI

SliderTemplate {
    id: slider

    property Style platformStyle: SliderStyle{}

    //Deprecated, TODO Remove this on w13
    property alias style: slider.platformStyle

    opacity: enabled ? UI.OPACITY_ENABLED : UI.OPACITY_DISABLED

    __handleItem: Image {
        source: pressed? platformStyle.handleBackgroundPressed : platformStyle.handleBackground;
    }

    __grooveItem: BorderImage {
            source: platformStyle.grooveItemBackground
            border { left: parseInt(6 * ScaleFactor); top: parseInt(4 * ScaleFactor); right: parseInt(6 * ScaleFactor); bottom: parseInt(4* ScaleFactor) }
            height: parseInt(10 * ScaleFactor)

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
    }

    __valueTrackItem: BorderImage {
        source: platformStyle.grooveItemElapsedBackground
        border { left: parseInt(6 * ScaleFactor); top: parseInt(4 * ScaleFactor); right: parseInt(6 * ScaleFactor); bottom: parseInt(4 * ScaleFactor) }
        height: parseInt(10 * ScaleFactor)

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
    }

    __valueIndicatorItem: BorderImage {
        id: indicatorBackground
        source: platformStyle.valueBackground
        border { left: parseInt(12 * ScaleFactor); top: parseInt(12 * ScaleFactor); right: parseInt(12 * ScaleFactor); bottom: parseInt(12 * ScaleFactor) }

        width: label.width + parseInt(28 * ScaleFactor)
        height: parseInt(40 * ScaleFactor)

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
