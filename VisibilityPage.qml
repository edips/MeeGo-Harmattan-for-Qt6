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
    id: visibilityPage
    anchors.margins: UiConstants.DefaultMargin
    tools: commonTools

    function updateViewMode() {
        if (platformWindow.viewMode === WindowState.Fullsize) {
            l1.item.color = "green";
        } else {
            l1.item.color = "red";
        }

        l1.item.text = platformWindow.viewModeString;
    }

    function updateVisible() {
        if (platformWindow.visible) {
            l2.item.color = "green";
            l2.item.text = "visible";
        } else {
            l2.item.color = "red";
            l2.item.text = "invisible";
        }
    }

    function updateActive() {
        if (platformWindow.active) {
            l3.item.color = "green";
            l3.item.text = "active";
        } else {
            l3.item.color = "red";
            l3.item.text = "inactive";
        }
    }

    Connections {
        target: platformWindow

        onViewModeChanged: updateViewMode()
        onVisibleChanged: updateVisible()
        onActiveChanged: updateActive()
    }

    Component {
        id: textBox

        Rectangle {
            property alias text: textItem.text

            width: 200; height: 150
            color: "yellow"
            border.color: "black"
            border.width: 5
            radius: 10

            Text {
                id: textItem
                anchors.centerIn: parent
                font.pointSize: 32
                color: "black"
            }
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: col.width
        contentHeight: col.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: col
            spacing: 10
            width: flickable.width

            Loader {
                id: l1
                sourceComponent: textBox
            }

            Loader {
                id: l2
                sourceComponent: textBox
            }

            Loader {
                id: l3
                sourceComponent: textBox
            }

            Component.onCompleted: {
                updateViewMode();
                updateVisible();
                updateActive();

                var count = children.length;
                for (var i = 0; i < count; i++) {
                    var item = children[i];
                    item.anchors.horizontalCenter = item.parent.horizontalCenter;
                }
            }
        }
    }
}
