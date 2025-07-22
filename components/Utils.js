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
    }

    if (next) {
        while (next.parent) {
            next = next.parent;

            if (rootItemName === next.objectName) {
                break;
            }
        }
    }

    return next;
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
  Get the height that is actually covered by the statusbar (0 if the statusbar is not shown.
*/
function statusBarCoveredHeight(item) {
    var pageStackWindow = findRootItem(item, "pageStackWindow");
    if ( pageStackWindow.objectName === "pageStackWindow" )
        return pageStackWindow.__statusBarHeight;
    return 0
}

/*
  Get the height that is actually covered by the statusbar (0 if the statusbar is not shown.
*/
function toolBarCoveredHeight(item) {
    var pageStackWindow = findRootItem(item, "pageStackWindow");
    if ( pageStackWindow.objectName === "pageStackWindow" && pageStackWindow.showToolBar)
        return pageStackWindow.platformToolBarHeight
    return 0
}

function intersects(rect1, rect2) {
    return (rect1.left <= rect2.right && rect2.left <= rect1.right &&
            rect1.top <= rect2.bottom && rect2.top <= rect1.bottom)
}
