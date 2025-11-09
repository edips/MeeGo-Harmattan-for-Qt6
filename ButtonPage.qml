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
import com.meego.components 1.0
import "components/"
import "components/UIConstants.js" as UiConstants


Page {
    id: buttonsPage
    tools: buttonTools
    anchors.margins: UiConstants.DefaultMargin

    ToolBarLayout {
        id: buttonTools
        ToolIcon { iconId: "toolbar-back"; onClicked: { myMenu.close(); pageStack.pop(); }  }
        ToolButtonRow {
            ToolButton { text: "ToolButton 1" }
            ToolButton { text: "ToolButton 2" }
        }
        ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: col
            spacing: 30
            width:  parent.width

            Component.onCompleted: {
                var count = children.length;
                for (var i = 0; i < count; i++) {
                    var item = children[i];
                    item.anchors.horizontalCenter = item.parent.horizontalCenter;
                }
            }

            //Button { text: "Set theme.inverted to " + !theme.inverted; onClicked: { theme.inverted = !theme.inverted; console.log("theme.inverted: " + theme.inverted) } }
            Button { text: "Set theme.inverted to "; onClicked: { console.log("theme.inverted: " ) } }
            Button { text: "Generic"; }
            Button { text: "Generic forced to inverted style"; platformStyle: ButtonStyle{ inverted: true } }

            Button { id: disabledButton; text: "Disabled"; enabled: false }

            Button {
                text: "Toggle Disabled";
                onClicked: {
                    if (disabledButton.enabled) {
                        disabledButton.enabled = false;
                    } else {
                        disabledButton.enabled = true;
                    }
                }
            }

            Button { text: "Checkable"; checkable: true }
            Button { text: "Checkable, initially checked"; checkable: true; checked: true}
            Button { text: "Checked & disabled"; checkable: true; checked: true; enabled: false }

            Button { iconSource: "qrc:/images/icon-s-telephony-second-call.png"; text: "Icon with label" }
            Button { iconSource: "qrc:/images/icon-s-telephony-end-call.png" }
            CheckBox {
                text: "CheckBox, initially unchecked "
            }
            CheckBox {
                checked: true
                text: "CheckBox, initially checked"
            }
            CheckBox {
                width: parent.width
                checked: true
                platformStyle: CheckBoxStyle { elideMode: Text.ElideRight }
                text: "CheckBox, with long long long long long text"
            }

            ButtonRow {
                Button { text: "Two" }
                Button { text: "Buttons" }
            }
            ButtonRow {
                width: 200
                exclusive: false
                Button { iconSource: "qrc:/images/icon-s-telephony-second-call.png" }
                Button { iconSource: "qrc:/images/icon-s-telephony-hold.png" }
                Button { iconSource: "qrc:/images/icon-s-telephony-end-call.png" }
            }
            ButtonRow {
                platformStyle: ButtonStyle { inverted: true }
                Button { text: "Three" }
                Button { text: "Inverted" }
                Button { text: "Buttons" }
            }
            ButtonColumn {
                Button { text: "Column" }
                Button { text: "of" }
                Button { text: "Buttons" }
            }
            ButtonColumn {
                RadioButton { text: "AM" }
                RadioButton { text: "FM" }
                RadioButton { text: "DAB" }
                spacing: 10
            }
        }

    }
    ScrollDecorator {
        flickableItem: flickable
    }
}
