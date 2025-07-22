import QtQuick 2.1
import com.meego.components 1.0
import "Utils.js" as Utils
import "UIConstants.js" as UI
// --- REMOVED: import "EditBubble.js" as Popup ---
import "TextAreaHelper.js" as TextAreaHelper

FocusScope {
    id: root

    // Common API
    property alias text: actualTextInput.text
    property alias placeholderText: prompt.text

    property alias inputMethodHints: actualTextInput.inputMethodHints
    property alias font: actualTextInput.font
    property alias cursorPosition: actualTextInput.cursorPosition
    property alias maximumLength: actualTextInput.maximumLength
    property alias readOnly: actualTextInput.readOnly
    property alias acceptableInput: actualTextInput.acceptableInput
    property alias inputMask: actualTextInput.inputMask
    property alias validator: actualTextInput.validator

    property alias selectedText: actualTextInput.selectedText
    property alias selectionStart: actualTextInput.selectionStart
    property alias selectionEnd: actualTextInput.selectionEnd

    property alias echoMode: actualTextInput.echoMode

    property bool errorHighlight: !acceptableInput

    property alias enableSoftwareInputPanel: actualTextInput.activeFocusOnPress

    property Item platformSipAttributes

    // --- REMOVED: property bool platformEnableEditBubble: true ---
    // --- REMOVED: property bool platformEnableMagnifier: true ---

    property QtObject platformStyle: TextFieldStyle {}

    property alias style: root.platformStyle

    property Component customSoftwareInputPanel

    property Component platformCustomSoftwareInputPanel

    property alias platformPreedit: inputMethodObserver.preedit

    property alias platformWesternNumericInputEnforced: actualTextInput.westernNumericInputEnforced
    property bool platformSelectable: true // Keep this true to allow selection

    // --- REMOVED: Expose the actual TextInput item for external components like EditBubble.js ---

    signal accepted

    onPlatformSipAttributesChanged: {
        platformSipAttributes.registerInputElement(actualTextInput)
    }

    onCustomSoftwareInputPanelChanged: {
        console.log("TextField's property customSoftwareInputPanel is deprecated. Use property platformCustomSoftwareInputPanel instead.")
        platformCustomSoftwareInputPanel = customSoftwareInputPanel
    }

    onPlatformCustomSoftwareInputPanelChanged: {
        actualTextInput.activeFocusOnPress = platformCustomSoftwareInputPanel == null
    }

    // These functions will now rely on native Android behavior if TextInput supports it
    function copy() { actualTextInput.copy() }
    function paste() { actualTextInput.paste() }
    function cut() { actualTextInput.cut() }
    function select(start, end) { actualTextInput.select(start, end) }
    function selectAll() { actualTextInput.selectAll() }
    function selectWord() { actualTextInput.selectWord() }

    function positionAt(x) {
        var p = mapToItem(actualTextInput, x, 0);
        return actualTextInput.positionAt(p.x)
    }

    function positionToRectangle(pos) {
        var rect = actualTextInput.positionToRectangle(pos)
        rect.x = mapFromItem(actualTextInput, rect.x, 0).x
        return rect;
    }

    function forceActiveFocus() { actualTextInput.forceActiveFocus() }

    function closeSoftwareInputPanel() {
        console.log("TextField's function closeSoftwareInputPanel is deprecated. Use function platformCloseSoftwareInputPanel instead.")
        platformCloseSoftwareInputPanel()
    }

    function platformCloseSoftwareInputPanel() {
        inputContext.simulateSipClose();
        if (inputContext.customSoftwareInputPanelVisible) {
            inputContext.customSoftwareInputPanelVisible = false
            inputContext.customSoftwareInputPanelComponent = null
            inputContext.customSoftwareInputPanelTextField = null
        } else {
            Qt.inputMethod.hide();
        }
    }

    function openSoftwareInputPanel() {
        console.log("TextField's function openSoftwareInputPanel is deprecated. Use function platformOpenSoftwareInputPanel instead.")
        platformOpenSoftwareInputPanel()
    }

    function platformOpenSoftwareInputPanel() {
        inputContext.simulateSipOpen();
        if (platformCustomSoftwareInputPanel != null && !inputContext.customSoftwareInputPanelVisible) {
            inputContext.customSoftwareInputPanelTextField = root
            inputContext.customSoftwareInputPanelComponent = platformCustomSoftwareInputPanel
            inputContext.customSoftwareInputPanelVisible = true
        } else {
            Qt.inputMethod.show();
        }
    }

    property int __preeditDisabledMask: Qt.ImhHiddenText|
                                        Qt.ImhNoPredictiveText|
                                        Qt.ImhDigitsOnly|
                                        Qt.ImhFormattedNumbersOnly|
                                        Qt.ImhDialableCharactersOnly|
                                        Qt.ImhEmailCharactersOnly|
                                        Qt.ImhUrlCharactersOnly

    width: platformStyle.defaultWidth
    height: UI.FIELD_DEFAULT_HEIGHT

    onActiveFocusChanged: {
        if (activeFocus) {
            // --- CHANGE: Removed AndroidViewControl.disableNativeTextSelection() ---
            // This call was for disabling native selection, which we now want to enable.

            // With custom EditBubble removed, always open SIP or custom SIP
            if (!readOnly && platformCustomSoftwareInputPanel != null) {
                platformOpenSoftwareInputPanel();
            } else {
                inputContext.simulateSipOpen();
            }
            repositionTimer.running = true;
        } else {
            // --- REMOVED: Popup.close(root) and SelectionHandlesJS.close(actualTextInput) ---
            // Native selection will handle closing its UI
        }

        background.source = pickBackground();
    }

    function pickBackground() {
        if (errorHighlight) {
            return platformStyle.backgroundError;
        }
        if (actualTextInput.activeFocus) {
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
                when: !root.activeFocus && actualTextInput.cursorPosition === 0 && !actualTextInput.text && prompt.text && !actualTextInput.inputMethodComposing
                PropertyChanges { target: prompt; opacity: 1.0; }
            },
            State {
                name: "focused"
                when: root.activeFocus && actualTextInput.cursorPosition === 0 && !actualTextInput.text && prompt.text && !actualTextInput.inputMethodComposing
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

    MouseArea {
        enabled: !actualTextInput.activeFocus
        z: enabled?1:0
        anchors.fill: parent
        anchors.margins: UI.TOUCH_EXPANSION_MARGIN
        onClicked: {
            if (!actualTextInput.activeFocus) {
                actualTextInput.forceActiveFocus();

                var preeditDisabled = root.inputMethodHints &
                                      root.__preeditDisabledMask
                var injectionSucceeded = false;
                var newCursorPosition = actualTextInput.positionAt(mapToItem(actualTextInput, mouseX, mouseY).x,TextInput.CursorOnCharacter);
                if (!preeditDisabled) {
                    var beforeText = actualTextInput.text
                    // --- CHANGE: Removed custom pre-edit injection logic ---
                    // This logic was for custom word selection/pre-edit, which might conflict with native.
                    // If you need custom pre-edit, this section would need careful re-evaluation.
                    // For now, relying on native input method.
                    // if (!TextAreaHelper.atSpace(newCursorPosition, beforeText)
                    //     && newCursorPosition !== beforeText.length
                    //     && !(newCursorPosition === 0 || TextAreaHelper.atSpace(newCursorPosition - 1, beforeText))) {
                    //     injectionSucceeded = TextAreaHelper.injectWordToPreedit(newCursorPosition, beforeText);
                    // }
                }
                if (!injectionSucceeded) {
                    actualTextInput.cursorPosition=newCursorPosition;
                }
            }
        }
    }

    TextInput {
        id: actualTextInput
        clip: true
        activeFocusOnPress: true // Always true to allow native SIP/selection

        property alias preedit: inputMethodObserver.preedit
        property alias preeditCursorPosition: inputMethodObserver.preeditCursorPosition

        property bool westernNumericInputEnforced: false

        onWesternNumericInputEnforcedChanged: {
            inputContext.update();
        }

        anchors {verticalCenter: parent.verticalCenter; left: parent.left; right: parent.right}
        anchors.leftMargin: root.platformStyle.paddingLeft
        anchors.rightMargin: root.platformStyle.paddingRight
        anchors.verticalCenterOffset: root.platformStyle.baselineOffset

        passwordCharacter: "\u2022"
        font: root.platformStyle.textFont
        color: root.platformStyle.textColor
        selectByMouse: false // Let native handle mouse selection
        selectedTextColor: root.platformStyle.selectedTextColor
        selectionColor: root.platformStyle.selectionColor
        focus: true

        Component.onDestruction: {
            // --- REMOVED: SelectionHandlesJS.close(actualTextInput) and Popup.close(root) ---
            // Native selection will handle its own cleanup.
        }

        Connections {
            target: Utils.findFlickable(root.parent)
            ignoreUnknownSignals: true
            function onContentY() {
                if (root.activeFocus) {
                    TextAreaHelper.filteredInputContextUpdate()
                }
            }

            function onContentX() {
                if (root.activeFocus) {
                    TextAreaHelper.filteredInputContextUpdate()
                }
            }

            function onMovementEnded() {
                inputContext.update()
            }
        }

        Connections {
            target: Qt.inputMethod
            ignoreUnknownSignals: true
            function onKeyboardRectangle() {
                if (activeFocus) {
                    repositionTimer.running = true;
                }
            }
        }

        onFocusChanged: {
            root.focusChanged(root.focus)
        }

        onActiveFocusChanged: {
            root.activeFocusChanged(root.activeFocus)
        }

        onTextChanged: {
            if(root.activeFocus) {
                TextAreaHelper.repositionFlickable(contentMovingAnimation)
            }

            // --- REMOVED: Popup (EditBubble) related logic ---
            // --- REMOVED: SelectionHandlesJS.close(actualTextInput) ---
        }

        onCursorPositionChanged: {
            // --- REMOVED: All EditBubble and SelectionHandlesJS related logic ---
            // Native Android text selection will manage its own cursor UI and handles.
        }

        onSelectedTextChanged: {
            if (!platformSelectable)
                actualTextInput.deselect();

            // --- REMOVED: Popup (EditBubble) related logic ---
            // --- REMOVED: SelectionHandlesJS related logic ---
        }

        InputMethodObserver {
            id: inputMethodObserver

            onPreeditChanged: {
                if(root.activeFocus) {
                    TextAreaHelper.repositionFlickable(contentMovingAnimation)
                }

                // --- REMOVED: Popup (EditBubble) related logic ---
            }
        }

        Timer {
            id: repositionTimer
            interval: 350
            onTriggered: {
                TextAreaHelper.repositionFlickable(contentMovingAnimation)
            }
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
                fill: parent
                leftMargin:  UI.TOUCH_EXPANSION_MARGIN - root.platformStyle.paddingLeft
                rightMargin:  UI.TOUCH_EXPANSION_MARGIN - root.platformStyle.paddingRight
                topMargin: UI.TOUCH_EXPANSION_MARGIN - ((root.height - parent.height) / 2)
                bottomMargin:  UI.TOUCH_EXPANSION_MARGIN - ((root.height - parent.height) / 2)
            }
            property bool attemptToActivate: false
            property bool pressOnPreedit: false
            property int oldCursorPosition: 0

            // --- REMOVED: property variant editBubblePosition: null ---

            onPressed: mouse=> {
                var mousePosition = actualTextInput.positionAt(mouse.x, mouse.y);
                pressOnPreedit = actualTextInput.cursorPosition===mousePosition
                oldCursorPosition = actualTextInput.cursorPosition;
                var preeditDisabled = root.inputMethodHints &
                                      root.__preeditDisabledMask

                attemptToActivate = !pressOnPreedit && !root.readOnly && !preeditDisabled && root.activeFocus &&
                                    !(mousePosition === 0 || TextAreaHelper.atSpace(mousePosition - 1) || TextAreaHelper.atSpace(mousePosition));
                mouse.filtered = true;
            }

            onDelayedPressSent:  {
                if (actualTextInput.preedit) {
                    actualTextInput.cursorPosition = oldCursorPosition;
                }
            }

            onHorizontalDrag: {
                if (root.activeFocus || root.readOnly) {
                    inputContext.reset()
                    if( platformSelectable )
                        parent.selectByMouse = true // This might still be useful for QML-level selection if native doesn't fully take over
                    attemptToActivate = false
                }
            }

            onPressAndHold: mouse=> {
                // --- REMOVED: MagnifierPopup related logic ---
                // --- REMOVED: EditBubble/SelectionHandles open logic ---
                // Native Android text selection handles long press for selection.
            }

            onReleased: mouse=> {
                // --- REMOVED: MagnifierPopup and EditBubble/SelectionHandles related logic ---

                if (attemptToActivate)
                    inputContext.reset();

                var newCursorPosition = actualTextInput.positionAt(mouse.x, mouse.y);
                // --- REMOVED: editBubblePosition assignment ---

                if (attemptToActivate) {
                    var beforeText = actualTextInput.text;

                    actualTextInput.cursorPosition = newCursorPosition;
                    var injectionSucceeded = false;

                    // --- CHANGE: Removed custom pre-edit injection logic ---
                    // if (!TextAreaHelper.atSpace(newCursorPosition, beforeText)
                    //          && newCursorPosition !== beforeText.length) {
                    //     injectionSucceeded = TextAreaHelper.injectWordToPreedit(newCursorPosition, beforeText);
                    // }
                    if (injectionSucceeded) {
                        mouse.filtered=true;
                        // --- REMOVED: editBubblePosition adjustment ---
                    } else {
                        actualTextInput.text=beforeText;
                        actualTextInput.cursorPosition=newCursorPosition;
                    }
                } else if (!parent.selectByMouse) {
                    if (!pressOnPreedit) inputContext.reset();
                    actualTextInput.cursorPosition = actualTextInput.positionAt(mouse.x, mouse.y);
                }
                parent.selectByMouse = false;
            }

            onFinished: {
                // --- REMOVED: All EditBubble and SelectionHandlesJS related logic ---
                // Native Android text selection will manage its own UI on interaction finish.
                attemptToActivate = false
            }

            onMousePositionChanged: mouse=> {
                // --- REMOVED: MagnifierPopup related logic ---
                // --- REMOVED: SelectionHandlesJS.adjustPosition() ---
                // Native Android will handle cursor/selection UI updates.
            }

            onDoubleClicked: mouse=> {
                inputContext.reset()
                // Keep this logic as it might still influence QML's internal selectByMouse property
                if (typeof showStatusBar !== "undefined" && actualTextInput.effectiveLayoutDirection === Qt.RightToLeft) {
                    if ( platformSelectable && mouse.x > width - actualTextInput.positionToRectangle( actualTextInput.text.length ).x )
                        parent.selectByMouse = true;
                } else if ( platformSelectable && mouse.x <= actualTextInput.positionToRectangle( actualTextInput.text.length ).x )
                    parent.selectByMouse = true;
                attemptToActivate = false
            }
        }
    }

    InverseMouseArea {
        anchors.fill: parent
        anchors.margins: UI.TOUCH_EXPANSION_MARGIN
        enabled: actualTextInput.activeFocus
        onClickedOutside: {
            // --- REMOVED: Popup.isOpened check ---
            root.parent.focus = true;
        }
    }

    Component.onCompleted: actualTextInput.accepted.connect(accepted)
}
