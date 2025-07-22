// ToolBarLayout is a container for items on a toolbar that automatically
// implements an appropriate layout for its children.

import QtQuick
import "."
import "UIConstants.js" as UI
import "ToolBarLayout.js" as Layout

Item {
    id: toolbarLayout

    width: visible && parent ? parent.width : 0
    height: visible && parent ? parent.height : 0

    onWidthChanged: Layout.layout()
    onHeightChanged: Layout.layout()
    onChildrenChanged: Layout.childrenChanged()
    Component.onCompleted: Layout.layout()
}
