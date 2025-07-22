import QtQuick 2.1
import "UIConstants.js" as UI

Row{
    id: row

    property bool __expanding: true // Layout hint used but ToolBarLayout

    width: Math.min(parent.width, childrenRect.width)
    spacing: UI.PADDING_LARGE
    anchors.verticalCenter: parent.verticalCenter
}

