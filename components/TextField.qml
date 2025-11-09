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

import QtQuick // IMPORTANT: Changed from QtQuick 6.6
import com.meego.components 1.0 // This import is now crucial for MouseFilter
import "Utils.js" as Utils
import "UIConstants.js" as UI
import "EditBubble.js" as Popup
import "SelectionHandles.js" as SelectionHandles
import "TextAreaHelper.js" as TextAreaHelper

FocusScope {
    id: root

    // Common API
    property alias text: textInput.text
    property alias placeholderText: prompt.text
    property alias inputMethodHints: textInput.inputMethodHints
    property alias font: textInput.font
    property alias cursorPosition: textInput.cursorPosition
    property alias maximumLength: textInput.maximumLength
    property alias readOnly: textInput.readOnly
    property alias acceptableInput: textInput.acceptableInput
    property alias inputMask: textInput.inputMask
    property alias validator: textInput.validator
    property alias selectedText: textInput.selectedText
    property alias selectionStart: textInput.selectionStart
    property alias selectionEnd: textInput.selectionEnd
    property alias echoMode: textInput.echoMode
    property bool errorHighlight: !acceptableInput
    property alias enableSoftwareInputPanel: textInput.activeFocusOnPress
    property bool platformEnableEditBubble: true
    property QtObject platformStyle: TextFieldStyle {}
    property alias style: root.platformStyle
    property alias platformPreedit: inputMethodObserver.preedit
    property alias platformWesternNumericInputEnforced: textInput.westernNumericInputEnforced
    property bool platformSelectable: true
    // private
    property int __preeditDisabledMask: Qt.ImhHiddenText |
                                         Qt.ImhNoPredictiveText |
                                         Qt.ImhDigitsOnly |
                                         Qt.ImhFormattedNumbersOnly |
                                         Qt.ImhDialableCharactersOnly |
                                         Qt.ImhEmailCharactersOnly |
                                         Qt.ImhUrlCharactersOnly
 
     property bool __hadFocusBeforeMinimization: false
     // Flags to manage selection state across gestures
     // `isSelectingByGesture` indicates an *active* press or drag gesture.
     property bool isSelectingByGesture: false
     // `selectionMadeByGesture` is true if a selection was *just made* by a long-press, double-tap, or drag.
     // This flag ensures the selection persists on the *immediate release* of that gesture.
     property bool selectionMadeByGesture: false
    signal accepted // Emitted when textInput.accepted is triggered


    Connections {
        target: orientation // Assumes 'orientation' is exposed from C++
        function onOrientationChanged() {
            if ( root.activeFocus ) {
                console.log("onOrientationChanged: repositioning because orientation changed.")
                if (TextAreaHelper && typeof TextAreaHelper.repositionFlickable === 'function') {
                    TextAreaHelper.repositionFlickable(contentMovingAnimation);
                }
                if (SelectionHandles && typeof SelectionHandles.adjustPosition === 'function') {
                    SelectionHandles.adjustPosition();
                }
                if (platformEnableEditBubble) {
                    if (textInput.selectedText.length > 0) {
                        if (Popup && typeof Popup.open === 'function') {
                            Popup.open(textInput, textInput.positionToRectangle(textInput.selectionStart));
                        }
                    } else {
                        if (Popup && typeof Popup.open === 'function') {
                            Popup.open(textInput, textInput.positionToRectangle(textInput.cursorPosition));
                        }
                    }
                }
            }
        }
    }

    // --- Helper Functions for Text Input ---
    function copy() { textInput.copy() }
    function paste() { textInput.paste() }
    function cut() { textInput.cut() }
    function select(start, end) { textInput.select(start, end) }
    function selectAll() { textInput.selectAll() }
    function selectWord() { textInput.selectWord() }
    // Unified positionAt for multi-line support
    function positionAt(x, y) {
        var p = mapToItem(textInput, x, y);
        return textInput.positionAt(p.x, p.y);
    }
    // Correct positionToRectangle to map to root coordinates
    function positionToRectangle(pos) {
        var rect = textInput.positionToRectangle(pos);
        var mappedTopLeft = mapFromItem(textInput, rect.x, rect.y);
        return Qt.rect(mappedTopLeft.x, mappedTopLeft.y, rect.width, rect.height);
    }
    function forceActiveFocus() { textInput.forceActiveFocus() }

    // --- Software Input Panel (SIP) Management ---
    function closeSoftwareInputPanel() {
        console.log("TextField's function closeSoftwareInputPanel is deprecated. Use function platformCloseSoftwareInputPanel instead.")
        platformCloseSoftwareInputPanel()
    }
    function platformCloseSoftwareInputPanel() {
        inputContext.simulateSipClose();
        Qt.inputMethod.hide();
    }
    function openSoftwareInputPanel() {
        console.log("TextField's function openSoftwareInputPanel is deprecated. Use function platformOpenSoftwareInputPanel instead.")
        platformOpenSoftwareInputPanel()
    }
    function platformOpenSoftwareInputPanel() {
        inputContext.simulateSipOpen();
        Qt.inputMethod.show();
    }

    width: platformStyle.defaultWidth
    height: UI.FIELD_DEFAULT_HEIGHT                             // --- Focus Management ---
    onActiveFocusChanged: {
        if (activeFocus) {
            if (!readOnly) {
                platformOpenSoftwareInputPanel();
            }
            repositionTimer.running = true;
        } else { // Lost focus
            if (Popup && typeof Popup.close === 'function') {
                Popup.close(textInput);
            }
            if (SelectionHandles && typeof SelectionHandles.close === 'function') {
                SelectionHandles.close(textInput);
            }
            if (textInput.selectedText.length > 0) {
                textInput.deselect();
            }
        }
        background.source = pickBackground();
    }

    // ADD THIS NEW ELEMENT: It waits for the keyboard to be visible before showing the popup.
    Connections {
        target: Qt.inputMethod

        function onVisibleChanged() {
            // STEP 2: Keyboard is now visible AND our text field still has focus.
            if (Qt.inputMethod.visible && root.activeFocus) {
                console.log("TextField: Keyboard is now visible. It's safe to open the popup.");

                // Use callLater as a final precaution to ensure the geometry has settled.
                Qt.callLater(function() {
                    if (!root.activeFocus) return; // Final check in case focus was lost.

                    if (Popup && !Popup.isOpened(textInput)) {
                        if (textInput.selectedText.length > 0) {
                            if (SelectionHandles) SelectionHandles.open(textInput);
                            Popup.open(textInput, textInput.positionToRectangle(textInput.selectionStart));
                        } else {
                            Popup.open(textInput, textInput.positionToRectangle(textInput.cursorPosition));
                        }
                        if (SelectionHandles) SelectionHandles.adjustPosition();
                    }
                });
            } else if (!Qt.inputMethod.visible && root.activeFocus) {
                // Keyboard was hidden externally (e.g. back key). Release focus.
                root.focus = false;
            }
        }
    }

    // --- Background Styling ---
    function pickBackground() {
        if (errorHighlight) {
            return platformStyle.backgroundError;
        }
        if (textInput.activeFocus) {
            return platformStyle.backgroundSelected;
        }
        if (readOnly) {
            return platformStyle.backgroundDisabled;
        }
        return platformStyle.background;
    }

    BorderImage {
        id: background
        source: pickBackground();
        anchors.fill: parent
        border.left: root.platformStyle.backgroundCornerMargin; border.top: root.platformStyle.backgroundCornerMargin
        border.right: root.platformStyle.backgroundCornerMargin; border.bottom: root.platformStyle.backgroundCornerMargin
    }

    // --- Placeholder Text ---
    Text {
        id: prompt
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            leftMargin: root.platformStyle.paddingLeft
            rightMargin: root.platformStyle.paddingRight
            verticalCenterOffset: root.platformStyle.baselineOffset
        }
        font: root.platformStyle.textFont
        color: root.platformStyle.promptTextColor
        elide: Text.ElideRight
        opacity: 0.0

        states: [
            State {
                name: "unfocused"
                when: !root.activeFocus && textInput.cursorPosition === 0 && !textInput.text && prompt.text && !textInput.inputMethodComposing
                PropertyChanges { target: prompt; opacity: 1.0; }
            },
            State {
                name: "focused"
                when: root.activeFocus && textInput.cursorPosition === 0 && !textInput.text && prompt.text && !textInput.inputMethodComposing
                PropertyChanges { target: prompt; opacity: 0.6; }
            }
        ]

        transitions: [
            Transition {
                from: "unfocused"; to: "focused";
                reversible: true
                SequentialAnimation {
                    PauseAnimation { duration: 60 }
                    NumberAnimation { target: prompt; properties: "opacity"; duration: 150  }
                }
            },
            Transition {
                from: "focused"; to: "";
                reversible: true
                SequentialAnimation {
                    PauseAnimation { duration:  60 }
                    NumberAnimation { target: prompt; properties: "opacity"; duration: 100 }
                }
            }
        ]
    }

    // --- Outer MouseArea for Initial Focus ---
    MouseArea {
        enabled: !textInput.activeFocus // Only enabled if textInput is NOT active.
        z: enabled ? 1 : 0 // Ensure it's above other elements when active
        anchors.fill: parent
        anchors.margins: UI.TOUCH_EXPANSION_MARGIN
        onClicked: mouse => {
                       console.log("--- START OF ACTION ---");
                       console.log("1. TextField -> MouseArea: Clicked. Forcing active focus.");

                       if (!textInput.activeFocus) {
                           textInput.forceActiveFocus();
                           console.log("it is forcing for active focus now. keyboard is open?")
                       }
                       mouse.accepted = true;
                   }
    }

    // --- Main TextInput Component ---
    TextInput {
        id: textInput
        clip: true // Fixes text going outside of TextField border

        property alias preedit: inputMethodObserver.preedit
        property alias preeditCursorPosition: inputMethodObserver.preeditCursorPosition

        property bool westernNumericInputEnforced: false
        property bool suppressInputMethod: !activeFocusOnPress

        inputMethodHints: Qt.ImhNoTextHandles // Disables native selection handles (CRITICAL for custom handles)
        onWesternNumericInputEnforcedChanged: {
            if (inputContext) {
                inputContext.update();
            }
        }

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
        }
        anchors.leftMargin: root.platformStyle.paddingLeft
        anchors.rightMargin: root.platformStyle.paddingRight
        anchors.verticalCenterOffset: root.platformStyle.baselineOffset

        passwordCharacter: "\u2022"
        font: root.platformStyle.textFont
        color: root.platformStyle.textColor
        selectByMouse: false // CRITICAL: Completely disable TextInput's internal drag selection.
        selectedTextColor: root.platformStyle.selectedTextColor
        selectionColor: root.platformStyle.selectionColor
        // Removed mouseSelectionMode: TextInput.NoSelection as it caused "undefined" error.
        // We will rely entirely on selectByMouse: false and C++ MouseFilter signals.
        focus: true // Initially focused, can be managed by parent FocusScope

        Component.onDestruction: {
            if (SelectionHandles && typeof SelectionHandles.close === 'function') {
                SelectionHandles.close(textInput);
            }
            if (Popup && typeof Popup.close === 'function') {
                Popup.close(textInput);
            }
        }

        // --- Connections to Flickable and InputContext ---
        Connections {
            target: Utils.findFlickable(root.parent) // Listen to the flickable containing the text input

            function onContentYChanged() {
                if (root.activeFocus) {
                    if (TextAreaHelper && typeof TextAreaHelper.filteredInputContextUpdate === 'function') {
                        TextAreaHelper.filteredInputContextUpdate();
                    }
                    if (SelectionHandles && typeof SelectionHandles.adjustPosition === 'function') {
                        SelectionHandles.adjustPosition();
                    }
                }
            }
            function onContentXChanged() {
                if (root.activeFocus) {
                    if (TextAreaHelper && typeof TextAreaHelper.filteredInputContextUpdate === 'function') {
                        TextAreaHelper.filteredInputContextUpdate();
                    }
                    if (SelectionHandles && typeof SelectionHandles.adjustPosition === 'function') {
                        SelectionHandles.adjustPosition();
                    }
                }
            }
            function onMovementEnded() {
                if (inputContext) {
                    inputContext.update();
                }
                if (root.activeFocus && platformEnableEditBubble) {
                    if (textInput.selectedText.length > 0) {
                        if (SelectionHandles && typeof SelectionHandles.open === 'function') {
                            SelectionHandles.open(textInput);
                        }
                        if (Popup && typeof Popup.open === 'function') {
                            Popup.open(textInput, textInput.positionToRectangle(textInput.selectionStart));
                        }
                    } else {
                        if (Popup && typeof Popup.open === 'function') {
                            Popup.open(textInput, textInput.positionToRectangle(textInput.cursorPosition));
                        }
                    }
                    if (SelectionHandles && typeof SelectionHandles.adjustPosition === 'function') {
                        SelectionHandles.adjustPosition();
                    }
                }
            }
        }

        Connections {
            target: inputContext
            function onSoftwareInputPanelRectChanged() {
                if (activeFocus) {
                    repositionTimer.running = true
                }
            }
        }

        // --- TextInput's own Focus/ActiveFocus Handlers ---
        onFocusChanged: { root.focusChanged(root.focus) }
        onActiveFocusChanged: { root.activeFocusChanged(root.activeFocus) }

        // --- Text/Cursor/Selection Change Handlers ---
        onTextChanged: {
            if(root.activeFocus) {
                if (TextAreaHelper && typeof TextAreaHelper.repositionFlickable === 'function') {
                    TextAreaHelper.repositionFlickable(contentMovingAnimation);
                }
 
                 if (Popup && typeof Popup.isOpened === 'function' && Popup.isOpened(textInput) &&
                         (!Popup.getPrivateRect || !Popup.getPrivateRect() || !Popup.getPrivateRect().pastingText)) {
                     if (Popup && typeof Popup.close === 'function') {
                         Popup.close(textInput);
                     }
                 }
                 if (SelectionHandles && typeof SelectionHandles.close === 'function') {
                     SelectionHandles.close(textInput);
                 }
                 root.isSelectingByGesture = false;
                 root.selectionMadeByGesture = false;
             }
         }

        onCursorPositionChanged: {
            console.log("onCursorPositionChanged. Cursor:", textInput.cursorPosition, "SelectedText.length:", textInput.selectedText.length);

            if (root.activeFocus) {
                if (textInput.selectedText.length === 0) {
                    if (SelectionHandles && typeof SelectionHandles.open === 'function' && !textInput.readOnly) {
                        SelectionHandles.open(textInput);
                    }
                    // Only open cursor bubble if not actively dragging and not a gesture
                    // The edit bubble is now opened by onDoubleClicked, so we no longer open it here.
                    // We do, however, need to ensure it's closed if the user moves the cursor
                    // while the bubble is open.
                    if (Popup && typeof Popup.isOpened === 'function' && Popup.isOpened(textInput)) {
                        if (Popup && typeof Popup.close === 'function') {
                            Popup.close(textInput);
                        }
                    }
                } else { // Text is selected
                    if (platformEnableEditBubble) {
                        if (SelectionHandles && typeof SelectionHandles.open === 'function') {
                            SelectionHandles.open(textInput);
                        }
                        if (Popup && typeof Popup.open === 'function') {
                            Popup.open(textInput, textInput.positionToRectangle(textInput.selectionStart));
                        }
                    }
                }
                // The handle position is now adjusted in onCursorRectangleChanged
            } else { // If not focused, ensure Popup and Handles are closed
                if (Popup && typeof Popup.close === 'function') {
                    Popup.close(textInput);
                }
                if (SelectionHandles && typeof SelectionHandles.close === 'function') {
                    SelectionHandles.close(textInput);
                }
            }
        }

        onCursorRectangleChanged: {
            if (root.activeFocus && SelectionHandles && typeof SelectionHandles.adjustPosition === 'function') {
                SelectionHandles.adjustPosition();
            }
        }

        onSelectedTextChanged: {
            console.log("onSelectedTextChanged. Selected Text:", textInput.selectedText,
                        "root.selectionMadeByGesture:", root.selectionMadeByGesture,
                        "mouseFilter.pressed:", mouseFilter.pressed, "mouseFilter.dragActive:", mouseFilter.dragActive);

            if ( !platformSelectable ) {
                textInput.deselect();
            }

            if (root.activeFocus) {
                if (textInput.selectedText.length === 0) {
                    // Only close UI if mouse is released AND no drag is active.
                    if (!mouseFilter.pressed && !mouseFilter.dragActive) {
                        console.log("onSelectedTextChanged: Text deselected (mouse released/no active drag). Closing handles and popup.");
                        if (Popup && typeof Popup.close === 'function') {
                            Popup.close(textInput);
                        }
                        if (SelectionHandles && typeof SelectionHandles.open === 'function' && !textInput.readOnly) {
                            SelectionHandles.open(textInput);
                        }
                        // The edit bubble is now opened by onDoubleClicked, so we no longer open it here.
                        root.selectionMadeByGesture = false; // Reset the flag definitively
                    } else {
                        console.log("onSelectedTextChanged: Text deselected, but mouse is pressed/drag active. Ignoring closure/reset to prevent flicker.");
                        // Do NOT close popups/handles or reset selectionMadeByGesture here.
                        // The C++ MouseFilter's signals or QML's DragHandler will manage.
                    }
                } else { // Text selected
                    console.log("onSelectedTextChanged: Text selected. Opening handles and and popup.");
                    // If selection happened during a press or drag (C++ MouseFilter will signal this)
                    if (mouseFilter.pressed || mouseFilter.dragActive) {
                        console.log("onSelectedTextChanged: Detected selection from active gesture. Setting selectionMadeByGesture = true.");
                        root.selectionMadeByGesture = true;
                    }

                    if (platformEnableEditBubble) {
                        if (SelectionHandles && typeof SelectionHandles.open === 'function') {
                            SelectionHandles.open(textInput);
                        }
                        if (Popup && typeof Popup.open === 'function') {
                            Popup.open(textInput, textInput.positionToRectangle(textInput.selectionStart));
                        }
                    }
                }
                if (SelectionHandles && typeof SelectionHandles.adjustPosition === 'function') {
                    SelectionHandles.adjustPosition();
                }
            } else {
                if (Popup && typeof Popup.close === 'function') {
                    Popup.close(textInput);
                }
                if (SelectionHandles && typeof SelectionHandles.close === 'function') {
                    SelectionHandles.close(textInput);
                }
            }
        }

        InputMethodObserver {
            id: inputMethodObserver

            onPreeditChanged: {
                if(root.activeFocus) {
                    if (TextAreaHelper && typeof TextAreaHelper.repositionFlickable === 'function') {
                        TextAreaHelper.repositionFlickable(contentMovingAnimation)
                    }
                }

                if (Popup && typeof Popup.isOpened === 'function' && Popup.isOpened(textInput) && (!Popup.isChangingInput || !Popup.isChangingInput())) {
                    if (Popup && typeof Popup.close === 'function') {
                        Popup.close(textInput);
                    }
                }
            }
        }

        Timer {
            id: repositionTimer
            interval: 350
            onTriggered: {
                if (TextAreaHelper && typeof TextAreaHelper.repositionFlickable === 'function') {
                    TextAreaHelper.repositionFlickable(contentMovingAnimation)
                }
            }
        }

        Timer {
            id: typingTimer
            interval: 500 // Adjust as needed
            repeat: false
            onTriggered: {
                if (SelectionHandles) {
                    console.log("TextField.qml: typingTimer triggered -> setting typing to false");
                    SelectionHandles.typing = false;
                }
            }
        }

        PropertyAnimation {
            id: contentMovingAnimation
            property: "contentY"
            duration: 200
            easing.type: Easing.InOutCubic
        }

        // ===== C++ MouseFilter Integration (using your registered "MouseFilter" name) =====
        MouseFilter { // IMPORTANT: Changed from MDeclarativeMouseFilter to MouseFilter
            id: mouseFilter
            // MouseFilter inherits from QQuickItem, so it has Item properties
            anchors {
                fill: parent
                leftMargin:  UI.TOUCH_EXPANSION_MARGIN - root.platformStyle.paddingLeft
                rightMargin: UI.TOUCH_EXPANSION_MARGIN - root.platformStyle.paddingRight
                topMargin: UI.TOUCH_EXPANSION_MARGIN - ((root.height - parent.height) / 2)
                bottomMargin: UI.TOUCH_EXPANSION_MARGIN - ((root.height - parent.height) / 2)
            }

            // Internal QML state properties, analogous to old QML MouseFilter
            // These are driven by the C++ signals
            property bool attemptToActivate: false
            property bool pressOnPreedit: false
            property int oldCursorPosition: 0
            property variant editBubblePosition: null // Used to store position for EditBubble after release
            property int lastTapTime: 0
            property point lastTapPosition: Qt.point(-1, -1)

            Timer {
                id: singleTapTimer
                interval: 400 // A bit longer than a typical double-click time
                onTriggered: {
                    // Reset if the timer runs out, meaning it was just a single tap
                    mouseFilter.lastTapTime = 0
                    mouseFilter.lastTapPosition = Qt.point(-1, -1)
                }
            }

            // These flags reflect state from C++
            property bool dragActive: false // Set by onHorizontalDrag, reset by onFinished
            property bool pressed: false // Set by onPressed, reset by onReleased


            // --- Connect to MDeclarativeMouseFilter Signals ---

            onPressed: (mouse) => { // 'mouse' is an MDeclarativeMouseEvent*
                           var currentTime = new Date().getTime();
                           var currentPosition = Qt.point(mouse.x, mouse.y);
                           var timeDiff = currentTime - mouseFilter.lastTapTime;
                           var posDiff = Math.sqrt(Math.pow(currentPosition.x - mouseFilter.lastTapPosition.x, 2) + Math.pow(currentPosition.y - mouseFilter.lastTapPosition.y, 2));

                           // Check if it's a second tap at roughly the same position, but not fast enough to be a double-click
                           if (mouseFilter.lastTapTime > 0 && timeDiff < singleTapTimer.interval && posDiff < 15) { // 15 pixels tolerance
                               // This is the second tap. Use callLater to check for selection AFTER the double-click signal has had a chance to fire.
                               // This is the second tap. Use callLater to check for selection AFTER the double-click signal has had a chance to fire.
                               Qt.callLater(function() {
                                   // If no text is selected, it wasn't a double-click to select, so we can show the bubble.
                                   if (textInput.selectedText.length === 0 && platformEnableEditBubble) {
                                       if (Popup && typeof Popup.open === 'function') {
                                           Popup.open(textInput, textInput.positionToRectangle(textInput.cursorPosition));
                                       }
                                   }
                               });

                               // Reset after action
                               singleTapTimer.stop();
                               mouseFilter.lastTapTime = 0;
                               mouseFilter.lastTapPosition = Qt.point(-1, -1);
                               mouse.filtered = true; // Consume this press event
                               return; // Stop further processing for this tap
                           } else {
                               // This is the first tap of a potential sequence
                               mouseFilter.lastTapTime = currentTime;
                               mouseFilter.lastTapPosition = currentPosition;
                               singleTapTimer.start();
                           }

                           mouseFilter.pressed = true; // Update internal pressed state
                           console.log("C++ MouseFilter: onPressed. Point:", mouse.x, mouse.y);
                           root.isSelectingByGesture = true; // Mark an active gesture

                           var mousePosition = textInput.positionAt(mouse.x, mouse.y); // Use mouse.x, mouse.y from C++ event
                           mouseFilter.pressOnPreedit = (textInput.cursorPosition === mousePosition);
                           mouseFilter.oldCursorPosition = textInput.cursorPosition;

                           var preeditDisabled = root.inputMethodHints & root.__preeditDisabledMask;
                           mouseFilter.attemptToActivate =
                           !mouseFilter.pressOnPreedit && !root.readOnly && !preeditDisabled && root.activeFocus &&
                           !(mousePosition === 0 ||
                             (TextAreaHelper && typeof TextAreaHelper.atSpace === 'function' && TextAreaHelper.atSpace(mousePosition - 1, textInput.text)) ||
                             (TextAreaHelper && typeof TextAreaHelper.atSpace === 'function' && TextAreaHelper.atSpace(mousePosition, textInput.text)));

                           // Close UI elements on press for a clean slate, they will reopen if needed by selection changes
                           if (Popup && typeof Popup.close === 'function') {
                               Popup.close(textInput);
                           }
                           if (SelectionHandles && typeof SelectionHandles.close === 'function') {
                               SelectionHandles.close(textInput);
                           }
                           mouse.filtered = true; // Signal C++ that QML handled this press
                       }

            onDelayedPressSent: {
                console.log("C++ MouseFilter: onDelayedPressSent.");
                if (textInput.preedit) {
                    textInput.cursorPosition = mouseFilter.oldCursorPosition;
                }
                // When delayed press becomes a drag, ensure previous state is cleared for new drag selection
                textInput.deselect(); // Clear any existing selection before new drag starts
                textInput.selectByMouse = true; // Enable textInput's internal drag selection mode
                root.selectionMadeByGesture = false; // Reset, as this is a new drag gesture
            }

            onHorizontalDrag: (mouse) => {
                                  console.log("C++ MouseFilter: onHorizontalDrag.");
                                  mouseFilter.dragActive = true; // Indicate active drag
                                  // possible pre-edit word have to be commited before selection
                                  if (root.activeFocus || root.readOnly) {
                                      inputContext.reset();
                                      if( root.platformSelectable ) {
                                          textInput.selectByMouse = true; // Allow TextInput to track selection during drag
                                          root.selectionMadeByGesture = true; // Mark that a drag-selection is happening
                                      }
                                      mouseFilter.attemptToActivate = false;
                                  }
                                  // }
                                  // The C++ MouseFilter should handle `mouse.filtered = true;` internally for this signal.
                              }

            onPressAndHold: (mouse) => { // 'mouse' is an MDeclarativeMouseEvent*
                                console.log("C++ MouseFilter: onPressAndHold. Point:", mouse.x, mouse.y);
                                mouseFilter.dragActive = false; // Ensure dragActive is false for pure press-and-hold
                                // possible pre-edit word have to be commited before showing the magnifier
                                // Set cursor and select word
                                if (root.platformSelectable) {
                                    textInput.cursorPosition = textInput.positionAt(mouse.x, mouse.y);
                                    textInput.selectWord();
                                    root.selectionMadeByGesture = true; // Mark selection by gesture
                                }
                                // }
                                mouse.filtered = true; // Signal C++ that QML handled this
                            }

            onReleased: (mouse) => { // 'mouse' is an MDeclarativeMouseEvent*
                            mouseFilter.pressed = false; // Update internal pressed state
                            console.log("C++ MouseFilter: onReleased. Point:", mouse.x, mouse.y, "root.selectionMadeByGesture:", root.selectionMadeByGesture);

                            root.isSelectingByGesture = false; // Gesture ended

                            // Final check for selection persistence after release
                            if (root.selectionMadeByGesture && textInput.selectedText.length > 0) {
                                console.log("onReleased: Selection persistence logic: selectionMadeByGesture was true, text still selected. Keeping selection.");
                                root.selectionMadeByGesture = false; // Consume the flag
                                // Open/adjust handles and popup for the persistent selection
                                if (root.activeFocus && platformEnableEditBubble) {
                                    if (SelectionHandles && typeof SelectionHandles.open === 'function') {
                                        SelectionHandles.open(textInput);
                                    }
                                    if (Popup && typeof Popup.open === 'function') {
                                        Popup.open(textInput, textInput.positionToRectangle(textInput.selectionStart));
                                    }
                                    if (SelectionHandles && typeof SelectionHandles.adjustPosition === 'function') {
                                        SelectionHandles.adjustPosition();
                                    }
                                }
                            } else {
                                root.selectionMadeByGesture = false; // Reset the flag if no gesture selection or text was deselected
                                // Apply the old onReleased logic for attemptToActivate and preedit injection if no selection persisted
                                if (mouseFilter.attemptToActivate) {
                                    var newCursorPosition = textInput.positionAt(mouse.x, mouse.y);
                                    var beforeText = textInput.text;
                                    textInput.cursorPosition = newCursorPosition;
                                    var injectionSucceeded = false;

                                    if (!TextAreaHelper.atSpace(newCursorPosition, beforeText) && newCursorPosition !== beforeText.length) {
                                        injectionSucceeded = TextAreaHelper.injectWordToPreedit(newCursorPosition, beforeText);
                                    }
                                    if (injectionSucceeded) {
                                        if (textInput.preedit.length >=1 && textInput.preedit.length <= 4)
                                        mouseFilter.editBubblePosition = textInput.positionToRectangle(textInput.cursorPosition+1);
                                    } else {
                                        textInput.text = beforeText;
                                        textInput.cursorPosition = newCursorPosition;
                                    }
                                } else if (!textInput.selectByMouse) {
                                    if (!mouseFilter.pressOnPreedit) inputContext.reset();
                                    textInput.cursorPosition = textInput.positionAt(mouse.x, mouse.y);
                                }
                                textInput.selectByMouse = false;
                                mouseFilter.attemptToActivate = false;
                            }
                            mouse.filtered = true; // Signal C++ that QML handled this release

                            // Old onFinished logic (to open popups/handles after the entire gesture is done)
                            // This will only run if a selection was not explicitly made and persisted above
                            if (root.activeFocus && platformEnableEditBubble && !root.selectionMadeByGesture && textInput.selectedText.length === 0) {
                                if (mouseFilter.editBubblePosition != null) {
                                    Popup.open(textInput, mouseFilter.editBubblePosition);
                                    mouseFilter.editBubblePosition = null;
                                } else if (textInput.selectedText.length === 0 && textInput.preedit.length === 0) {
                                    // Bubble is now only opened by the second-tap logic in onPressed
                                }
                                if (textInput.selectedText.length > 0) { // Should not be true here if selectionMadeByGesture is false
                                    SelectionHandles.open(textInput);
                                }
                                SelectionHandles.adjustPosition();
                            }
                        }

            onFinished: {
                console.log("C++ MouseFilter: onFinished.");
                // This signal implies all mouse event handling for a gesture is truly done.
                // Reset dragActive after entire gesture is finished
                mouseFilter.dragActive = false;
                mouseFilter.attemptToActivate = false;
                // The `onFinished` logic should now primarily be cleanup.
                // Most of the UI update (popup/handles) should happen in onReleased or onSelectedTextChanged.
            }

            onMousePositionChanged: (mouse) => { // 'mouse' is an MDeclarativeMouseEvent*
                                        // This signal is emitted when mouse moves but no long-press timer or drag is active.
                                        if (SelectionHandles && typeof SelectionHandles.adjustPosition === 'function') {
                                            SelectionHandles.adjustPosition();
                                        }
                                        mouse.filtered = true; // Signal C++ that QML handled this
                                    }

            onDoubleClicked: (mouse) => { // 'mouse' is an MDeclarativeMouseEvent*
                                 console.log("C++ MouseFilter: onDoubleClicked. Point:", mouse.x, mouse.y);
                                 inputContext.reset();
                                 mouseFilter.attemptToActivate = false; // Reset attemptToActivate on double click

                                 if (root.platformSelectable) {
                                     textInput.cursorPosition = textInput.positionAt(mouse.x, mouse.y);
                                     textInput.selectWord();
                                     root.selectionMadeByGesture = true; // Mark selection by gesture
                                 }

                                 mouse.filtered = true; // Signal C++ that QML handled this
                             }
        }
        // ===== End of C++ MouseFilter Integration =====
    }

    InverseMouseArea {
        anchors.fill: parent
        anchors.margins: UI.TOUCH_EXPANSION_MARGIN
        enabled: textInput.activeFocus // Only enabled when textInput has focus
        onClickedOutside: {
            console.log("InverseMouseArea: ClickedOutside");
            var bubbleGeom = Popup && typeof Popup.geometry === 'function' ? Popup.geometry() : null;
            if (Popup && typeof Popup.isOpened === 'function' && Popup.isOpened(textInput) && bubbleGeom !== null && bubbleGeom !== undefined &&
                    ((mouseX > bubbleGeom.left && mouseX < bubbleGeom.right) &&
                     (mouseY > bubbleGeom.top && mouseY < bubbleGeom.bottom))) {
                return; // Click was on the popup, don't lose focus
            }
            root.parent.focus = true; // Lose focus from TextField if clicked completely outside.
            platformCloseSoftwareInputPanel();
            if (textInput.selectedText.length > 0) {
                textInput.deselect();
            }
            root.selectionMadeByGesture = false; // Clear this flag if clicked outside
        }
    }

    Component.onCompleted: {
        console.log("TextField.qml Component.onCompleted: platformWindow.active?", platformWindow.active)
        textInput.accepted.connect(accepted)
    }
}
