import QtQuick 2.1
import com.meego.components 1.0
import "Utils.js" as Utils
import "UIConstants.js" as UI
import "EditBubble.js" as Popup // Now refers to the JS functions
import "TextAreaHelper.js" as TextAreaHelper
import "Magnifier.js" as MagnifierPopup // Now refers to the JS functions
import "SelectionHandles.js" as SelectionHandlesJS // --- CHANGE: Added JS alias ---

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

    property bool platformEnableEditBubble: true
    property bool platformEnableMagnifier: true

    property QtObject platformStyle: TextFieldStyle {}

    property alias style: root.platformStyle

    property Component customSoftwareInputPanel

    property Component platformCustomSoftwareInputPanel

    property alias platformPreedit: inputMethodObserver.preedit

    property alias platformWesternNumericInputEnforced: actualTextInput.westernNumericInputEnforced
    property bool platformSelectable: true

    // Expose the actual TextInput item for external components like EditBubble.js
    property alias internalTextInput: actualTextInput

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
            AndroidViewControl.disableNativeTextSelection(); // Use AndroidViewControl directly

            if (root.platformEnableEditBubble || root.platformEnableMagnifier) {
                // Do nothing here, our custom dialogs will open on press/hold
                // or via other logic in MouseFilter.
            } else if (!readOnly && platformCustomSoftwareInputPanel != null) {
                platformOpenSoftwareInputPanel();
            } else {
                inputContext.simulateSipOpen();
            }
            repositionTimer.running = true;
        } else {
            // --- CHANGE: Use SelectionHandlesJS alias ---
            Popup.close(root);
            SelectionHandlesJS.close(actualTextInput);
            // --- END CHANGE ---
        }

        if (!activeFocus)
            MagnifierPopup.close();
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
                    if (!TextAreaHelper.atSpace(newCursorPosition, beforeText)
                        && newCursorPosition !== beforeText.length
                        && !(newCursorPosition === 0 || TextAreaHelper.atSpace(newCursorPosition - 1, beforeText))) {

                        injectionSucceeded = TextAreaHelper.injectWordToPreedit(newCursorPosition, beforeText);
                    }
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
        activeFocusOnPress: !(root.platformEnableEditBubble || root.platformEnableMagnifier)

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
        selectByMouse: false
        selectedTextColor: root.platformStyle.selectedTextColor
        selectionColor: root.platformStyle.selectionColor
        focus: true

        Component.onDestruction: {
            // --- CHANGE: Use SelectionHandlesJS alias ---
            SelectionHandlesJS.close(actualTextInput);
            Popup.close(root);
            // --- END CHANGE ---
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

            if (Popup.isOpened(root)) {
                if (Popup.hasPastingText()) {
                    inputContext.clearClipboard();
                    Popup.clearPastingText();
                }
                if (!Popup.isChangingInput()) {
                    Popup.close(root);
                }
            }
            // --- CHANGE: Use SelectionHandlesJS alias ---
            SelectionHandlesJS.close(actualTextInput);
            // --- END CHANGE ---
        }

        onCursorPositionChanged: {
            if (MagnifierPopup.isOpened() && Popup.isOpened()) {
                Popup.close(root);
            } else if (!mouseFilter.attemptToActivate || actualTextInput.cursorPosition === actualTextInput.text.length) {
                if (platformEnableEditBubble) {
                    Popup.close(root);
                    var cursorRect = actualTextInput.positionToRectangle(actualTextInput.cursorPosition);
                    var mappedPos = actualTextInput.mapToItem(Popup.popup.parent, cursorRect.x + cursorRect.width / 2, cursorRect.y + cursorRect.height / 2);
                    var popupOpened = Popup.open(root, mappedPos); // Pass root as the TextField instance
                    if (!popupOpened) {
                        console.warn("Popup.open failed in onCursorPositionChanged.");
                    }
                }
                // --- CHANGE: Use SelectionHandlesJS alias ---
                if (SelectionHandlesJS.isOpened(actualTextInput) && actualTextInput.selectedText === "") {
                    SelectionHandlesJS.close(actualTextInput);
                }
                if (!SelectionHandlesJS.isOpened(actualTextInput) && actualTextInput.selectedText !== "" && platformEnableEditBubble === true) {
                    SelectionHandlesJS.open(actualTextInput);
                }
                SelectionHandlesJS.adjustPosition();
                // --- END CHANGE ---
            }
        }

        onSelectedTextChanged: {
            if (!platformSelectable)
                actualTextInput.deselect();

            if (Popup.isOpened(root) && !Popup.isChangingInput()) {
                Popup.close(root);
            }
            // --- CHANGE: Use SelectionHandlesJS alias ---
            if (SelectionHandlesJS.isOpened(actualTextInput) && actualTextInput.selectedText === "") {
                SelectionHandlesJS.close(actualTextInput)
            }
            // --- END CHANGE ---
        }

        InputMethodObserver {
            id: inputMethodObserver

            onPreeditChanged: {
                if(root.activeFocus) {
                    TextAreaHelper.repositionFlickable(contentMovingAnimation)
                }

                if (Popup.isOpened(root) && !Popup.isChangingInput()) {
                    Popup.close(root);
                }
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

            property variant editBubblePosition: null

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
                        parent.selectByMouse = true
                    attemptToActivate = false
                }
            }

            onPressAndHold: mouse=> {
                if (platformEnableMagnifier &&
                    (root.text !== "" || inputMethodObserver.preedit !== "") && root.activeFocus) {
                    inputContext.reset()
                    attemptToActivate = false
                    var magnifierOpened = MagnifierPopup.open(root);
                    if (magnifierOpened) {
                        var magnifier = MagnifierPopup.popup;
                        var mappedMousePosToTextInput = mouseFilter.mapToItem(actualTextInput, mouse.x, mouse.y);
                        magnifier.xCenter = mappedMousePosToTextInput.x;
                        magnifier.yCenter = mappedMousePosToTextInput.y;

                        var magnifierWidth = magnifier.width || 200;
                        var magnifierHeight = magnifier.height || 100;
                        var mappedPosToParent = mouseFilter.mapToItem(MagnifierPopup.popup.parent, mouse.x - magnifierWidth / 2, mouse.y - magnifierHeight - UI.MARGIN_XLARGE);

                        magnifier.x = mappedPosToParent.x;
                        magnifier.y = mappedPosToParent.y;

                        parent.cursorPosition = actualTextInput.positionAt(mouse.x)
                    } else {
                        console.warn("MagnifierPopup.open failed in onPressAndHold because component not ready or other issue.");
                    }
                }
            }

            onReleased: mouse=> {
                if (MagnifierPopup.isOpened()) {
                    MagnifierPopup.close();
                }

                if (attemptToActivate)
                    inputContext.reset();

                var newCursorPosition = actualTextInput.positionAt(mouse.x, mouse.y);
                if (actualTextInput.preedit.length === 0)
                    editBubblePosition = actualTextInput.positionToRectangle(newCursorPosition);

                if (attemptToActivate) {
                    var beforeText = actualTextInput.text;

                    actualTextInput.cursorPosition = newCursorPosition;
                    var injectionSucceeded = false;

                    if (!TextAreaHelper.atSpace(newCursorPosition, beforeText)
                             && newCursorPosition !== beforeText.length) {
                        injectionSucceeded = TextAreaHelper.injectWordToPreedit(newCursorPosition, beforeText);
                    }
                    if (injectionSucceeded) {
                        mouse.filtered=true;
                        if (actualTextInput.preedit.length >=1 && actualTextInput.preedit.length <= 4)
                            editBubblePosition = actualTextInput.positionToRectangle(actualTextInput.cursorPosition+1)
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
                if (root.activeFocus && platformEnableEditBubble) {
                    if (actualTextInput.preedit.length === 0) {
                        editBubblePosition = actualTextInput.positionToRectangle(actualTextInput.cursorPosition);
                    }
                    if (editBubblePosition != null) {
                        var bubbleRectCenter = Qt.point(editBubblePosition.x + editBubblePosition.width / 2, editBubblePosition.y + editBubblePosition.height / 2);
                        var mappedBubblePos = actualTextInput.mapToItem(Popup.popup.parent, bubbleRectCenter.x, bubbleRectCenter.y);

                        var popupOpened = Popup.open(root, mappedBubblePos);
                        if (!popupOpened) {
                            console.warn("Popup.open failed in onFinished because component not ready or other issue.");
                        }
                        editBubblePosition = null
                    }
                    // --- CHANGE: Use SelectionHandlesJS alias ---
                    if (actualTextInput.selectedText !== "")
                        SelectionHandlesJS.open(actualTextInput);
                    SelectionHandlesJS.adjustPosition();
                    // --- END CHANGE ---
                }
                attemptToActivate = false
            }

            onMousePositionChanged: mouse=> {
                if (MagnifierPopup.isOpened() && !parent.selectByMouse) {
                    actualTextInput.cursorPosition = actualTextInput.positionAt(mouse.x, mouse.y);
                    var magnifier = MagnifierPopup.popup;
                    var mappedMousePosToTextInput = mouseFilter.mapToItem(actualTextInput, mouse.x, mouse.y);
                    magnifier.xCenter = mappedMousePosToTextInput.x;
                    magnifier.yCenter = mappedMousePosToTextInput.y;

                    var magnifierWidth = magnifier.width || 200;
                    var mappedPosToParent = mouseFilter.mapToItem(MagnifierPopup.popup.parent, mouse.x - magnifierWidth / 2, mouse.y - magnifier.height - UI.MARGIN_XLARGE);
                    magnifier.x = mappedPosToParent.x;
                }
                // --- CHANGE: Use SelectionHandlesJS alias ---
                SelectionHandlesJS.adjustPosition();
                // --- END CHANGE ---
            }

            onDoubleClicked: mouse=> {
                inputContext.reset()
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
            // --- CHANGE: Use SelectionHandlesJS alias in Popup.geometry() call ---
            if (Popup.isOpened(root) && ((mouseX > Popup.geometry().left && mouseX < Popup.geometry().right) &&
                                           (mouseY > Popup.geometry().top && mouseY < Popup.geometry().bottom))) {
                return;
            }
            // --- END CHANGE ---
            root.parent.focus = true;
        }
    }

    Component.onCompleted: actualTextInput.accepted.connect(accepted)
}
