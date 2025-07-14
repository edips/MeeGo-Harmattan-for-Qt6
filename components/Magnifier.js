.pragma library

Qt.include("Utils.js");

var popup = null;

function init(item)
{
    if (popup != null)
        return true;

    var root = findRootItem(item);

    // create root popup
    var component = Qt.createComponent("Magnifier.qml");

    // due the pragma we cannot access Component.Ready
    if (component)
        popup = component.createObject(root);

    if (popup)
        popup.__rootElement = root;

    return popup != null;
}

/*
  Open a shared magnifier for a given input item.

  input item will be used as a sourceItem for the shader
  effect
*/
function open(input)
{
    if (!input)
        return false;

    if (!init(input))
        return false;

    popup.sourceItem = input;
    popup.active = true;
    return true;
}

/*
  Check if the shared magnifier is opened
*/
function isOpened()
{
    return (popup && popup.active);
}

/*
  Close the magnifier.
*/
function close()
{
    if (popup && popup.active){
        popup.active = false;
        popup.sourceItem = null;
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
        popup.destroy();
        popup = null;
    }
}

