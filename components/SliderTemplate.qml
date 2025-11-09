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

Item {
    id: slider

    //
    // Common API
    //
    property int orientationSlider: Qt.Horizontal
    property alias minimumValue: range.minimumValue
    property alias maximumValue: range.maximumValue
    property alias pressed: mouseArea.pressed
    property alias stepSize: range.stepSize

    // NOTE: this property is in/out, the user can set it, create bindings to it, and
    // at the same time the slider wants to update. There's no way in QML to do this kind
    // of updates AND allow the user bind it (without a Binding object). That's the
    // reason this is an alias to a C++ property in range model.
    property alias value: range.value

    //
    // Public extensions
    //
    property alias inverted: range.inverted

    // Value indicator displays the current value near the slider
    // if valueIndicatorText == "", a default formating will be applied
    property string valueIndicatorText: formatValue(range.value)
    property bool valueIndicatorVisible: false

    property int valueIndicatorMargin: 1
    property string valueIndicatorPosition: __isVertical ? "Left" : "Top"

    // The default implementation for label hides decimals until it hits a
    // floating point value at which point it keeps decimals
    property bool __useDecimals: false
    function formatValue(v) {
        return __useDecimals ? (v.toFixed(2)) : v;
    }

    //
    // "Protected" properties
    //

    // Hooks for customizing the pieces of the slider
    property Item __grooveItem
    property Item __valueTrackItem
    property Item __handleItem
    property Item __valueIndicatorItem

    property bool __isVertical: orientationSlider === Qt.Vertical

    property int impWidth: 400
    property int impHeight: handle.height

    width: __isVertical ? impHeight : impWidth
    height: __isVertical ? impWidth : impHeight

    // This is a template slider, so every piece can be modified by passing a
    // different Component. The main elements in the implementation are
    //
    // - the 'range' does the calculations to map position to/from value,
    //   it also serves as a data storage for both properties;
    //
    // - the 'fakeHandle' is what the mouse area drags on the screen, it feeds
    //   the 'range' position and also reads it when convenient;
    //
    // - the real 'handle' it is the visual representation of the handle, that
    //   just follows the 'fakeHandle' position.
    //
    // Everything is encapsulated in a contents Item, so for the
    // vertical slider, we just swap the height/width, make it
    // horizontal, and then use rotation to make it vertical again.

    Component.onCompleted: {
        __grooveItem.parent = groove;
        __valueTrackItem.parent = valueTrack;
        __handleItem.parent = handle;
        __valueIndicatorItem.parent = valueIndicator;
    }

    Item {
        id: contents

        width: __isVertical ? slider.height : slider.width
        height: __isVertical ? slider.width : slider.height
        rotation: __isVertical ? -90 : 0

        anchors.centerIn: slider

        RangeModel {
            id: range
            minimumValue: 0.0
            maximumValue: 1.0
            value: 0
            stepSize: 0.0
            onValueChanged: {
                // XXX: Moved that outside formatValue to get rid of binding loop warnings
                var v = range.value
                if (parseInt(v) !== v)
                    __useDecimals = true;
            }
            positionAtMinimum: handle.width / 2
            positionAtMaximum: contents.width - handle.width / 2
            onMaximumChanged: __useDecimals = false;
            onMinimumChanged: __useDecimals = false;
            onStepSizeChanged: __useDecimals = false;
        }

        Item {
            id: groove
            anchors.fill: parent
            anchors.leftMargin: handle.width / 2
            anchors.rightMargin: handle.width / 2
        }

        Item {
            id: valueTrack

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: groove.left
            anchors.right: handle.horizontalCenter
            anchors.rightMargin: handle.width / 2

            states: State {
                when: slider.inverted
                PropertyChanges {
                    target: valueTrack
                    anchors.rightMargin: 0
                    anchors.leftMargin: - handle.width / 2
                }
                AnchorChanges {
                    target: valueTrack
                    anchors.left: handle.horizontalCenter
                    anchors.right: groove.right
                }
            }
        }

        Item {
            id: handle
            transform: Translate { x: - handle.width / 2 }
            rotation: __isVertical ? 90 : 0

            anchors.verticalCenter: parent.verticalCenter

            width: __handleItem.width
            height: __handleItem.height

            x: fakeHandle.x
            Behavior on x {
                id: behavior
                enabled: !mouseArea.drag.active

                PropertyAnimation {
                    duration: behavior.enabled ? 150 : 0
                    easing.type: Easing.OutSine
                }
            }
        }

        Item {
            id: fakeHandle
            width: handle.width
            height: handle.height
            transform: Translate { x: - handle.width / 2 }
        }

        MouseArea {
            id: mouseArea
            anchors {
                fill: parent
            }

            drag.target: fakeHandle
            drag.axis: Drag.XAxis
            drag.minimumX: range.positionAtMinimum
            drag.maximumX: range.positionAtMaximum

            onClicked: mouse => {
                var clickXInContents = mouseArea.mapToItem(contents, mouse.x, 0).x;
                var targetX = Math.max(clickXInContents, drag.minimumX);
                targetX = Math.min(targetX, drag.maximumX);
                fakeHandle.x = targetX;
                range.position = fakeHandle.x; // Explicitly set range.position after a click
            }

            onReleased: mouse => {
                range.position = fakeHandle.x; // Ensure the final position of fakeHandle is committed to range.position
            }

            // --- CHANGE START ---
            // Added onPositionChanged to update range.position in real-time during drag
            onPositionChanged: mouse => {
                if (mouseArea.drag.active) {
                    // Update range.position based on the current fakeHandle.x
                    // This ensures the value indicator updates in real-time during drag
                    range.position = fakeHandle.x;
                }
            }
            // --- CHANGE END ---
        }

        Item {
            id: valueIndicator

            transform: Translate {
                x: - handle.width / 2;
                y: __isVertical? - ( __valueIndicatorItem.width/2) + 20 : y ;
            }

            rotation: __isVertical ? 90 : 0
            visible: valueIndicatorVisible

            width: __valueIndicatorItem.width //+ (__isVertical? (handle.width/2) : 0 )
            height: __valueIndicatorItem.height

            state: {
                if (!__isVertical)
                    return slider.valueIndicatorPosition;

                if (valueIndicatorPosition == "Right")
                    return "Bottom";
                if (valueIndicatorPosition == "Top")
                    return "Right";
                if (valueIndicatorPosition == "Bottom")
                    return "Left";
                return "Top";
            }
            anchors.margins: valueIndicatorMargin

            states: [
                State {
                    name: "Top"
                    AnchorChanges {
                        target: valueIndicator
                        anchors.bottom: handle.top
                        anchors.horizontalCenter: handle.horizontalCenter
                    }
                },
                State {
                    name: "Bottom"
                    AnchorChanges {
                        target: valueIndicator
                        anchors.top: handle.bottom
                        anchors.horizontalCenter: handle.horizontalCenter
                    }
                },
                State {
                    name: "Right"
                    AnchorChanges {
                        target: valueIndicator
                        anchors.left: handle.right
                        anchors.verticalCenter: handle.verticalCenter
                    }
                },
                State {
                    name: "Left"
                    AnchorChanges {
                        target: valueIndicator
                        anchors.right: handle.left
                        anchors.verticalCenter: handle.verticalCenter
                    }
                }
            ]
        }
    }

    // when there is no mouse interaction, the handle's position binds to the value
    Binding {
        when: !mouseArea.drag.active
        target: fakeHandle
        property: "x"
        value: range.position
    }

    // This binding was removed in the previous iteration and remains removed.
    // The real-time update is now handled by mouseArea.onPositionChanged.
    // Binding {
    //     when: mouseArea.drag.active
    //     target: range
    //     property: "position"
    //     value: fakeHandle.x
    // }
}
