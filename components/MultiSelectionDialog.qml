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

import QtQuick
import meego
import com.meego.components 1.0
import "UIConstants.js" as UI
import "MultiSelectionDialog.js" as MultiSelectionDialog

CommonDialog {
    id: root
    // Close the dialog with back button
    Connections {
        target: GlobalSettings
        function onDialogFocusChanged(dialogFocus) {
            close()
        }
    }
    // Set the width of the dialog to fill its parent
    width: parent.width

    property alias model: selectionListView.model
    // Common API: property list<int> selectedIndexes (currently not possible due to QTBUG-10822)
    property variant selectedIndexes: []    // read & write, variant is supposed to be list<int>
    property alias acceptButtonText: acceptButton.text      //Convenience wrapper on top of the buttons
    property alias rejectButtonText: rejectButton.text      //Convenience wrapper on top of the buttons
    //property alias titleText: titleLabel.text

    property Component delegate:            // Note that this is the default delegate for the list
        Component {
            id: defaultDelegate

            Item {
                id: delegateItem

                height: root.platformStyle.itemHeight
                // Changed from anchors.left/right to width: parent.width for robustness in delegates
                // Further refined to use selectionListView.width for more stable binding
                width: selectionListView.width // Explicitly bind to the ListView's width

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
                    anchors.fill: parent;
                    onPressed: MultiSelectionDialog.__toggleIndex(index);
                }

                Rectangle {
                    id: backgroundRect
                    anchors.fill: parent
                    color: MultiSelectionDialog.__isSelected(index) ? root.platformStyle.itemSelectedBackgroundColor : root.platformStyle.itemBackgroundColor
                }

                BorderImage {
                    id: background
                    anchors.fill: parent
                    border { left: UI.CORNER_MARGINS; top: UI.CORNER_MARGINS; right: UI.CORNER_MARGINS; bottom: UI.CORNER_MARGINS }
                    source: delegateMouseArea.pressed ? root.platformStyle.itemPressedBackground :
                                MultiSelectionDialog.__isSelected(index) ? root.platformStyle.itemSelectedBackground :
                                root.platformStyle.itemBackground
                }

                Text {
                    id: itemText
                    elide: Text.ElideRight
                    color: MultiSelectionDialog.__isSelected(index) ? root.platformStyle.itemSelectedTextColor : root.platformStyle.itemTextColor
                    anchors.verticalCenter: delegateItem.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: root.platformStyle.itemLeftMargin
                    anchors.rightMargin: root.platformStyle.itemRightMargin
                    font: root.platformStyle.itemFont
                }

                Component.onCompleted: __setItemText()
            }
        }

    // Style API
    property Style platformStyle: SelectionDialogStyle {} // MultiSelectionDialog will use SelectionDialogStyle for margins

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    // private api
    property int __pressDelay: platformStyle.pressDelay
    property variant __selectedIndexesHash: []

    QtObject {
        id: backup
        property variant oldSelectedIndexes: []
    }
    onStatusChanged: {
      if (status == DialogStatus.Opening) {
          selectionListView.positionViewAtIndex(selectedIndexes[0], ListView.Center)
      }
      if (status == DialogStatus.Open)
          backup.oldSelectedIndexes = selectedIndexes
    }
    onRejected: { selectedIndexes = backup.oldSelectedIndexes }

    onSelectedIndexesChanged: {
        MultiSelectionDialog.__syncHash();
    }

    // the title field consists of the following parts: title string and
    // a close button (which is in fact an image)
    // it can additionally have an icon
    titleText: "Multi-Selection Dialog"

    // the content field which contains the selection content
    content: Item {

        id: selectionContent
        property int listViewHeight
        property int maxListViewHeight : visualParent
                                            ? visualParent.height * 0.87
                                                - buttonRow.childrenRect.height - root.platformStyle.contentSpacing - root.platformStyle.buttonsTopMargin
                                                - root.platformStyle.titleBarHeight
                                            : root.parent
                                                ? root.parent.height * 0.87
                                                    - buttonRow.childrenRect.height - root.platformStyle.contentSpacing - root.platformStyle.buttonsTopMargin
                                                    - root.platformStyle.titleBarHeight
                                                : 350
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

    buttons: Item {
        id: buttonRowFiller
        width: parent.width
        // "+1" to avoid fuzziness to address an off-by-one error that seems to affect the upper line of the button row
        // This is an optimization for this particular theme and might stop working work if other parameters are changed.
        height:  childrenRect.height + 1 //+ root.platformStyle.buttonsTopMargin
        y: root.platformStyle.buttonsTopMargin

        onWidthChanged: {
            if ( (acceptButton.width + rejectButton.width > width) ||
                 (acceptButton.implicitWidth + rejectButton.implicitWidth > width) ) {
                acceptButton.width = width / 2
                rejectButton.width = width / 2
            } else {
                acceptButton.width = acceptButton.implicitWidth
                rejectButton.width = rejectButton.implicitWidth
            }
        }

        Row {
            id: buttonRow
            height: childrenRect.height
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                id: acceptButton
                height: implicitHeight
                objectName: "acceptButton"
                text: ""
                onClicked: accept()
                visible: text != ""
                __dialogButton: true
                platformStyle: ButtonStyle {inverted: true}
            }
            Button {
                id: rejectButton
                height: implicitHeight
                objectName: "rejectButton"
                text: ""
                onClicked: reject()
                visible: text != ""
                __dialogButton: true
                platformStyle: ButtonStyle {inverted: true}
            }
        }
    }
}
