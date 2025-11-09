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
    id: pageStackWindowPage
    tools: pageStackWindowTools
    anchors.margins: UiConstants.DefaultMargin

    ToolBarLayout {
        id: pageStackWindowTools
        visible: false
        ToolIcon { iconId: "toolbar-back"; onClicked: { enableSwipe = true; screen.allowSwipe = enableSwipe; myMenu.close(); pageStack.pop(); } }
        ToolIcon { iconId: "toolbar-view-menu"; onClicked: { if (myMenu.status === DialogStatus.Closed) { myMenu.open(); enableSwipe = screen.allowSwipe; screen.allowSwipe = true; } else { myMenu.close(); } } }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: col.width
        contentHeight: col.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: col
            spacing: 30
            width:  flickable.width

            Component.onCompleted: {
                var count = children.length;
                for (var i = 0; i < count; i++) {
                    var item = children[i];
                    item.anchors.horizontalCenter = item.parent.horizontalCenter;
                }
             }

            Button { text: "Toggle StatusBar"; checkable: true; checked: false;} // onClicked: { rootWindow.showStatusBar = !rootWindow.showStatusBar; } }

            Button { text: "Alternate background image"; checkable: true; checked: rootWindow.platformStyle===customStyle; onClicked: { if (rootWindow.platformStyle===defaultStyle) rootWindow.platformStyle=customStyle; else rootWindow.platformStyle=defaultStyle; } }

            Button { text: "Toggle Rounded corners"; checkable:true; checked: rootWindow.platformStyle.cornersVisible; onClicked: { rootWindow.platformStyle.cornersVisible = !rootWindow.platformStyle.cornersVisible; } }

            Button { text: "Toggle ToolBar"; checkable: true; checked: rootWindow.showToolBar; onClicked: { rootWindow.showToolBar = !rootWindow.showToolBar } }

            Button { text: "Toggle Swipe"; checkable: true; checked: enableSwipe; onClicked: { enableSwipe = !enableSwipe; screen.allowSwipe = enableSwipe } }
          }

    }
    ScrollDecorator {
        flickableItem: flickable
    }

}
