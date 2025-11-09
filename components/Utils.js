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

/*
  Get the first flickable in hierarchy.
*/
function findFlickable(item)
{
    var next = item;

    while (next) {
        if (next.flicking !== undefined && next.flickableDirection !== undefined)
            return next;

        next = next.parent;
    }

    return null;
}

/*
  Get the root item given an element and root item's name.
  If root item name is not given, default is 'windowContent'.
*/
function findRootItem(item, objectName)
{
    var next = item;

    var rootItemName = "windowContent";
    if (typeof(objectName) != 'undefined') {
        rootItemName = objectName;
        console.log("objectName found from first step! : ", objectName)
    }

    if (next) {
        while (next.parent) {
            next = next.parent;

            if (rootItemName === next.objectName) {
                console.log("objectName found from second step! : ", objectName)
                break;
            }
        }
    }

    return next;
}

/*
  Finds an item in the hierarchy by its objectName, starting from 'item' and going up.
*/
function findItemInHierarchy(item, objectName)
{
    var next = item;
    if (next) {
        while (next.parent) {
            next = next.parent;
            if (objectName === next.objectName) {
                return next;
            }
        }
    }
    return null;
}

/*
  Get the root item for Notification banner
  It will return 'appWindowContent' or 'windowContent' element if found.
*/
function findRootItemNotificationBanner(item)
{
    var next = item;

    if (next) {
        while (next.parent) {
            if (next.objectName === "appWindowContent")
                break;

            if (next.objectName === "windowContent")
                break;

            next = next.parent;
        }
    }

    return next;
}

/*
  Get the main application window (PageStackWindow with objectName "pageStackWindow").
  This is the most stable parent for global popups like EditBubble and SelectionHandles.
*/
function findMainApplicationWindow(item)
{
    // Strategy 1: Traverse up from the provided item to find "pageStackWindow"
    var root = findItemInHierarchy(item, "pageStackWindow");
    if (root && root.objectName === "pageStackWindow") {
        console.log("Utils.js: Found main application window 'pageStackWindow' by traversing up from provided item.");
        return root;
    }

    // Strategy 2: Check Qt.application.activeWindow
    if (Qt.application && Qt.application.activeWindow) {
        if (Qt.application.activeWindow.objectName === "pageStackWindow") {
            console.log("Utils.js: Found main application window 'pageStackWindow' via Qt.application.activeWindow.");
            return Qt.application.activeWindow;
        }
        // Also check its children if the PageStackWindow might be a child of activeWindow
        for (var i = 0; i < Qt.application.activeWindow.children.length; ++i) {
            if (Qt.application.activeWindow.children[i].objectName === "pageStackWindow") {
                console.log("Utils.js: Found main application window 'pageStackWindow' as child of activeWindow.");
                return Qt.application.activeWindow.children[i];
            }
        }
    }

    // Strategy 3: Check Qt.application.topLevelItems
    if (Qt.application && Qt.application.topLevelItems) {
        for (var j = 0; j < Qt.application.topLevelItems.length; ++j) {
            if (Qt.application.topLevelItems[j].objectName === "pageStackWindow") {
                console.log("Utils.js: Found main application window 'pageStackWindow' via Qt.application.topLevelItems.");
                return Qt.application.topLevelItems[j];
            }
        }
    }

    console.warn("Utils.js: Failed to find the main application window with objectName 'pageStackWindow'. This may cause issues with popup initialization.");
    return null;
}




/*
  Get the height that is actually covered by the statusbar (0 if the statusbar is not shown.
*/
function toolBarCoveredHeight(item) {
    var pageStackWindow = findItemInHierarchy(item, "pageStackWindow"); // Changed to use findItemInHierarchy
    if ( pageStackWindow && pageStackWindow.objectName === "pageStackWindow" && pageStackWindow.showToolBar) // Added null check
        return pageStackWindow.platformToolBarHeight
    return 0
}

function intersects(rect1, rect2) {
    return (rect1.left <= rect2.right && rect2.left <= rect1.right &&
            rect1.top <= rect2.bottom && rect2.top <= rect1.bottom)
}
