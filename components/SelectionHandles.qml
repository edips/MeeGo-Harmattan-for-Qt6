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
import "Utils.js" as Utils
import "EditBubble.js" as Popup
import "SelectionHandles.js" as Private

Item {
    id: contents
    Component.onCompleted: console.log("SelectionHandles.qml: opened.")
    // Styling for the Label
    property Style platformStyle: SelectionHandlesStyle{}
    //Deprecated, TODO Remove this some day
    property alias style: contents.platformStyle
    property Item textInput: null
    property int textInputCursorPos: textInput ? textInput.cursorPosition : -1
    property variant selectionStartRect: Qt.rect(0,0,0,0)
    property variant selectionEndRect: Qt.rect(0,0,0,0)
    property variant selectionStartPoint: Qt.point(0,0)
    property variant selectionEndPoint: Qt.point(0,0)
    property variant cursorRect: textInput ? textInput.positionToRectangle( textInput.cursorPosition ) : Qt.rect(0,0,0,0)
    property variant cursorPoint: Qt.point(0,0)
    property alias leftSelectionHandle: leftSelectionImage
    property alias rightSelectionHandle: rightSelectionImage
    property alias privateRect: rect
    property bool privateIgnoreClose: false
    function adjustPosition() {
        if (!textInput) return;
        if (textInput.selectedText.length > 0) {
            var startRect = textInput.positionToRectangle(textInput.selectionStart);
            var endRect = textInput.positionToRectangle(textInput.selectionEnd);
            if (startRect && endRect) {
                var flickable = Utils.findFlickable(textInput);
                var startX = startRect.x;
                var endX = endRect.x;
                if (flickable) {
                    var visibleLeft = flickable.contentX;
                    var visibleRight = flickable.contentX + flickable.width;
                    startX = Math.max(startX, visibleLeft);
                    startX = Math.min(startX, visibleRight);
                    endX = Math.max(endX, visibleLeft);
                    endX = Math.min(endX, visibleRight);
                }
                selectionStartPoint = rect.mapFromItem(textInput, startX, startRect.y);
                selectionEndPoint = rect.mapFromItem(textInput, endX, endRect.y);
                selectionStartRect = startRect;
                selectionEndRect = endRect;
            }
        }
        var cRect = textInput.positionToRectangle(textInput.cursorPosition);
        if (!cRect || (cRect.height === 0 && cRect.width === 0)) {
            cRect = Qt.rect(cRect ? cRect.x : 0, cRect ? cRect.y : 0, 0, textInput.font.pixelSize);
        }
        cursorPoint = rect.mapFromItem(textInput, cRect.x, cRect.y);
        cursorRect = cRect;
    }
    onTextInputCursorPosChanged: {
        adjustPosition()
    }
    Timer {
        id: positionTimer
        interval: 1 // A minimal delay is sufficient
        repeat: false
        onTriggered: adjustPosition()
    }
    Connections {
        target: textInput
        // This is the key signal to update the single handle's position
        function onSelectedTextChanged() {
            // Use a timer to ensure flickable's contentX is updated before we adjust
            positionTimer.start()
        }
    }
    Item {
        id: rect
        property int fontBaseLine: textInput ? textInput.font.pixelSize * 0.16 : 0
        function outOfView( rootX, rootY, offset ) {
            if (!textInput) return true;
            var flickable = Utils.findFlickable(textInput);
            if (!flickable) {
                // Fallback for non-flickable text inputs, comparing in textInput's coordinates
                var point = rect.mapToItem(textInput, rootX, rootY);
                return (point.x - offset) < 0 || (point.x - offset) > textInput.width;
            }
            // To do a reliable check, we compare everything in the 'rect' item's coordinate system.
            var visibleLeftEdgeInRectCoords = rect.mapFromItem(flickable, 0, 0).x;
            var visibleRightEdgeInRectCoords = rect.mapFromItem(flickable, flickable.width, 0).x;
            // Check if the handle's center is outside the flickable's visible area.
            return (rootX - offset) < (visibleLeftEdgeInRectCoords - 1) || (rootX - offset) > (visibleRightEdgeInRectCoords + 1);
        }
        objectName: "selectionHandles"
        // fake baseline since the baseline of a font is not accessible in QML (except for anchors which doesn't work well here):\
        z: 1021 // Have the selection handles above the copy-paste bubble
        onVisibleChanged: {
            if (visible) {
                autoHideoutTimer.running = true;
            } else {
                autoHideoutTimer.running = false;
            }
        }
        Image {
            id: leftSelectionImage
            height: 48
            width: 48
            fillMode: Image.PreserveAspectFit
            objectName: "leftSelectionImage"
            property variant dragStart: Qt.point(0,0); // required for selection across multiple lines
            property int offset: -width/2;
            property int animationDuration: leftSelectionMouseArea.pressed ? 350 : 0
            x: (textInput && textInput.selectedText.length > 0 ? selectionStartPoint.x : cursorPoint.x) + offset
            y: (textInput && textInput.selectedText.length > 0
                ? selectionStartPoint.y + contents.selectionStartRect.height
                : cursorPoint.y + contents.cursorRect.height) - 10 - rect.fontBaseLine
            visible: textInput && textInput.activeFocus && y > 0
            source: platformStyle.leftSelectionHandle
            property bool pressed: leftSelectionMouseArea.pressed;
            property bool outOfView: rect.outOfView(x, y, offset);
            onXChanged: outOfView = rect.outOfView(x, y, offset)
            MouseArea {
                id: leftSelectionMouseArea
                anchors.fill: parent
                propagateComposedEvents: false
                onPressed: mouse=> {
                               autoHideoutTimer.running = false;
                               if (Popup.isOpened(textInput)) {
                                   Popup.close(textInput);
                               }
                               leftSelectionImage.dragStart = Qt.point( mouse.x, mouse.y );
                               var sourceItem = textInput.parent != undefined ? textInput.parent : textInput
                           }
                onPositionChanged:  mouse=> {
                                        autoHideoutTimer.running = false;
                                        var pixelpos = mapToItem( textInput, mouse.x, mouse.y );

                                        if (textInput.selectedText.length > 0) {
                                            var ydelta = pixelpos.y - leftSelectionImage.dragStart.y;
                                            if ( ydelta < 0 ) ydelta = 0;
                                            var pos = textInput.positionAt(pixelpos.x, ydelta);
                                            var h = textInput.selectionEnd;
                                            privateIgnoreClose = true;
                                            if (pos >= h) {
                                                textInput.cursorPosition = h;
                                                pos = h - 1;
                                            }
                                            textInput.select(h,pos);
                                            privateIgnoreClose = false;
                                        } else {
                                            var pos = textInput.positionAt(pixelpos.x, pixelpos.y);
                                            privateIgnoreClose = true;
                                            textInput.cursorPosition = pos;
                                            privateIgnoreClose = false;
                                        }
                                    }
                onReleased: mouse=> {
                                autoHideoutTimer.running = true;
                                if (textInput && textInput.selectedText.length > 0) {
                                    Popup.enableOffset( false );
                                    Popup.open(textInput,textInput.positionToRectangle(textInput.selectionStart));
                                    Popup.enableOffset( Private.handlesIntersectWith(Popup.geometry()) );
                                }
                            }
                onExited:  mouse=> {
                               if (leftSelectionMouseArea.pressed) {
                                   if (textInput && textInput.selectedText.length > 0) {
                                       Popup.enableOffset( false );
                                       Popup.open(textInput,textInput.positionToRectangle(textInput.selectionStart));
                                       Popup.enableOffset( Private.handlesIntersectWith(Popup.geometry()) );
                                   }
                               }
                           }
            }
            states: [
                State {
                    name: "normal"
                    when: !leftSelectionImage.outOfView && !leftSelectionImage.pressed && !rightSelectionImage.pressed
                    PropertyChanges { target: leftSelectionImage; opacity: 1.0 }
                },
                State {
                    name: "pressed"
                    when: !leftSelectionImage.outOfView && leftSelectionImage.pressed
                    PropertyChanges { target: leftSelectionImage; opacity: 0.0 }
                },
                State {
                    name: "otherpressed"
                    when: !leftSelectionImage.outOfView && rightSelectionImage.pressed
                    PropertyChanges { target: leftSelectionImage; opacity: 0.7 }
                },
                State {
                    name: "outofview"
                    when: leftSelectionImage.outOfView
                    PropertyChanges { target: leftSelectionImage; opacity: 0.0 }
                }
            ]

            transitions: [
                Transition {
                    from: "pressed"; to: "normal"
                    NumberAnimation {target: leftSelectionImage; property: "opacity";
                        easing.type: Easing.InOutQuad;
                        from: 0.0; to: 1.0; duration: 350}
                },
                Transition {
                    from: "normal"; to: "pressed"
                    NumberAnimation {target: leftSelectionImage; property: "opacity";
                        easing.type: Easing.InOutQuad;
                        from: 1.0; to: 0.0; duration: 350}
                },
                Transition {
                    from: "otherpressed"; to: "normal"
                    NumberAnimation {target: leftSelectionImage; property: "opacity";
                        easing.type: Easing.InOutQuad;
                        from: 0.7; to: 1.0; duration: 350}
                },
                Transition {
                    from: "normal"; to: "otherpressed"
                    NumberAnimation {target: leftSelectionImage; property: "opacity";
                        easing.type: Easing.InOutQuad;
                        from: 1.0; to: 0.7; duration: 350}
                }
            ]
        }

        Image {
            id: rightSelectionImage
            height: 48
            width: 48
            fillMode: Image.PreserveAspectFit
            property variant dragStart: Qt.point(0,0); // required for selection across multiple lines
            property int offset: -width/2;
            property int animationDuration: rightSelectionMouseArea.pressed ? 350 : 0
            property bool pressed: rightSelectionMouseArea.pressed;
            property bool outOfView: rect.outOfView(x, y, offset);
            objectName: "rightSelectionImage"
            x: selectionEndPoint.x + offset;
            y: selectionEndPoint.y + contents.selectionEndRect.height - 10 - rect.fontBaseLine; // vertical offset: 4 pixels
            visible: textInput && textInput.selectedText.length > 0 && y > 0 && textInput.activeFocus
            source: platformStyle.rightSelectionHandle;
            onXChanged: outOfView = rect.outOfView(x, y, offset);
            MouseArea {
                id: rightSelectionMouseArea
                anchors.fill: parent
                // Ensure mouse events on the handles are not propagated to textInteractionArea
                propagateComposedEvents: false
                onPressed: mouse=> {
                               autoHideoutTimer.running = false;
                               if (Popup.isOpened(textInput)) {
                                   Popup.close(textInput);
                               }
                               rightSelectionImage.dragStart = Qt.point( mouse.x, mouse.y );
                               var sourceItem = textInput.parent != undefined ? textInput.parent : textInput
                           }
                onPositionChanged: mouse=> {
                                       autoHideoutTimer.running = false;
                                       var pixelpos = mapToItem( textInput, mouse.x, mouse.y );
                                       var ydelta = pixelpos.y - rightSelectionImage.dragStart.y;  // Determine the line distance
                                       if ( ydelta < 0 ) ydelta = 0;  // Avoid jumpy text selection
                                       var pos = textInput.positionAt(pixelpos.x, ydelta);
                                       var h = textInput.selectionStart;
                                       privateIgnoreClose = true;    // Avoid closing the handles while setting the cursor position
                                       if (pos <= h) {
                                           textInput.cursorPosition = h; // proper autoscrolling
                                           pos = h + 1;  // Ensure at minimum one character between selection handles
                                       }
                                       textInput.select(h,pos); // Select by character
                                       privateIgnoreClose = false;
                                   }
                onReleased: mouse=> {
                                autoHideoutTimer.running = true;
                                if (textInput && textInput.selectedText.length > 0) {
                                    Popup.enableOffset( false );
                                    Popup.open(textInput,textInput.positionToRectangle(textInput.selectionStart));
                                    Popup.enableOffset( Private.handlesIntersectWith(Popup.geometry()) );
                                }
                            }
                onExited: mouse=> {
                              if (rightSelectionMouseArea.pressed) {
                                  if (textInput && textInput.selectedText.length > 0) {
                                      Popup.enableOffset( false );
                                      Popup.open(textInput,textInput.positionToRectangle(textInput.selectionStart));
                                      Popup.enableOffset( Private.handlesIntersectWith(Popup.geometry()) );
                                  }
                              }
                          }
            }
            states: [
                State {
                    name: "normal"
                    when:  !rightSelectionImage.outOfView && !leftSelectionImage.pressed && !rightSelectionImage.pressed
                    PropertyChanges { target: rightSelectionImage; opacity: 1.0 }
                },
                State {
                    name: "pressed"
                    when:  !rightSelectionImage.outOfView && rightSelectionImage.pressed
                    PropertyChanges { target: rightSelectionImage; opacity: 0.0 }
                },
                State {
                    name: "otherpressed"
                    when: !rightSelectionImage.outOfView && leftSelectionImage.pressed
                    PropertyChanges { target: rightSelectionImage; opacity: 0.7 }
                },
                State {
                    name: "outofview"
                    when: rightSelectionImage.outOfView
                    PropertyChanges { target: rightSelectionImage; opacity: 0.0 }
                }
            ]

            transitions: [
                Transition {
                    from: "pressed"; to: "normal"
                    NumberAnimation {target: rightSelectionImage; property: "opacity";
                        easing.type: Easing.InOutQuad;
                        from: 0.0; to: 1.0; duration: 350}
                },
                Transition {
                    from: "normal"; to: "pressed"
                    NumberAnimation {target: rightSelectionImage; property: "opacity";
                        easing.type: Easing.InOutQuad;
                        from: 1.0; to: 0.0; duration: 350}
                },
                Transition {
                    from: "otherpressed"; to: "normal"
                    NumberAnimation {target: rightSelectionImage; property: "opacity";
                        easing.type: Easing.InOutQuad;
                        from: 0.7; to: 1.0; duration: 350}
                },
                Transition {
                    from: "normal"; to: "otherpressed"
                    NumberAnimation {target: rightSelectionImage; property: "opacity";
                        from: 1.0; to: 0.7; duration: 350}
                }
            ]
        }
    }

    Connections {
        target: Utils.findFlickable(textInput)
        function onContentXChanged() { adjustPosition(); }
        function onContentYChanged() {
            Popup.enableOffset( false );
            var bubbleGeom = Popup.geometry();
            if (bubbleGeom !== undefined) {
                Popup.enableOffset( Private.handlesIntersectWith(bubbleGeom) );
            }
            adjustPosition()
        }
    }

    Connections {
        // The 'target' property points to the C++ object exposed via setContextProperty
        target: orientation // This refers to the 'orientationMonitor' from main.cpp
        // 2. Define the signal handler using the 'on' prefix and the signal name
        function onOrientationChanged() {
            Popup.enableOffset( false );
            var bubbleGeom = Popup.geometry();
            if (bubbleGeom !== undefined) {
                Popup.enableOffset( Private.handlesIntersectWith(bubbleGeom) );
            }
            Private.adjustPosition(contents)
        }
    }

    state: "closed"
    Timer {
        id: autoHideoutTimer
        interval: 5000
        onTriggered: {
            console.log("SelectionHandles: autoHideoutTimer triggered, setting state to hidden.");
            running = false
            state = "hidden"
        }
    }
    states: [
        State {
            name: "opened"
            ParentChange { target: rect; parent: Utils.findRootItem(textInput); }
            PropertyChanges { target: rect; visible: true; opacity: 1.0 }
        },
        State {
            name: "hidden"
            ParentChange { target: rect; parent: Utils.findRootItem(textInput); }
            PropertyChanges { target: rect; visible: true; opacity: 0.0; }
        },
        State {
            name: "closed"
            ParentChange { target: rect; parent: contents; }
            PropertyChanges { target: rect; visible: false; }
        }
    ]
    transitions: [
        Transition {
            from: "closed"; to: "opened"
            NumberAnimation {target: rect; property: "opacity";
                easing.type: Easing.InOutQuad;
                from: 0.0; to: 1.0; duration: 350}
        },
        Transition {
            from: "opened"; to: "closed"
            NumberAnimation {target: rect; property: "opacity";
                easing.type: Easing.InOutQuad;
                from: 1.0; to: 0.0; duration: 350}
        },
        Transition {
            from: "opened"; to: "hidden";
            reversible: false
            SequentialAnimation {
                NumberAnimation {
                    target: rect
                    properties: "opacity"
                    duration: 1000
                }
                ScriptAction {
                    script: {
                        console.log("SelectionHandles: hidden to closed transition, setting state to closed.");
                        state = "closed"
                    }
                }
            }
        }
    ]
}
