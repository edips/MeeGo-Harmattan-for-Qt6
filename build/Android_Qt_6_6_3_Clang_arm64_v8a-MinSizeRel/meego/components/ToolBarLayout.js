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
    var thisObject = arguments[0];
    var args = Array.prototype.slice.call(arguments, 1);
    return function() {
        return func.apply(thisObject, args);
    }
}

// Called whenever a child is added or removed in the toolbar
function childrenChanged() {
    for (var i = 0; i < children.length; i++) {
        if (!contains(connectedItems, children[i])) {
            connectedItems.push(children[i]);
            children[i].visibleChanged.connect(layout);
            children[i].parentChanged.connect(cleanup.bind(children[i]));
        }
    }
}

// Disconnects signals connected by this layout
function cleanup() {
    remove(connectedItems, this);
    this.visibleChanged.disconnect(layout);
    this.parentChanged.disconnect(arguments.callee);
}



function layout() {
    if (parent === null || width === 0)
        return;

    const items = [];           // Visible items
    const expandingItems = []; // Expanding tab items
    let widthOthers = 0;

    // Collect visible items, center vertically, and identify expanding items
    for (let j = 0; j < children.length; j++) {
        const child = children[j];
        if (!child.visible)
            continue;

        items.push(child);
        child.y = height / 2 - child.height / 2;

        if (child.__expanding) {
            expandingItems.push(child);
        } else {
            widthOthers += child.width;
        }
    }

    if (items.length === 0)
        return;

    // Optional paddings (e.g. for landscape adjustment)
    let leftPadding = 0;
    let rightPadding = 0;

    // Adjust left/right padding if in landscape mode with 2 items
    if (items.length === 2 && screen.currentOrientation === Screen.Landscape) {
        const first = items[0];
        const last = items[1];

        if (first.__expanding && !last.__expanding)
            leftPadding += last.width;

        if (last.__expanding && !first.__expanding)
            rightPadding += first.width;
    }

    const availableWidth = toolbarLayout.width - leftPadding - rightPadding;

    // Allocate space for expanding items
    const expandingWidth = (availableWidth - widthOthers) / expandingItems.length;
    for (let k = 0; k < expandingItems.length; k++) {
        expandingItems[k].width = expandingWidth;
    }

    // Determine remaining space and spacing
    const firstItem = items[0];
    const lastItem = items[items.length - 1];
    const toolBoxWidth = availableWidth - (firstItem ? firstItem.width : 0) - (lastItem ? lastItem.width : 0);

    let spacingBetween = toolBoxWidth;
    for (let h = 1; h < items.length - 1; h++) {
        spacingBetween -= items[h].width;
    }

    // Prevent divide-by-zero
    spacingBetween /= (items.length > 1) ? (items.length - 1) : 1;

    // Position items
    firstItem.x = leftPadding;
    let currentX = firstItem.width + spacingBetween;

    for (let i = 1; i < items.length; i++) {
        items[i].x = currentX + leftPadding;
        currentX += items[i].width + spacingBetween;
    }
}





// Main layout function
/*
function layout() {

    if (parent === null || width === 0)
        return;

    var i;
    var items = new Array();          // Keep track of visible items
    var expandingItems = new Array(); // Keep track of expandingItems for tabs
    var widthOthers = 0;

    for (i = 0; i < children.length; i++) {
        if (children[i].visible) {
            items.push(children[i])

            // Center all items vertically
            items[0].y = (function() {return height / 2 - items[0].height / 2})
            // Find out which items are expanding
            if (children[i].__expanding) {
                expandingItems.push(children[i])
            } else {
                // Calculate the space that fixed size items take
                widthOthers += children[i].width;
            }
        }
    }

    if (items.length === 0)
        return;

    // Extra padding is applied if the leftMost or rightmost widget is expanding (note** removed on new design)
    var leftPadding = 0
    var rightPadding = 0 

    // In LandScape mode we add extra margin to keep contents centered
    // for two basic cases
    if (items.length == 2 && screen.currentOrientation == Screen.Landscape) {
        // expanding item on left
        if (expandingItems.length > 0 && items[0].__expanding && !items[items.length-1].__expanding)
            leftPadding += items[items.length-1].width

        // expanding item is on right
        if (expandingItems.length > 0 && items[items.length-1].__expanding && !items[0].__expanding)
            rightPadding += items[0].width
    }

    var width = toolbarLayout.width - leftPadding - rightPadding

    // Calc expandingItems and tabrows
    for (i = 0; i < expandingItems.length; i++)
        expandingItems[i].width = (width - widthOthers) / expandingItems.length

    var lastItem = items[items.length-1] ? items[items.length-1] : undefined;

    // Space to be divided between first and last items
    var toolBox = width - (items[0] ? items[0].width : 0) -
        (lastItem ? lastItem.width : 0);

    // |X  X  X| etc.
    var spacingBetween = toolBox;
    for (i = 1; i < items.length - 1; i++)
        spacingBetween -= items[i].width;
    items[0].x = leftPadding

    // Calculate spacing between items
    spacingBetween /= items.length - 1;

    // Starting after first item
    var dX = items[0].width + spacingBetween;
    for (i = 1; i < items.length; i++) {
        items[i].x = dX + leftPadding;
        dX += spacingBetween + items[i].width;
    }
}
*/
