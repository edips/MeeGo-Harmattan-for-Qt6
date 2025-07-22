.pragma library

Qt.include("Utils.js");

var popup = null; // This will now hold the pre-instantiated Magnifier QML object

// Modified init: now receives the already created QML object
function init(qmlMagnifierObject)
{
    if (popup !== null) {
        // Already initialized, or a different object was passed previously.
        if (popup === qmlMagnifierObject) {
            return true;
        } else {
            console.warn("Magnifier.js: Attempted to re-initialize with a different Magnifier object. Ignoring.");
            return false;
        }
    }

    if (qmlMagnifierObject) {
        popup = qmlMagnifierObject;
        popup.__rootElement = findRootItem(qmlMagnifierObject); // Set root element for mapping
        console.log("Magnifier.js: Initialized with pre-instantiated Magnifier QML object.");
        return true;
    } else {
        console.error("Magnifier.js: init received a null QML object.");
        return false;
    }
}

/*
  Open a shared magnifier for a given input item.

  input item will be used as a sourceItem for the shader
  effect
*/
function open(input)
{
    if (!popup) {
        console.error("Magnifier.js: Magnifier not initialized. Call init() first.");
        return false;
    }

    if (!input) {
        console.warn("Magnifier.js: Input item is null.");
        return false;
    }

    popup.sourceItem = input;
    popup.active = true;
    popup.visible = true; // Explicitly make visible
    console.log("Magnifier.js: Magnifier opened successfully.");
    return true;
}

/*
  Check if the shared magnifier is opened
*/
function isOpened()
{
    return (popup && popup.active && popup.visible);
}

/*
  Close the magnifier.
*/
function close()
{
    if (popup && popup.active){
        popup.active = false;
        popup.sourceItem = null;
        popup.visible = false; // Explicitly hide
        console.log("Magnifier.js: Magnifier closed.");
    }
}

/*
  Clean the magnifier by destroying it. This should be done only
  if the application becomes inactive.
*/
function clean()
{
    if (popup){
        popup.active = false;
        popup.sourceItem = null;
        popup.visible = false; // Ensure it's hidden before destruction
        popup.destroy();
        popup = null;
        console.log("Magnifier.js: Magnifier cleaned.");
    }
}
