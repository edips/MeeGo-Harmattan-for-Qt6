// Page stack. Items are page containers.
var pageStack = [];

// Page component cache map. Key is page url, value is page component.
var componentCache = {};

// Returns the page stack depth.
function getDepth() {
    return pageStack.length;
}
function openSheet(sheet, properties) {
    var sheetComp;
    if (sheet.createObject) {
        // sheet defined as component
        sheetComp = sheet;
    } else if (typeof sheet == "string") {
        // sheet defined as string (a url)
        sheetComp = componentCache[sheet];
        if (!sheetComp) {
            sheetComp = componentCache[sheet] = Qt.createComponent(sheet);
        }
    }
    if (sheetComp) {
        if (sheetComp.status === Component.Error) {
            throw new Error("Error while loading sheet: " + sheetComp.errorString());
        } else {
            // instantiate sheet from component
            sheet = sheetComp.createObject(root, properties || {});
        }

        // if we instantiate the sheet, we must clean it up
        sheet.statusChanged.connect(function() {
            if (sheet.status === DialogStatus.Closed)
                sheet.destroy()
        })
    } else {
        // copy properties to the page
        for (var prop in properties) {
            if (properties.hasOwnProperty(prop)) {
                sheet[prop] = properties[prop];
            }
        }
    }

    sheet.open()
    return sheet
}
// Pushes a page on the stack.
function push(page, properties, replace, immediate) {
    // page order sanity check
    if ((!replace && page === currentPage) ||
            (replace && pageStack.length > 1 && page === pageStack[pageStack.length - 2].page)) {
        throw new Error("Cannot navigate so that the resulting page stack has two consecutive entries of the same page instance.");
    }

    // figure out if more than one page is being pushed
    var pages;
    if (page instanceof Array) {
        pages = page;
        page = pages.pop();
        if (page.createObject === undefined && page.parent === undefined && typeof page != "string") {
            properties = properties || page.properties;
            page = page.page;
        }
    }

    // get the current container
    var oldContainer = pageStack[pageStack.length - 1];

    // pop the old container off the stack if this is a replace
    if (oldContainer && replace) {
        pageStack.pop();
    }

    // push any extra defined pages onto the stack
    if (pages) {
        var i;
        for (i = 0; i < pages.length; i++) {
            var tPage = pages[i];
            var tProps;
            if (tPage.createObject === undefined && tPage.parent === undefined && typeof tPage != "string") {
                tProps = tPage.properties;
                tPage = tPage.page;
            }
            pageStack.push(initPage(tPage, tProps));
        }
    }

    // initialize the page
    var container = initPage(page, properties);

    // push the page container onto the stack
    pageStack.push(container);

    depth = pageStack.length;
    currentPage = container.page;

    // perform page transition
    immediate = immediate || !oldContainer;
    if (oldContainer) {
        oldContainer.pushExit(replace, immediate);
    }
    container.pushEnter(replace, immediate);

    // sync tool bar
    var tools = container.page.tools || null;
    if (toolBar) {
        toolBar.setTools(tools, immediate ? "set" : replace ? "replace" : "push");
    }

    return container.page;
}

// Initializes a page and its container.
function initPage(page, properties) {
    var container = containerComponent.createObject(root);

    var pageComp;
    if (page.createObject) {
        // page defined as component
        pageComp = page;
    } else if (typeof page == "string") {
        // page defined as string (a url)
        pageComp = componentCache[page];
        if (!pageComp) {
            pageComp = componentCache[page] = Qt.createComponent(page);
        }
    }
    if (pageComp) {
        if (pageComp.status === Component.Error) {
            throw new Error("Error while loading page: " + pageComp.errorString());
        } else {
            // instantiate page from component
            page = pageComp.createObject(container, properties || {});
        }
    } else {
        // copy properties to the page
        for (var prop in properties) {
            if (properties.hasOwnProperty(prop)) {
                page[prop] = properties[prop];
            }
        }
    }

    container.page = page;
    container.owner = page.parent;

    // the page has to be reparented if
    if (page.parent !== container) {
        page.parent = container;
    }

    if (page.pageStack !== undefined) {
        page.pageStack = root;
    }

    return container;
}

// Pops a page off the stack.
function pop(page, immediate) {
    // make sure there are enough pages in the stack to pop
    if (pageStack.length > 1) {
        // pop the current container off the stack and get the next container
        var oldContainer = pageStack.pop();
        var container = pageStack[pageStack.length - 1];
        if (page !== undefined) {
            // an unwind target has been specified - pop until we find it
            while (page !== container.page && pageStack.length > 1) {
                container.cleanup();
                pageStack.pop();
                container = pageStack[pageStack.length - 1];
            }
        }

        depth = pageStack.length;
        currentPage = container.page;

        // perform page transition
        oldContainer.popExit(immediate);
        container.popEnter(immediate);

        // sync tool bar
        var tools = container.page.tools || null;
        if (toolBar) {
            toolBar.setTools(tools, immediate ? "set" : "pop");
        }

        return oldContainer.page;
    } else {
        return null;
    }
}

// Clears the page stack.
function clear() {
    var container;
    while (container === pageStack.pop()) {
        container.cleanup();
    }
    depth = 0;
    currentPage = null;
}

// Iterates through all pages in the stack (top to bottom) to find a page.
function find(func) {
    for (var i = pageStack.length - 1; i >= 0; i--) {
        var page = pageStack[i].page;
        if (func(page)) {
            return page;
        }
    }
    return null;
}

