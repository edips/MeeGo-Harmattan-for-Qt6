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
/*
Class: Switch
   The Switch component is similar to the CheckBox component but instead of
   selecting items it should be used when setting options to On/Off.
*/
Item {
    id: root

    width: slider.width
    height: slider.height

    /*
    * Property: checked
     * [bool=false] The checked state of switch
     */
    property bool checked: false

    // Styling for the Switch
    property Style platformStyle: SwitchStyle {}

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    property alias platformMouseAnchors: mouseArea.anchors

    /*
    * Property: enabled
     * [bool=true] Enables/Disables the component. Notice that the disable state is not Toolkit compliant
     * and not present inside the qt-components
     */

    Item {
        id: slider

        width: 44
        height: 28

        state: root.checked ? "checked" : "unchecked"

        property real knobPos: (knob.x - platformStyle.minKnobX) / (platformStyle.maxKnobX - platformStyle.minKnobX)

        Image {
            width: parent.width
            height: parent.height
            source: platformStyle.switchOn
            opacity: slider.knobPos
        }
        Image {
            width: parent.width
            height: parent.height
            source: platformStyle.switchOff
            opacity: 1.0 - slider.knobPos
        }

        states: [
            State {
                name: "unchecked"
                PropertyChanges { target: knob; x: platformStyle.minKnobX }
            },
            State {
                name: "checked"
                PropertyChanges { target: knob; x: platformStyle.maxKnobX }
            }
        ]

        transitions: [
            Transition {
                SmoothedAnimation { properties: "x"; velocity: 500; maximumEasingTime: 0 }
            }
        ]

        // thumb (shadow)
        Image {
            id: knob

            // thumb (inline)
            Image {
                width: 20
                height: 20
                x: 0
                y: -2
                source: (slider.enabled ? (mouseArea.pressed ? platformStyle.thumbPressed : platformStyle.thumb) : platformStyle.thumbDisabled)
            }

            source: platformStyle.shadow

            y: 6

            width: 20
            height: 20
        }

        MouseArea {
            id: mouseArea
            property int downMouseX
            property int downKnobX
            anchors {
                fill: parent
                rightMargin: platformStyle.mouseMarginRight
                leftMargin: platformStyle.mouseMarginLeft
                topMargin: platformStyle.mouseMarginTop
                bottomMargin: platformStyle.mouseMarginBottom
            }

            function snap() {
                if (knob.x < (platformStyle.maxKnobX + platformStyle.minKnobX) / 2) {
                    if (root.checked) {
                        root.checked = false;
                    } else {
                        knob.x = platformStyle.minKnobX;
                    }
                } else {
                    if (!root.checked) {
                        root.checked = true;
                    } else {
                        knob.x = platformStyle.maxKnobX;
                    }
                }
            }

            onPressed: {
                downMouseX = mouseX;
                downKnobX = knob.x;
            }

            onPositionChanged: {
                var newKnobX = downKnobX - (downMouseX - mouseX);
                knob.x = newKnobX < platformStyle.minKnobX ? platformStyle.minKnobX : newKnobX > platformStyle.maxKnobX ? platformStyle.maxKnobX : newKnobX;
            }

            onReleased: {
                if (Math.abs(downMouseX - mouseX) < 5)
                    root.checked = !root.checked;
                else
                    snap();
            }

            onCanceled: {
                snap();
            }

        }
    }
}
