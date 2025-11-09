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
    id: staticpage1
    anchors.margins: UiConstants.DefaultMargin

    Component {
        id: staticpage2
        Page {
            tools: ToolBarLayout {
                       id: staticToolbar1
                       ToolIcon { iconId: "toolbar-back"; onClicked: pageStack.pop(); }
                       ToolIcon { iconId: "toolbar-mediacontrol-backwards" }
                       ToolIcon { iconId: "toolbar-mediacontrol-pause" }
                       ToolIcon { iconId: "toolbar-mediacontrol-forward" }
                       ToolIcon { iconId: "toolbar-view-menu" }
            }

            Column {
                spacing: 30
                Text { text: "This is static page two."; font.pixelSize: 30 }
                Button {
                    text: "Go to page three"
                    onClicked: pageStack.push(staticpage3)
                }
            }
        }
    }

    Component {
        id: staticpage3
        Page {
            tools: ToolBarLayout {
                       id: staticToolbar1
                       ToolIcon { iconId: "toolbar-back"; onClicked: pageStack.pop(); }
                       ToolIcon { iconId: "toolbar-alphabetic-order" }
                       ToolIcon { iconId: "toolbar-view-menu" }
            }

            Column {
                spacing: 30
                Text { text: "This is static page three."; font.pixelSize: 30 }
                Text { text: "You can either go back now, or..."; font.pixelSize: 30  }
                Button {
                    text: "Go to directly to page one, popping page two from stack"
                    onClicked: pageStack.pop(staticpage1)
                }
            }
        }
    }

    tools: ToolBarLayout {
               id: staticToolbar1
               ToolIcon { iconId: "toolbar-back"; onClicked: pageStack.pop(); }
               ToolIcon { iconId: "toolbar-send-email" }
               ToolIcon { iconId: "toolbar-new-chat" }
               ToolIcon { iconId: "toolbar-view-menu" }
    }

    Column {
        spacing: 30
        Text { text: "This is static page one."; font.pixelSize: 30 }
        Button {
            text: "Go to page two"
            onClicked: pageStack.push(staticpage2)
        }
        Button {
            text: "Go to page three, leaving page two in the stack"
            onClicked: pageStack.push([staticpage2, staticpage3])
        }
    }
}
