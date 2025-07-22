.pragma library

Qt.include("Utils.js");
Qt.include("UIConstants.js");

var popup = null; // This will now hold the pre-instantiated EditBubble QML object

// Modified init: now receives the already created QML object
function init(qmlEditBubbleObject)
{
    if (popup !== null) {
        // Already initialized, or a different object was passed previously.
        // For a singleton pattern, we expect init to be called once with the global instance.
        if (popup === qmlEditBubbleObject) {
            return true;
        } else {
            console.warn("EditBubble.js: Attempted to re-initialize with a different EditBubble object. Ignoring.");
            return false;
        }
    }

    if (qmlEditBubbleObject) {
        popup = qmlEditBubbleObject;
        console.log("EditBubble.js: Initialized with pre-instantiated EditBubble QML object.");
        return true;
    } else {
        console.error("EditBubble.js: init received a null QML object.");
        return false;
    }
}

function open(textFieldRoot, position)
{
    if (!popup) {
        console.error("EditBubble.js: Popup not initialized. Call init() first.");
        return false;
    }

    if (!textFieldRoot) {
        console.warn("EditBubble.js: textFieldRoot is undefined, cannot open edit bubble.");
        return false;
    }

    var actualTextInput = textFieldRoot.internalTextInput;
    if (!actualTextInput) {
        console.warn("EditBubble.js: textFieldRoot.internalTextInput is undefined, cannot open edit bubble.");
        return false;
    }

    var canPaste = !actualTextInput.readOnly && actualTextInput.canPaste;
    var textSelected = actualTextInput.selectedText !== "";
    var canCopy = textSelected && (actualTextInput.echoMode === undefined || actualTextInput.echoMode === 0 /* = TextInput.Normal */);
    var canCut = !actualTextInput.readOnly && canCopy;

    if (!(canPaste || canCopy || canCut)) {
        console.log("EditBubble.js: No operations (paste, copy, cut) possible, not opening bubble.");
        return false;
    }

    popup.position = position;
    // --- CHANGE START ---
    // Correctly assign the actual TextInput item to the 'textInput' property of the QML popup
    popup.textInput = actualTextInput;
    // --- CHANGE END ---

    // Ensure the popup is made visible
    popup.visible = true;

    if (popup.valid) {
        popup.state = "opened";
        popup.privateRect.outOfView = false;
        console.log("EditBubble.js: Popup opened successfully at position:", position.x, position.y);
        return true;
    } else {
        popup.textFieldRoot = null;
        popup.textInput = null; // Clear textInput on invalid state
        popup.visible = false; // Hide if not valid
        console.warn("EditBubble.js: Popup is not valid, not opening.");
        return false;
    }
}

function close(textFieldRoot)
{
    // Check if popup is initialized and if the request is for the currently active text field
    if (!popup || !textFieldRoot || popup.textFieldRoot !== textFieldRoot) {
        return false;
    }
    console.log("EditBubble.js: Closing popup.");
    return closePopup(popup);
}

function isOpened(textFieldRoot)
{
    return (popup && popup.visible && popup.textFieldRoot === textFieldRoot);
}

function isChangingInput()
{
    return (popup && popup.privateRect.changingText);
}

function closePopup(bubble)
{
    if (bubble === null || bubble.textFieldRoot === null) {
        return false;
    }
    bubble.state = "closed";
    bubble.textFieldRoot = null;
    bubble.textInput = null; // Clear textInput on close
    bubble.visible = false; // Explicitly hide the QML object
    console.log("EditBubble.js: Popup closed.");
    return true;
}

function adjustPosition(bubble)
{
    if (bubble === undefined)
        bubble = popup;

    if (bubble === null || !bubble.textInput || !bubble.textInput.internalTextInput) { // Use bubble.textInput
        console.warn("EditBubble.js: adjustPosition called with invalid bubble or textInput.");
        return;
    }

    var input = bubble.textInput; // Use bubble.textInput
    var rect = bubble.privateRect;
    var viewport = rect.parent; // This is 'appWindowContent' from PageStackWindow.qml

    if (viewport === null || input === null) {
        console.warn("EditBubble.js: adjustPosition: viewport or input is null.");
        return;
    }

    var px = popup.position.x - rect.width / 2;
    var py = popup.position.y - rect.height; // Position above the cursor/selection

    var SHADOW_SIZE = 6 // From your QML styles

    // Clamp x position within viewport bounds
    rect.x = Math.min(Math.max(px, UI.MARGIN_XLARGE - SHADOW_SIZE), viewport.width - rect.width - (UI.MARGIN_XLARGE - SHADOW_SIZE));

    var statusBarHeight = Utils.statusBarCoveredHeight(bubble);
    var toolBarHeight = Utils.toolBarCoveredHeight(bubble);

    if (py > statusBarHeight + SHADOW_SIZE) { // If there's space above
        rect.y = py - SHADOW_SIZE;
        rect.arrowDown = true;
    } else { // Place below
        rect.y = popup.position.y + input.height + SHADOW_SIZE; // Place below the input field
        rect.arrowDown = false;
    }

    var mappedPopupXToRect = rect.mapFromItem(viewport, popup.position.x, 0).x;
    var boundX = rect.width / 2 - rect.arrowBorder;
    rect.arrowOffset = Math.min(Math.max(-boundX, mappedPopupXToRect - rect.width / 2), boundX);

    console.log("EditBubble.js: Adjusted position to x:", rect.x, "y:", rect.y, "arrowDown:", rect.arrowDown);
}

function enableOffset(enabled){
    if (popup == null)
        return;
    popup.privateRect.positionOffset = enabled ? 40 : 0;
}

function offsetEnabled(){
    if (popup == null)
        return false;
    return popup.privateRect.positionOffset != 0;
}

function updateButtons(row)
{
    var children = row.children;
    var visibleItems = new Array();

    for (var i = 0, j = 0; i < children.length; i++) {
        var child = children[i];

        if (child.visible)
            visibleItems[j++] = child;
    }

    for (var i = 0; i < visibleItems.length; i++) {
        if (visibleItems.length == 1)
            visibleItems[i].platformStyle.position = "";
        else {
            if (i == 0)
                visibleItems[i].platformStyle.position = "horizontal-left";
            else if (i == visibleItems.length - 1)
                visibleItems[i].platformStyle.position = "horizontal-right";
            else
                visibleItems[i].platformStyle.position = "horizontal-center";
        }
    }
}

function geometry()
{
    if (popup == null || popup.privateRect == null)
      return { "left": 0, "right": 0, "top": 0, "bottom": 0 }; // Return a default empty object

    var bubbleContent = popup.privateRect;
    var rect = {
        "left": bubbleContent.x,
        "right": bubbleContent.x + bubbleContent.width,
        "top": bubbleContent.y,
        "bottom": bubbleContent.y + bubbleContent.height
    };

    return rect;
}

function hasPastingText()
{
    return (popup !== null && popup.privateRect.pastingText);
}

function clearPastingText()
{
    if (popup !== null && popup.privateRect.pastingText) {
        popup.privateRect.pastingText = false;
    }
}

function findWindowRoot(item) {
    var root = findRootItem(item, "windowRoot");
    if (root && root.objectName !== "windowRoot")
        root = findRootItem(item, "pageStackWindow");
    return root;
}

function setPastingText(value) {
    if (popup !== null) {
        popup.privateRect.pastingText = value;
    }
}
