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
import "components/UIConstants.js" as UiConstants
import "components"


Page {
    id: buttonsPage
    tools: buttonTools
    anchors.margins: UiConstants.DefaultMargin

    ToolBarLayout {
        id: buttonTools

        ToolIcon { iconId: "toolbar-back"; onClicked: { myMenu.close(); pageStack.pop(); }  }
        ToolButtonRow {
            ToolButton { text: "Copy"; onClicked: { label.text = textField.text } }
            ToolButton { text: "Clear"; onClicked: { textField.text = ""; label.text = "empty label" } }
        }
        ToolIcon { iconId: "toolbar-view-menu" ; onClicked: myMenu.open(); }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick

        Button {
            id: button;
            anchors.topMargin: 32
            anchors.leftMargin: 32
            width: 450
            text: "Copy text from TextField to Label"
            onClicked: { label.text = textField.text }
        }

        TextField {
            id: textField
            placeholderText: "TextField"
            anchors.top: button.bottom
            anchors.left: button.left
            anchors.topMargin: 16
            width: 450
        }

        Label {
            id: label
            anchors.top: textField.bottom
            anchors.left: textField.left
            anchors.topMargin: 16
            text: "empty label"
        }

    }

    ScrollDecorator {
        flickableItem: flickable
    }

    Menu {
        id: myMenu
        visualParent: pageStack

        MenuLayout {
            MenuItem { text: "Move text from TextField to Label"; onClicked: { label.text = textField.text } }
            MenuItem { text: "Clear everything"; onClicked: { textField.text = ""; label.text = "empty label" } }
        }
    }
}
