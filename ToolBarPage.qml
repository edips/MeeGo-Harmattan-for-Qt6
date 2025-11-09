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
    id: tabbarPage
    anchors.margins: UiConstants.DefaultMargin

    tools: layout1

    ToolBarLayout {
        id:layout1

        ToolIcon {
            id : backIcon;
            visible:backbutton.checked
            iconId: "toolbar-back"; onClicked: pageStack.pop();
        }

        ButtonRow {
            platformStyle: TabButtonStyle { }
            visible: (tab1.checked || tab2.checked || tab3.checked || tab4.checked)
            TabButton{visible:tab1.checked; text:"tab1"}
            TabButton{visible:tab2.checked; enabled:false; text:"tab2 (disabled)"}
            TabButton{visible:tab3.checked; text:"tab3"}
            TabButton{visible:tab4.checked; text:"tab4"}
        }

        TextField {
            id: textfield;
            visible:textbutton.checked
        }

        ToolButtonRow {
            id:button
            visible:toolsbutton.checked
            ToolButton { text:"hello" ; onClicked: print("clicked") }
            ToolButton { text:"hello" ; onClicked: print("clicked") }
        }

        ToolIcon {
            id : extraItem;
            iconId: "toolbar-add"
            visible:plusbutton.checked
        }

        ToolIcon {
            id : menuItem;
            iconId: "toolbar-view-menu"
            visible:menubutton.checked
        }
    }

    Flickable{
        id: flickable
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: buttons.height
        Item {
            anchors.fill: parent
        Column {
            id: buttons
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                id:backbutton
                text: "Toggle left item"
                checkable: true
                checked: true
            }

            Button {
                id:plusbutton
                text: "Toggle plus item"
                checkable: true
            }
            Button {
                id:menubutton
                text: "Toggle menu item"
                checkable: true
            }
            Button {
                id: textbutton
                text: "Toggle text field"
                checkable: true
            }
            Button {
                id:toolsbutton
                text: "Toggle tool button"
                checkable: true
            }
            Button {
                text: "Change orientation"
                onClicked: {
                    orientationLock = (orientation.orientation == "Portrait") ?
                                PageOrientation.LockLandscape : PageOrientation.LockPortrait
                }
            }
            ButtonColumn {
                exclusive: false
                Button {id:tab1; text: "Tab 1" ; checkable:true}
                Button {id:tab2; text: "Tab 2" ; checkable:true}
                Button {id:tab3; text: "Tab 4" ; checkable:true}
                Button {id:tab4; text: "Tab 4" ; checkable:true}
            }
        }
        }
    }
    ScrollDecorator {
        flickableItem: flickable
    }
}
