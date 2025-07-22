.pragma library

Qt.include("Utils.js");
Qt.include("UIConstants.js");

var popup = null;

function init(item)
{
    if (popup != null)
        return true;

    // --- CHANGE START ---
    // Explicitly find the root window (PageStackWindow with objectName "rootWindow")
    var root = Utils.findRootWindow(item);
    if (!root) {
        console.error("SelectionHandles.js: Failed to find root window. Cannot initialize SelectionHandles.");
        return false;
    }
    // --- CHANGE END ---

    // create root popup
    var component = Qt.createComponent("SelectionHandles.qml");

    // due the pragma we cannot access Component.Ready
    if (component)
        popup = component.createObject(root); // Create popup as child of the found root window

    return popup != null;
}

/*
  Open a shared edit selectionArea for a given input item.

  All operations and changes will be binded to the
  given item.
*/
function open(input)
{
    if (!input)
        return false;

    if (!init(input))
        return false;

    // need to set before checking capabilities
    popup.textInput = input;

    popup.state = "opened";

    return popup.textInput !== null;
}

/*
  Close the shared edit selectionArea for a given input item.
*/
function close(input)
{
    if (!popup || !input || popup.textInput !== input)
        return false;

    if ( popup.privateIgnoreClose )
        return false;

    return closePopup(popup);
}

/*
  Check if the shared edit selectionArea is opened for the
  given input item.
*/
function isOpened(input)
{
    return (popup && popup.textInput === input);
}

/*
  Close a given selectionArea.
*/
function closePopup(selectionArea)
{
    if (selectionArea === null || selectionArea.textInput === null)
        return false;

    selectionArea.state = "closed";
    selectionArea.textInput = null;
    return true;
}

/*
  Check whether a given point is located inside the area of the left selection handle.
*/
function leftHandleContains( hitPoint )
{
    if (popup == null)
        return;

    if (    hitPoint.x > popup.leftSelectionHandle.pos.x
         && hitPoint.x < popup.leftSelectionHandle.pos.x + popup.leftSelectionHandle.width
         && hitPoint.y > popup.leftSelectionHandle.pos.y
         && hitPoint.y < popup.leftSelectionHandle.pos.y + popup.leftSelectionHandle.height )
         return true;
    return false;
}
/*
  Return the geometry of the left selection handle as a rectangle.
*/
function leftHandleRect()
{
    if (popup == null)
        return;

    var handle = popup.leftSelectionHandle;
    var rect = {"left": handle.pos.x,
        "right": handle.pos.x + handle.width,
        "top": handle.pos.y,
        "bottom": handle.pos.y + handle.height};

    return rect;
}

/*
  Check whether a given point is located inside the area of the right selection handle.
*/
function rightHandleContains( hitPoint )
{
    if (popup == null)
        return;

    if (    hitPoint.x > popup.rightSelectionHandle.pos.x
         && hitPoint.x < popup.rightSelectionHandle.pos.x + popup.rightSelectionHandle.width
         && hitPoint.y > popup.rightSelectionHandle.pos.y
         && hitPoint.y < popup.rightSelectionHandle.pos.y + popup.rightSelectionHandle.height )
         return true;
    return false;
}
/*
  Return the geometry of the right selection handle as a rectangle.
*/
function rightHandleRect()
{
    if (popup == null)
        return;

    var handle = popup.rightSelectionHandle;
    var rect = {"left": handle.pos.x,
        "right": handle.pos.x + handle.width,
        "top": handle.pos.y,
        "bottom": handle.pos.y + handle.height};

    return rect;
}

/*
  Adjust SelectionHandles position to fit into the visible area.
*/
function adjustPosition(handles)
{
    if (handles === undefined)
        handles = popup;

    if (handles === null)
        return;

    if (handles.textInput === null) return;

    var input = handles.textInput;

    var rect = handles.privateRect;
    var viewport = rect.parent;

    if (viewport === null || input === null)
        return;

    var selectionStartRect = input.positionToRectangle( input.selectionStart );
    var selectionEndRect = input.positionToRectangle( input.selectionEnd );

    handles.selectionStartPoint = viewport.mapFromItem( input, selectionStartRect.x, selectionStartRect.y );
    handles.selectionEndPoint = viewport.mapFromItem( input, selectionEndRect.x, selectionEndRect.y )
}

function handlesIntersectWith(rect){
    if ( rect === undefined ) return undefined;
    return ( intersects(rect, leftHandleRect()) || intersects(rect, rightHandleRect()) )
}
