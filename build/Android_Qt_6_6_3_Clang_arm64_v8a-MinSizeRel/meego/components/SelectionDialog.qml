import QtQuick
import com.meego.components 1.0
import "."
import "UIConstants.js" as UI

CommonDialog {
    id: root
    visible: status === DialogStatus.Open || status === DialogStatus.Opening
    function accept() {
            root.close()
            root.accepted()
    }
    // Common API
    //property ListModel model: ListModel{}
    property alias model: selectionListView.model
    property int deselectedIndex: -1   // read & write
    property int selectedIndex: -1   // read & write
    //property string titleText: "Selection Dialog"

    property Component delegate:          // Note that this is the default delegate for the list
        Component {
            id: defaultDelegate

            Item {
                id: delegateItem
                property bool selected: index == selectedIndex;

                height: root.platformStyle.itemHeight
                anchors.left: parent.left
                anchors.right: parent.right

                // Legacy. "name" used to be the role which was used by delegate
                // "modelData" available for JS array and for models with one role
                // C++ models have "display" role available always
                function __setItemText() {
                    try {
                        itemText.text = name
                    } catch(err) {
                        try {
                            itemText.text = modelData
                        } catch (err) {
                            itemText.text = display
                        }
                    }
                }

                MouseArea {
                    id: delegateMouseArea
                    anchors.fill: parent
                    enabled: root.status === DialogStatus.Open

                    onPressed: {
                        deselectedIndex = selectedIndex;
                        selectedIndex = index;
                    }
                    onClicked: root.accept()
                }


                Rectangle {
                    id: backgroundRect
                    anchors.fill: parent
                    color: delegateItem.selected ? root.platformStyle.itemSelectedBackgroundColor : root.platformStyle.itemBackgroundColor
                }

                BorderImage {
                    id: background
                    anchors.fill: parent
                    border { left: UI.CORNER_MARGINS; top: UI.CORNER_MARGINS; right: UI.CORNER_MARGINS; bottom: UI.CORNER_MARGINS }
                    source: delegateMouseArea.pressed ? root.platformStyle.itemPressedBackground :
                            delegateItem.selected ? root.platformStyle.itemSelectedBackground :
                            root.platformStyle.itemBackground
                }

                Text {
                    id: itemText
                    elide: Text.ElideRight
                    color: delegateItem.selected ? root.platformStyle.itemSelectedTextColor : root.platformStyle.itemTextColor
                    anchors.verticalCenter: delegateItem.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: root.platformStyle.itemLeftMargin
                    anchors.rightMargin: root.platformStyle.itemRightMargin
                    text: modelData
                    font: root.platformStyle.itemFont
                }


                Component.onCompleted: __setItemText()
            }
        }

    onStatusChanged: {
      if (status === DialogStatus.Opening && selectedIndex >= 0) {
          selectionListView.positionViewAtIndex(selectedIndex, ListView.Center)
      }
    }

    // Style API
    property Style platformStyle: SelectionDialogStyle {}

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    // private api
    property int __pressDelay: platformStyle.pressDelay

    // the title field consists of the following parts: title string and
    // a close button (which is in fact an image)
    // it can additionally have an icon
    titleText:"Selection Dialog"

    // the content field which contains the selection content
    content: Item {

        id: selectionContent
        property int listViewHeight
        property int maxListViewHeight : visualParent
        ? visualParent.height * 0.87
                - root.platformStyle.titleBarHeight - root.platformStyle.contentSpacing - parseInt(50 * ScaleFactor)
        : root.parent
                ? root.parent.height * 0.87
                        - root.platformStyle.titleBarHeight - root.platformStyle.contentSpacing - parseInt(50 * ScaleFactor)
                : parseInt(350 * ScaleFactor)
        height: listViewHeight > maxListViewHeight ? maxListViewHeight : listViewHeight
        width: root.width
        y : root.platformStyle.contentSpacing

        ListView {
            id: selectionListView
            model: ListModel {}

            currentIndex : -1
            anchors.fill: parent
            delegate: root.delegate
            focus: true
            clip: true
            pressDelay: __pressDelay

            ScrollDecorator {
                id: scrollDecorator
                flickableItem: selectionListView
                platformStyle.inverted: true
            }
            onCountChanged: selectionContent.listViewHeight = selectionListView.count * platformStyle.itemHeight
            onModelChanged: selectionContent.listViewHeight = selectionListView.count * platformStyle.itemHeight
        }

    }
}


