.pragma library

Qt.include("Utils.js");
Qt.include("UIConstants.js");

var popup = null;
var textInput = null; // Store the textInput associated with the opened bubble
var isChangingInput = false; // Flag to prevent closing the bubble during text changes
var pastingText = false; // Flag to indicate if text is being pasted

function init(item)
{
    if (popup != null)
        return true;

    // --- CHANGE START ---
    // Explicitly find the main application window (PageStackWindow with objectName "pageStackWindow")
    // This ensures the popup is created as a child of the main application window.
    var root = findMainApplicationWindow(item);
    if (!root) {
        console.error("EditBubble.js: Failed to find main application window. Cannot initialize EditBubble.");
        return false;
    }
    // --- CHANGE END ---

    // create root popup
    var component = Qt.createComponent("EditBubble.qml");

    if (component.status === Component.Ready) {
        popup = component.createObject(root); // Create popup as child of the found root window
        if (popup) {
            popup.visible = false; // Initially hidden
            popup.z = 100; // Ensure it's on top of other elements, below magnifier (if present)
            console.log("EditBubble.js: Dynamically created and initialized 'popup'.");
            return true;
        } else {
            console.error("EditBubble.js: Failed to create object from EditBubble.qml component.");
            return false;
        }
    } else if (component.status === Component.Error) {
        console.error("EditBubble.js: Error loading EditBubble.qml component: " + component.errorString());
        return false;
    } else {
        console.warn("EditBubble.js: EditBubble.qml component not yet ready (status: " + component.status + "). Initialization deferred.");
        // This case should ideally not happen if called from Component.onCompleted,
        // but keep for robustness if component itself has async loading.
        return false;
    }
}

/*
  Open a shared edit bubble for a given input item.
  The 'pos' is the mapped center point of the cursor/selection.
*/
function open(input, pos)
{
    if (!input || !pos) {
        console.warn("EditBubble.js: open called with invalid input or position.");
        return false;
    }

    // Ensure popup is initialized before trying to use it
    if (popup === null && !init(input)) {
        console.warn("EditBubble.js: Popup not initialized, cannot open.");
        return false;
    }

    if (popup.active) {
        // If already open for the same input, just update position.
        if (textInput === input) {
            updatePosition(pos);
            return true;
        }
        // If open for a different input, close it first.
        close(textInput);
    }

    textInput = input;
    popup.textInput = input; // Set the textInput property in the QML component
    popup.active = true;
    popup.visible = true; // Make it visible
    updatePosition(pos); // Set initial position

    console.log("EditBubble.js: Edit bubble opened for input:", input.objectName || input.id);
    return true;
}

/*
  Close the shared edit bubble for a given input item.
*/
function close(input)
{
    if (!popup || !input || textInput !== input) {
        return false;
    }

    if (isChangingInput) {
        // If text input is in progress, do not close the bubble.
        return false;
    }

    if (!popup.active) {
        return false;
    }

    popup.active = false;
    popup.visible = false; // Hide it
    popup.textInput = null;
    textInput = null;
    pastingText = false; // Reset pasting flag on close
    console.log("EditBubble.js: Edit bubble closed.");
    return true;
}

/*
  Check if the shared edit bubble is opened for the given input item.
*/
function isOpened(input)
{
    return (popup && popup.active && textInput === input);
}

/*
  Update the position of the edit bubble.
*/
function updatePosition(pos) {
    if (popup === null) {
        console.warn("EditBubble.js: adjustPosition called with invalid bubble or textInput.");
        return;
    }
    // Set the position of the QML popup item
    // The QML component should handle its own anchoring/positioning relative to this point
    popup.x = pos.x - popup.width / 2; // Center horizontally
    popup.y = pos.y - popup.height - UI.MARGIN_XLARGE; // Position above the cursor/selection
    console.log("EditBubble.js: Updated bubble position to x:", popup.x, "y:", popup.y);
}

/*
  Returns the geometry of the popup as a rectangle.
  Used for hit testing, e.g., in InverseMouseArea.
*/
function geometry() {
    if (popup === null) {
        return {left: 0, right: 0, top: 0, bottom: 0};
    }
    // Return the global coordinates of the popup
    // Assuming popup has x, y, width, height properties.
    return {
        left: popup.x,
        right: popup.x + popup.width,
        top: popup.y,
        bottom: popup.y + popup.height
    };
}

/*
  Set flag to indicate if text input is currently changing.
*/
function setChangingInput(changing) {
    isChangingInput = changing;
}

/*
  Check if text input is currently changing.
*/
function isChangingInput() {
    return isChangingInput;
}

/*
  Set flag to indicate if text is being pasted.
*/
function setPastingText(pasting) {
    pastingText = pasting;
}

/*
  Check if text is being pasted.
*/
function hasPastingText() {
    return pastingText;
}
