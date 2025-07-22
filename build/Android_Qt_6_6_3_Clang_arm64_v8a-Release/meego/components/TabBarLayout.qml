import QtQuick
import "."

Item {
    id: root
    width: visible && parent ? parent.width : 0
    height: visible && parent ? parent.height : 0
    
    Component.onCompleted: {
        __layout()
        print("Warning, TabBarLayout has been deprecated from the API.")
        print("To fix your code, please use:")
        print("    tools: ToolBarLayout { ToolItem{} ButtonRow{TabButton{} ... } } instead.")
    }
    onChildrenChanged: __layout()
    onWidthChanged: __layout()
    onHeightChanged: __layout()
    
    function __layout() {
        if (parent == null || width == 0)
            return;

        var orientation = screen.currentOrientation === Screen.Landscape || screen.currentOrientation === Screen.LandscapeInverted ? "landscape" : "portrait",
            padding = orientation === "landscape" ? 80 : 15;

        for (var i = 0, childCount = children.length, tabCount = 0, widthOthers = 0; i < childCount; i++) {
            if (children[i].tab !== undefined) {
                children[i].platformStyle.position = (tabCount++ === 0) ? "horizontal-left" : "horizontal-center";
                children[i].platformStyle.screenOrientation = orientation;
            } else {
                widthOthers += children[i].width;
                children[i].y = (height - children[i].height) / 2;
            }
        }
        // Check if last item is a tab button and set appropriate position
        tabCount && (children[children[0].tab ? tabCount - 1 : tabCount].platformStyle.position = "horizontal-right");

        widthOthers += children[0].tab ? padding : 0;
        widthOthers += children[childCount - 1].tab ? padding : 0;

        var tabWidth = Math.round((width - widthOthers) / tabCount),
            offset = children[0].tab ? padding : children[0].width;

        for (var i = children[0].tab ? 0 : 1, index = 0; i < childCount; i++, index++) {
            children[i].x = tabWidth * index + offset;
            children[i].tab && (children[i].width = tabWidth);
        }
    }
}

