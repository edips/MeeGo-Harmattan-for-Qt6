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

/// Helper code that is needed by ToolBarLayout.

var connectedItems = [];

// Find item in an array
function contains(container, obj) {
  for (var i = 0 ; i < container.length; i++) {
    if (container[i] === obj)
        return true;
  }
  return false
}

// Remove item from an array
function remove(container, obj)
{
    for (var i = 0 ; i < container.length ; i++ )
        if (container[i] === obj)
            container.splice(i,1);
}

// Helper function to give us the sender id on slots
// This is needed to remove connectens on a reparent
Function.prototype.bind = function() {
    var func = this;
    var thisObject = arguments;
    var args = Array.prototype.slice.call(arguments, 1);
    return function() {
        return func.apply(thisObject, args);
    }
}

// Called whenever a child is added or removed in the toolbar
function childrenChanged() {
    for (var i = 0; i < toolbarLayout.children.length; i++) {
        if (!contains(connectedItems, toolbarLayout.children[i])) {
            var child = toolbarLayout.children[i];
            connectedItems.push(child);
            child.visibleChanged.connect(function() { Qt.callLater(layout); });
            child.heightChanged.connect(function() { Qt.callLater(layout); });
            child.parentChanged.connect(cleanup.bind(child));
        }
    }
    Qt.callLater(layout);
}

// Disconnects signals connected by this layout
function cleanup() {
    var child = this;
    remove(connectedItems, child);
    child.visibleChanged.disconnect(layout);
    child.heightChanged.disconnect(layout);
    child.parentChanged.disconnect(arguments.callee);
    Qt.callLater(layout);
}

// Main layout function
function layout() {
    if (toolbarLayout.parent === null || toolbarLayout.width === 0 || toolbarLayout.children === undefined)
        return;

    var i;
    var items = [];
    var expandingItems = [];
    var nonExpandingItems = [];
    var widthOthers = 0;
    var width = toolbarLayout.width;

    for (i = 0; i < toolbarLayout.children.length; i++) {
        var child = toolbarLayout.children[i];
        if (child.visible) {
            items.push(child);
            if (child.__expanding) {
                expandingItems.push(child);
            } else {
                nonExpandingItems.push(child);
                widthOthers += child.width;
            }
        }
    }

    if (items.length === 0) return;

    // Check if non-expanding items alone are too wide
    if (widthOthers > width) {
        var shrinkRatio = width / widthOthers;
        widthOthers = 0;
        for (i = 0; i < nonExpandingItems.length; i++) {
            var item = nonExpandingItems[i];
            item.width *= shrinkRatio;
            widthOthers += item.width;
        }
    }

    // Now, deal with expanding items
    var expandingWidth = 0;
    if (expandingItems.length > 0) {
        var remainingWidth = width - widthOthers;
        expandingWidth = Math.max(0, remainingWidth / expandingItems.length);
        for (i = 0; i < expandingItems.length; i++) {
            expandingItems[i].width = expandingWidth;
        }
    }

    // Final layout with spacing
    var totalItemWidth = widthOthers + (expandingItems.length * expandingWidth);
    var spacing = 0;
    if (items.length > 1 && totalItemWidth < width) {
        spacing = (width - totalItemWidth) / (items.length - 1);
    }

    var currentX = 0;
    for (i = 0; i < items.length; i++) {
        items[i].y = (toolbarLayout.height - items[i].height) / 2;
        items[i].x = currentX;
        currentX += items[i].width + spacing;
    }
}
