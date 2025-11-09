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

Qt.include("Utils.js");
Qt.include("UIConstants.js");

var popup = null;

function init(item)
{
    if (popup !== null)
        return true;

    var root = findRootItem(item);

    // create root popup
    var component = Qt.createComponent("EditBubble.qml");

    // due the pragma we cannot access Component.Ready
    if (component)
        popup = component.createObject(root);

    return popup !== null;
}

/*
  Open a shared edit bubble for a given input item.

  All operations and changes will be binded to the
  given item.
*/
function open(input,position)
{
    if (!input)
        return false;

    // don't create an EditBubble when no EditBubble is needed
    var canPaste = !input.readOnly && input.canPaste;
    var textSelected = input.selectedText !== "";
    // Distinguish between TextEdit (in TextArea) and TextInput (in TextField)
    var isTextEdit = input.wrapMode !== undefined;
    var canCopy = false;
    if (isTextEdit) {
        // TextEdit doesn't have echoMode, so copy is always allowed if text is selected.
        canCopy = textSelected;
    } else {
        // For TextInput, check echoMode to prevent copying from password fields.
        canCopy = textSelected && (input.echoMode === undefined || input.echoMode === 0 /* = TextInput.Normal */);
    }
    var canCut = !input.readOnly && canCopy;

    if (!(canPaste || canCopy || canCut || textSelected))
        return false;

    if (!init(input))
        return false;

    console.log("4. EditBubble.js -> open(): Attempting to open popup.");

    // Position when text not selected.
    popup.position = position;

    // need to set before checking capabilities
    popup.textInput = input;

    if (popup.valid) {
        popup.state = "opened";
        popup.privateRect.outOfView = false;
    }
    else
        popup.textInput = null;

    return popup.textInput !== null;
}

/*
  Close the shared edit bubble for a given input item.
*/
function close(input)
{
    if (!popup || !input || popup.textInput !== input)
        return false;

    return closePopup(popup);
}

/*
  Check if the shared edit bubble is opened for the
  given input item.
*/
function isOpened(input)
{
    return (popup && popup.textInput === input);
}

/*
  Check if the bubble is in the middle of a text
  change operation.
*/
function isChangingInput()
{
    return (popup && popup.privateRect.changingText);
}

/*
  Close a given edit bubble.
*/
function closePopup(bubble)
{
    if (bubble === null || bubble.textInput === null)
        return false;

    bubble.state = "closed";
    bubble.textInput = null;
    return true;
}

/*
  Adjust EditBubble position to fit in the visible area.

  If no argument is passed, it will adjust the shared
  bubble position if already initialized.
*/
function adjustPosition(bubble)
{
    console.log("5. EditBubble.js -> adjustPosition(): Recalculating bubble position.");
    if (bubble === undefined)
        bubble = popup;

    if (bubble === null)
        return;

    var input = bubble.textInput;
    var rect = bubble.privateRect;
    var viewport = rect.parent;

    if (viewport === null || input === null)
        return;

    var irect = input.positionToRectangle(input.selectionStart);
    var frect = input.positionToRectangle(input.selectionEnd);
    var mid = rect.width / 2;

    if (input.selectionStart === input.selectionEnd) {
        irect.x = popup.position.x;
        irect.y = popup.position.y;
        frect.x = popup.position.x;
        frect.y = popup.position.y;
   }

    var ipoint = viewport.mapFromItem(input, irect.x, irect.y);
    var fpoint = viewport.mapFromItem(input, frect.x, frect.y);

    var px = ipoint.x + (fpoint.x - ipoint.x) / 2 - mid;
    var py = ipoint.y - rect.height;

    var SHADOW_SIZE = 6

    rect.x = Math.min(Math.max(px, MARGIN_XLARGE - SHADOW_SIZE), viewport.width - rect.width);

    if (py > SHADOW_SIZE ) {
        rect.y = py - SHADOW_SIZE;
        rect.arrowDown = true;
    } else {
        if (rect.positionOffset === 0) {
            rect.y = Math.min(Math.max(ipoint.y + irect.height, 0),
                              fpoint.y + frect.height);
        }
        else {
            rect.y = Math.max(ipoint.y + irect.height, fpoint.y + frect.height) + rect.positionOffset;
        }
        rect.arrowDown = false;
    }

    var boundX = mid - rect.arrowBorder;
    rect.arrowOffset = Math.min(Math.max(-boundX, px - rect.x), boundX);
}
function enableOffset(enabled){
    if (popup === null)
        return;
    popup.privateRect.positionOffset = enabled ? 40 : 0;
}

function offsetEnabled(){
    if (popup == null)
        return false;
    return popup.privateRect.positionOffset !== 0;
}

function updateButtons(row)
{
    var children = row.children;
    var visibleItems = [];

    for (var i = 0, j = 0; i < children.length; i++) {
        var child = children[i];

        if (child.visible)
            visibleItems[j++] = child;
    }

    for (var i = 0; i < visibleItems.length; i++) {
        if (visibleItems.length === 1)
            visibleItems[i].platformStyle.position = "";
        else {
            if (i == 0)
                visibleItems[i].platformStyle.position = "horizontal-left";
            else if (i === visibleItems.length - 1)
                visibleItems[i].platformStyle.position = "horizontal-right";
            else
                visibleItems[i].platformStyle.position = "horizontal-center";
        }
    }
}

/*
  Return the geometry of the edit bubble as a rectangle.
  Returns undefined if the popup or its privateRect is not ready.
*/
function geometry() {
    if (!popup || !popup.privateRect)
        return null;

    var r = popup.privateRect;
    var x = r.x, y = r.y, w = r.width, h = r.height;

    var rect = {
        left:   x,
        right:  x + w,
        top:    y,
        bottom: y + h
    };

    console.log("geometry:", rect.left, rect.top, rect.right, rect.bottom);
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

