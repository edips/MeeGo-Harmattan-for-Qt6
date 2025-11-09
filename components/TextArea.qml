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

import QtQuick // Reverted to QtQuick 2.1 as per your original code's imports
import com.meego.components 1.0 // Retained as per your original code
import "Utils.js" as Utils
import "UIConstants.js" as UI
import "EditBubble.js" as Popup
import "TextAreaHelper.js" as TextAreaHelper
import "SelectionHandles.js" as SelectionHandles

FocusScope {
    id: root
    // Common public API
    property alias text: textEdit.text
    property alias placeholderText: prompt.text
    property alias font: textEdit.font
    property alias cursorPosition: textEdit.cursorPosition
    property alias readOnly: textEdit.readOnly
    property alias horizontalAlignment: textEdit.horizontalAlignment
    property alias verticalAlignment: textEdit.verticalAlignment
    property alias selectedText: textEdit.selectedText
    property alias selectionStart: textEdit.selectionStart
    property alias selectionEnd: textEdit.selectionEnd
    property alias wrapMode: textEdit.wrapMode
    property alias textFormat: textEdit.textFormat
    // Property enableSoftwareInputPanel is DEPRECATED
    property alias enableSoftwareInputPanel: textEdit.activeFocusOnPress
    property alias inputMethodHints: textEdit.inputMethodHints
    property bool errorHighlight: false
    property bool platformEnableEditBubble: true
    property QtObject platformStyle: TextAreaStyle {}
    property alias style: root.platformStyle
    property alias platformPreedit: inputMethodObserver.preedit
    //force a western numeric input panel even when vkb is set to arabic
    property alias platformWesternNumericInputEnforced: textEdit.westernNumericInputEnforced
    property bool platformSelectable: true
    // Flags to manage selection state across gestures
    // `isSelectingByGesture` indicates an *active* press or drag gesture.
    property bool isSelectingByGesture: false
    // `selectionMadeByGesture` is true if a selection was *just made* by a long-press, double-tap, or drag.
    // This flag ensures the selection persists on the *immediate release* of that gesture.
    property bool selectionMadeByGesture: false
    property int __originalHeight: 0;
    property bool __ignoreHeightChange: false;
    onHeightChanged:{
        if (!__ignoreHeightChange) __originalHeight = root.height;
    }
    Connections {
        target: textEdit
        function onHeightChanged() {
            __ignoreHeightChange = true;
            root.height = Math.max (__originalHeight, implicitHeight)
            __ignoreHeightChange = false;

        }
    }
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
    function copy() {textEdit.copy()}
    function paste() {textEdit.paste()}
    function cut() {textEdit.cut()}
    // ensure propagation of forceActiveFocus
    function forceActiveFocus() {textEdit.forceActiveFocus()}
    function select(start, end) {textEdit.select(start, end)}
    function selectAll() {textEdit.selectAll()}
    function selectWord() {textEdit.selectWord()}
    function positionAt(x, y) {
        var p = mapToItem(textEdit, x, y);
        return textEdit.positionAt(p.x, p.y)
    }
    function positionToRectangle(pos) {
        var rect = textEdit.positionToRectangle(pos)
        var point = mapFromItem(textEdit, rect.x, rect.y)
        rect.x = point.x; rect.y = point.y
        return rect;
    }
    function closeSoftwareInputPanel() {platformCloseSoftwareInputPanel()}
    function platformCloseSoftwareInputPanel() {
        inputContext.simulateSipClose();
        Qt.inputMethod.hide();
    }
    function openSoftwareInputPanel() {platformOpenSoftwareInputPanel()}
    function platformOpenSoftwareInputPanel() {
        inputContext.simulateSipOpen();
        Qt.inputMethod.show();
    }
    Timer {
        id: positionTimer
        interval: 1 // A minimal delay is sufficient
        repeat: false
        onTriggered: SelectionHandles.adjustPosition()
    }
    // private
    property int __preeditDisabledMask: Qt.ImhHiddenText |
                                        Qt.ImhNoPredictiveText |
                                        Qt.ImhDigitsOnly |
                                        Qt.ImhFormattedNumbersOnly |
                                        Qt.ImhDialableCharactersOnly |
                                        Qt.ImhEmailCharactersOnly |
                                        Qt.ImhUrlCharactersOnly

    property bool __hadFocusBeforeMinimization: false
    implicitWidth: platformStyle.defaultWidth
    implicitHeight: Math.max (UI.FIELD_DEFAULT_HEIGHT,
                              textEdit.height + (UI.FIELD_DEFAULT_HEIGHT - font.pixelSize))
    onActiveFocusChanged: {
        if (activeFocus) {
            if (!readOnly) {
                platformOpenSoftwareInputPanel();
            }
            repositionTimer.running = true;
        } else { // Lost focus
            Popup.close(textEdit);
            SelectionHandles.close(textEdit);
        }
        background.source = pickBackground();
    }
    Connections {
        target: Qt.inputMethod

        function onVisibleChanged() {
            if (Qt.inputMethod.visible && root.activeFocus) {
                Qt.callLater(function() {
                    if (!root.activeFocus) return;

                    if (Popup && !Popup.isOpened(textEdit)) {
                         if (textEdit.selectedText.length > 0) {
                            if (SelectionHandles) SelectionHandles.open(textEdit);
                            Popup.open(textEdit, textEdit.positionToRectangle(textEdit.selectionStart));
                        } else {
                            Popup.open(textEdit, textEdit.positionToRectangle(textEdit.cursorPosition));
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
    function pickBackground() {
        if (errorHighlight) {
            return platformStyle.backgroundError;
        }
        if (activeFocus) {
            return platformStyle.backgroundSelected;
        }
        if (readOnly) {
            return platformStyle.backgroundDisabled;
        }
        return platformStyle.background;
    }
    BorderImage {
        id: background
        source:pickBackground()

        anchors.fill: parent
        border.left: root.platformStyle.backgroundCornerMargin; border.top: root.platformStyle.backgroundCornerMargin
        border.right: root.platformStyle.backgroundCornerMargin; border.bottom: root.platformStyle.backgroundCornerMargin
    }
    Text {
        id: prompt

        anchors.fill: parent
        anchors.leftMargin: UI.PADDING_XLARGE
        anchors.rightMargin: UI.PADDING_XLARGE
        anchors.topMargin: (UI.FIELD_DEFAULT_HEIGHT - font.pixelSize) / 2
        anchors.bottomMargin: (UI.FIELD_DEFAULT_HEIGHT - font.pixelSize) / 2
        font: root.platformStyle.textFont
        color: root.platformStyle.promptTextColor
        elide: Text.ElideRight
        // opacity for default state
        opacity:  0.0
        states: [
            State {
                name: "unfocused"
                // memory allocation optimization: cursorPosition is checked to minimize displayText evaluations
                when: !root.activeFocus && textEdit.cursorPosition == 0 && !textEdit.text && prompt.text && !textEdit.inputMethodComposing
                PropertyChanges { target: prompt; opacity: 1.0; }
            },
            State {
                name: "focused"
                // memory allocation optimization: cursorPosition is checked to minimize displayText evaluations
                when: root.activeFocus && textEdit.cursorPosition == 0 && !textEdit.text && prompt.text && !textEdit.inputMethodComposing
                PropertyChanges { target: prompt; opacity: 0.6; }
            }
        ]
        transitions: [
            Transition {
                from: "unfocused"; to: "focused";
                reversible: true
                SequentialAnimation {
                    PauseAnimation { duration: 60 }
                    NumberAnimation { target: prompt; properties: "opacity"; duration: 150 }
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

    MouseArea {
            enabled: !textEdit.activeFocus
            z: enabled?1:0
            anchors.fill: parent
            anchors.margins: UI.TOUCH_EXPANSION_MARGIN
            onClicked: mouse=> {
                if (!textEdit.activeFocus) {
                    textEdit.forceActiveFocus();
                    // activate to preedit and/or move the cursor
                    var preeditDisabled = root.inputMethodHints &
                                          root.__preeditDisabledMask
                    var injectionSucceeded = false;
                    // FIXED: Use mouse.x and mouse.y to get the event coordinates
                    var mappedMousePos = mapToItem(textEdit, mouse.x, mouse.y);
                    var newCursorPosition = textEdit.positionAt(mappedMousePos.x, mappedMousePos.y);
                    if (!preeditDisabled) {
                        var beforeText = textEdit.text;
                        if (!TextAreaHelper.atSpace(newCursorPosition, beforeText)
                            && newCursorPosition !== beforeText.length
                            && !(newCursorPosition === 0 || TextAreaHelper.atSpace(newCursorPosition - 1, beforeText))) {

                            injectionSucceeded = TextAreaHelper.injectWordToPreedit(newCursorPosition, beforeText);
                        }
                    }
                    if (!injectionSucceeded) {
                        textEdit.cursorPosition = newCursorPosition;
                    }
                }
            }
        }

    TextEdit {
        id: textEdit
        // Exposed for the edit bubble
        property alias preedit: inputMethodObserver.preedit
        property alias preeditCursorPosition: inputMethodObserver.preeditCursorPosition
        // this properties are evaluated by the input method framework
        property bool westernNumericInputEnforced: false
        property bool suppressInputMethod: !activeFocusOnPress
        // We are extra careful about compatibility with prior versions, so
        // instead of setting persistentSelection directly we store its state so
        // that we get its original state back once the window has focus again.
        property bool savePersistentSelection: false
        // FIXME: HACK: this is working around QTBUG-25644, FocusScope's signals
        // aren't correctly emitted
        onActiveFocusChanged: {
            root.activeFocusChanged(root.activeFocus)
        }
        // FIXME: HACK: this is working around QTBUG-25644, FocusScope's signals
        // aren't correctly emitted
        onFocusChanged: {
            root.focusChanged(root.focus)
        }
        onWesternNumericInputEnforcedChanged: {
            inputContext.update();
        }
        x: UI.PADDING_XLARGE
        y: (UI.FIELD_DEFAULT_HEIGHT - font.pixelSize) / 2
        width: parent.width - UI.PADDING_XLARGE * 2
        font: root.platformStyle.textFont
        color: root.platformStyle.textColor
        selectByMouse: false
        selectedTextColor: root.platformStyle.selectedTextColor
        selectionColor: root.platformStyle.selectionColor
        mouseSelectionMode: TextInput.SelectWords
        wrapMode: TextEdit.Wrap
        persistentSelection: false
        focus: true
        inputMethodHints: Qt.ImhNoTextHandles // Disables native selection handles (CRITICAL for custom handles)
        onTextChanged: {
            if(root.activeFocus) {
                if (Popup && typeof Popup.isOpened === 'function' && Popup.isOpened(textEdit) &&
                    (!Popup.getPrivateRect || !Popup.getPrivateRect() || !Popup.getPrivateRect().pastingText)) {
                    if (Popup && typeof Popup.close === 'function') {
                        Popup.close(textEdit);
                    }
                }
                if (SelectionHandles && typeof SelectionHandles.close === 'function') {
                    SelectionHandles.close(textEdit);
                }
                root.isSelectingByGesture = false;
                root.selectionMadeByGesture = false;
            }
        }
        Connections {
            target: Utils.findFlickable(root.parent)
            function onContentYChanged(){
                if (root.activeFocus) {
                    TextAreaHelper.filteredInputContextUpdate();
                    SelectionHandles.adjustPosition();
                }
            }
            function onContentXChanged() {
                if (root.activeFocus) {
                    TextAreaHelper.filteredInputContextUpdate();
                    SelectionHandles.adjustPosition();
                }
            }
            function onMovementEnded() {
                inputContext.update();
            }
        }

        Connections {
            target: inputContext

            function onSoftwareInputPanelVisibleChanged() {
                if (activeFocus)
                    TextAreaHelper.repositionFlickable(contentMovingAnimation);
            }

            function onSoftwareInputPanelRectChanged() {
                if (activeFocus)
                    TextAreaHelper.repositionFlickable(contentMovingAnimation);
            }
        }

        onCursorPositionChanged: {
            if (root.activeFocus) {
                if (textEdit.selectedText.length === 0) {
                    if (SelectionHandles && typeof SelectionHandles.open === 'function' && !textEdit.readOnly) {
                        SelectionHandles.open(textEdit);
                    }
                    if (Popup && typeof Popup.isOpened === 'function' && Popup.isOpened(textEdit)) {
                        if (Popup && typeof Popup.close === 'function') {
                            Popup.close(textEdit);
                        }
                    }
                } else { // Text is selected
                    if (platformEnableEditBubble) {
                        if (SelectionHandles && typeof SelectionHandles.open === 'function') {
                            SelectionHandles.open(textEdit);
                        }
                        if (Popup && typeof Popup.open === 'function') {
                            Popup.open(textEdit, textEdit.positionToRectangle(textEdit.selectionStart));
                        }
                    }
                }
            } else { // If not focused, ensure Popup and Handles are closed
                if (Popup && typeof Popup.close === 'function') {
                    Popup.close(textEdit);
                }
                if (SelectionHandles && typeof SelectionHandles.close === 'function') {
                    SelectionHandles.close(textEdit);
                }
            }
        }

        onSelectedTextChanged: {
            if ( !platformSelectable ) {
                textEdit.deselect();
            }

            if (root.activeFocus) {
                if (textEdit.selectedText.length === 0) {
                    if (!mouseFilter.pressed && !mouseFilter.dragActive) {
                        if (Popup && typeof Popup.close === 'function') {
                            Popup.close(textEdit);
                        }
                        if (SelectionHandles && typeof SelectionHandles.open === 'function' && !textEdit.readOnly) {
                            SelectionHandles.open(textEdit);
                        }
                        root.selectionMadeByGesture = false;
                    }
                } else { // Text selected
                    if (mouseFilter.pressed || mouseFilter.dragActive) {
                        root.selectionMadeByGesture = true;
                    }

                    if (platformEnableEditBubble) {
                        if (SelectionHandles && typeof SelectionHandles.open === 'function') {
                            SelectionHandles.open(textEdit);
                        }
                        if (Popup && typeof Popup.open === 'function') {
                            Popup.open(textEdit, textEdit.positionToRectangle(textEdit.selectionStart));
                        }
                    }
                }
                if (SelectionHandles && typeof SelectionHandles.adjustPosition === 'function') {
                    SelectionHandles.adjustPosition();
                }
            } else {
                if (Popup && typeof Popup.close === 'function') {
                    Popup.close(textEdit);
                }
                if (SelectionHandles && typeof SelectionHandles.close === 'function') {
                    SelectionHandles.close(textEdit);
                }
            }
        }

        onCursorRectangleChanged: {
            if (root.activeFocus && SelectionHandles && typeof SelectionHandles.adjustPosition === 'function') {
                SelectionHandles.adjustPosition();
            }
        }
        InputMethodObserver {
            id: inputMethodObserver

            onPreeditChanged: {
                /*if (Popup.isOpened(textEdit) && !Popup.isChangingInput()) {
                    Popup.close(textEdit);
                }*/
                if (SelectionHandles.isOpened(textEdit)) {
                    SelectionHandles.close(textEdit);
                }
            }
        }
        Timer {
            id: repositionTimer
            interval: 350
            onTriggered: TextAreaHelper.repositionFlickable(contentMovingAnimation)
        }
        PropertyAnimation {
            id: contentMovingAnimation
            property: "contentY"
            duration: 200
            easing.type: Easing.InOutCubic
        }
        MouseFilter {
            id: mouseFilter
            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
                leftMargin:  UI.TOUCH_EXPANSION_MARGIN - UI.PADDING_XLARGE
                rightMargin:  UI.TOUCH_EXPANSION_MARGIN - UI.PADDING_XLARGE
                topMargin: UI.TOUCH_EXPANSION_MARGIN - (UI.FIELD_DEFAULT_HEIGHT - font.pixelSize) / 2
                bottomMargin:  UI.TOUCH_EXPANSION_MARGIN - (UI.FIELD_DEFAULT_HEIGHT - font.pixelSize) / 2
            }
            height: root.height - anchors.bottomMargin
            property bool attemptToActivate: false
            property bool pressOnPreedit: false
            property int oldCursorPosition: 0
            property variant editBubblePosition: null
            property int lastTapTime: 0
            property point lastTapPosition: Qt.point(-1, -1)
            property bool dragActive: false
            property bool pressed: false
            Timer {
                id: singleTapTimer
                interval: 400
                onTriggered: {
                    mouseFilter.lastTapTime = 0
                    mouseFilter.lastTapPosition = Qt.point(-1, -1)
                }
            }
            onPressed: (mouse) => {
                var currentTime = new Date().getTime();
                var currentPosition = Qt.point(mouse.x, mouse.y);
                var timeDiff = currentTime - mouseFilter.lastTapTime;
                var posDiff = Math.sqrt(Math.pow(currentPosition.x - mouseFilter.lastTapPosition.x, 2) + Math.pow(currentPosition.y - mouseFilter.lastTapPosition.y, 2));

                if (mouseFilter.lastTapTime > 0 && timeDiff < singleTapTimer.interval && posDiff < 15) {
                    Qt.callLater(function() {
                        if (textEdit.selectedText.length === 0 && platformEnableEditBubble) {
                            if (Popup && typeof Popup.open === 'function') {
                                Popup.open(textEdit, textEdit.positionToRectangle(textEdit.cursorPosition));
                            }
                        }
                    });
                    singleTapTimer.stop();
                    mouseFilter.lastTapTime = 0;
                    mouseFilter.lastTapPosition = Qt.point(-1, -1);
                    mouse.filtered = true;
                    return;
                } else {
                    mouseFilter.lastTapTime = currentTime;
                    mouseFilter.lastTapPosition = currentPosition;
                    singleTapTimer.start();
                }

                mouseFilter.pressed = true;
                root.isSelectingByGesture = true;

                var mousePosition = textEdit.positionAt(mouse.x, mouse.y);
                mouseFilter.pressOnPreedit = (textEdit.cursorPosition === mousePosition);
                mouseFilter.oldCursorPosition = textEdit.cursorPosition;

                var preeditDisabled = root.inputMethodHints & root.__preeditDisabledMask;
                mouseFilter.attemptToActivate =
                    !mouseFilter.pressOnPreedit && !root.readOnly && !preeditDisabled && root.activeFocus &&
                    !(mousePosition === 0 ||
                      (TextAreaHelper && typeof TextAreaHelper.atSpace === 'function' && TextAreaHelper.atSpace(mousePosition - 1, textEdit.text)) ||
                      (TextAreaHelper && typeof TextAreaHelper.atSpace === 'function' && TextAreaHelper.atSpace(mousePosition, textEdit.text)));

                if (Popup && typeof Popup.close === 'function') {
                    Popup.close(textEdit);
                }
                if (SelectionHandles && typeof SelectionHandles.close === 'function') {
                    SelectionHandles.close(textEdit);
                }
                mouse.filtered = true;
            }
            onDelayedPressSent: {
                if (textEdit.preedit) {
                    textEdit.cursorPosition = mouseFilter.oldCursorPosition;
                }
                textEdit.deselect();
                textEdit.selectByMouse = true;
                root.selectionMadeByGesture = false;
            }
            onHorizontalDrag: (mouse) => {
                mouseFilter.dragActive = true;
                if (root.activeFocus || root.readOnly) {
                    inputContext.reset();
                    if( root.platformSelectable ) {
                        textEdit.selectByMouse = true;
                        root.selectionMadeByGesture = true;
                    }
                    mouseFilter.attemptToActivate = false;
                }
            }
            onPressAndHold: (mouse) => {
                mouseFilter.dragActive = false;
                if (root.platformSelectable) {
                    textEdit.cursorPosition = textEdit.positionAt(mouse.x, mouse.y);
                    textEdit.selectWord();
                    root.selectionMadeByGesture = true;
                }
                mouse.filtered = true;
            }
            onReleased: (mouse) => { // 'mouse' is an MDeclarativeMouseEvent*
                            mouseFilter.pressed = false; // Update internal pressed state
                            console.log("C++ MouseFilter: onReleased. Point:", mouse.x, mouse.y, "root.selectionMadeByGesture:", root.selectionMadeByGesture);

                            root.isSelectingByGesture = false; // Gesture ended

                            // Final check for selection persistence after release
                            if (root.selectionMadeByGesture && textEdit.selectedText.length > 0) {
                                console.log("onReleased: Selection persistence logic: selectionMadeByGesture was true, text still selected. Keeping selection.");
                                root.selectionMadeByGesture = false; // Consume the flag
                                // Open/adjust handles and popup for the persistent selection
                                if (root.activeFocus && platformEnableEditBubble) {
                                    if (SelectionHandles && typeof SelectionHandles.open === 'function') {
                                        SelectionHandles.open(textEdit);
                                    }
                                    if (Popup && typeof Popup.open === 'function') {
                                        Popup.open(textEdit, textEdit.positionToRectangle(textEdit.selectionStart));
                                    }
                                    if (SelectionHandles && typeof SelectionHandles.adjustPosition === 'function') {
                                        SelectionHandles.adjustPosition();
                                    }
                                 }
                            } else {
                                root.selectionMadeByGesture = false; // Reset the flag if no gesture selection or text was deselected
                                // Apply the old onReleased logic for attemptToActivate and preedit injection if no selection persisted
                                if (mouseFilter.attemptToActivate) {
                                    var newCursorPosition = textEdit.positionAt(mouse.x, mouse.y);
                                    var beforeText = textEdit.text;
                                    textEdit.cursorPosition = newCursorPosition;
                                    var injectionSucceeded = false;

                                    if (!TextAreaHelper.atSpace(newCursorPosition, beforeText) && newCursorPosition !== beforeText.length) {
                                        injectionSucceeded = TextAreaHelper.injectWordToPreedit(newCursorPosition, beforeText);
                                    }
                                    if (injectionSucceeded) {
                                        if (textEdit.preedit.length >=1 && textEdit.preedit.length <= 4)
                                        mouseFilter.editBubblePosition = textEdit.positionToRectangle(textEdit.cursorPosition+1);
                                    } else {
                                        textEdit.text = beforeText;
                                        textEdit.cursorPosition = newCursorPosition;
                                    }
                                } else if (!textEdit.selectByMouse) {
                                    if (!mouseFilter.pressOnPreedit) inputContext.reset();
                                    textEdit.cursorPosition = textEdit.positionAt(mouse.x, mouse.y);
                                }
                                textEdit.selectByMouse = false;
                                mouseFilter.attemptToActivate = false;
                            }
                            mouse.filtered = true; // Signal C++ that QML handled this release

                            // Old onFinished logic (to open popups/handles after the entire gesture is done)
                            // This will only run if a selection was not explicitly made and persisted above
                            if (root.activeFocus && platformEnableEditBubble && !root.selectionMadeByGesture && textEdit.selectedText.length === 0) {
                                if (mouseFilter.editBubblePosition != null) {
                                    Popup.open(textEdit, mouseFilter.editBubblePosition);
                                    mouseFilter.editBubblePosition = null;
                                } else if (textEdit.selectedText.length === 0 && textEdit.preedit.length === 0) {
                                    // Bubble is now only opened by the second-tap logic in onPressed
                                }
                                if (textEdit.selectedText.length > 0) { // Should not be true here if selectionMadeByGesture is false
                                    SelectionHandles.open(textEdit);
                                }
                                SelectionHandles.adjustPosition();
                            }
                        }
            onFinished: {
                mouseFilter.dragActive = false;
                mouseFilter.attemptToActivate = false;
            }
            onMousePositionChanged: (mouse) => {
                if (SelectionHandles && typeof SelectionHandles.adjustPosition === 'function') {
                    SelectionHandles.adjustPosition();
                }
                mouse.filtered = true;
            }
            onDoubleClicked: (mouse) => {
                inputContext.reset();
                mouseFilter.attemptToActivate = false;

                if (root.platformSelectable) {
                    textEdit.cursorPosition = textEdit.positionAt(mouse.x, mouse.y);
                    textEdit.selectWord();
                    root.selectionMadeByGesture = true;
                }
                mouse.filtered = true;
            }
        }
    }

    InverseMouseArea {
        anchors.fill: parent
        anchors.margins: UI.TOUCH_EXPANSION_MARGIN
        enabled: textEdit.activeFocus
        onClickedOutside: {
            root.parent.focus = true;
            platformCloseSoftwareInputPanel();
        }
    }
}
