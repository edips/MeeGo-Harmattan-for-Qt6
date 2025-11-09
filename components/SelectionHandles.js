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

.pragma library
.import "Utils.js" as Utils
Qt.include("UIConstants.js")

var popup = null;

function init(item) {
    if (popup !== null)
        return true;

    var root = Utils.findRootItem(item);
    var component = Qt.createComponent("SelectionHandles.qml");

    if (!component)
        return false;

    // Component.Error == 3
    if (component.status === 3) {
        console.error("Failed to load SelectionHandles.qml:", component.errorString());
        return false;
    }

    popup = component.createObject(root);

    if (!popup) {
        console.error("Failed to create SelectionHandles object");
        return false;
    }

    console.log("SelectionHandles: created successfully");
    return true;
}

function open(input) {
    if (!input)
        return false;

    if (!init(input))
        return false;

    popup.textInput = input;
    popup.state = "opened";

    return popup.textInput !== null;
}

function close(input) {
    if (!popup || !input || popup.textInput !== input)
        return false;

    if (popup.privateIgnoreClose)
        return false;

    return closePopup(popup);
}

function isOpened(input) {
    return popup && popup.textInput === input;
}

function closePopup(selectionArea) {
    if (!selectionArea || !selectionArea.textInput)
        return false;

    selectionArea.state = "closed";
    selectionArea.textInput = null;
    return true;
}

// --- Geometry helpers ---

function leftHandleContains(hitPoint) {
    if (!popup || !popup.leftSelectionHandle)
        return false;

    var h = popup.leftSelectionHandle;
    return (hitPoint.x > h.x &&
            hitPoint.x < h.x + h.width &&
            hitPoint.y > h.y &&
            hitPoint.y < h.y + h.height);
}

function leftHandleRect() {
    if (!popup || !popup.leftSelectionHandle)
        return null;

    var h = popup.leftSelectionHandle;
    return {
        left:   h.x,
        right:  h.x + h.width,
        top:    h.y,
        bottom: h.y + h.height
    };
}

function rightHandleContains(hitPoint) {
    if (!popup || !popup.rightSelectionHandle)
        return false;

    var h = popup.rightSelectionHandle;
    return (hitPoint.x > h.x &&
            hitPoint.x < h.x + h.width &&
            hitPoint.y > h.y &&
            hitPoint.y < h.y + h.height);
}

function rightHandleRect() {
    if (!popup || !popup.rightSelectionHandle)
        return null;

    var h = popup.rightSelectionHandle;
    return {
        left:   h.x,
        right:  h.x + h.width,
        top:    h.y,
        bottom: h.y + h.height
    };
}

// --- Adjust handles position ---
function adjustPosition(handles) {
    if (handles === undefined)
        handles = popup;

    if (!handles || !handles.textInput)
        return;

    var input = handles.textInput;
    var rect = handles.privateRect;
    var viewport = rect ? rect.parent : null;

    if (!viewport || !input)
        return;

    var selectionStartRect = input.positionToRectangle(input.selectionStart);
    var selectionEndRect   = input.positionToRectangle(input.selectionEnd);

    handles.selectionStartPoint = viewport.mapFromItem(input, selectionStartRect.x, selectionStartRect.y);
    handles.selectionEndPoint   = viewport.mapFromItem(input, selectionEndRect.x, selectionEndRect.y);
}

// --- Intersections ---
function handlesIntersectWith(rect) {
    if (!rect)
        return false;

    return (Utils.intersects(rect, leftHandleRect()) ||
            Utils.intersects(rect, rightHandleRect()));
}
