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
    id: root
    property int level: 0
    property string pageText: "PAGE"
    anchors.margins: UiConstants.DefaultMargin

    ToolBarLayout {
        id: navigationToolbar1
        visible: false
        ToolIcon { iconId: "toolbar-back"; onClicked: pageStack.pop(); }
        ToolIcon { iconId: ["toolbar-send-email",
                            "toolbar-new-chat",
                            "toolbar-headphones",
                            "toolbar-clock",
                            "toolbar-settings",
                            "toolbar-tag"
                            ][level % 6]}
        ToolIcon { iconId: "toolbar-view-menu";}
    }

    ToolBarLayout {
        id: navigationToolbar2
        visible: false
        ToolIcon { iconId: "toolbar-back"; onClicked: pageStack.pop(); }
        ToolIcon { iconId: ["toolbar-send-email",
                            "toolbar-headphones",
                            "toolbar-settings",
                            ][level % 3]}
        ToolIcon { iconId: ["toolbar-new-chat",
                            "toolbar-clock",
                            "toolbar-tag"
                            ][level % 3]}
        ToolIcon { iconId: "toolbar-view-menu";}
    }

    tools: (level % 3 == 0) ? navigationToolbar1 : navigationToolbar2

    Column {
        spacing: 30
        Text {
            text: "This is a " + pageText
            font.pixelSize: 30
            font.bold: true
        }
        Button {
            text: "Go to a sub page";
            onClicked: {
                pageStack.push(Qt.createComponent("DynamicNavigationPage.qml"), { pageText: "sub-" + root.pageText, level: root.level + 1 });
            }
        }
        Column {
            Text { text: "Go directly to n'th subpage:"; font.pixelSize: 30 }

            Row {
                TextField { id: tf; width: 100; text: "1" }
                Button {
                    text: "Go!"
                    onClicked: {
                        var n = tf.text
                        var prefix = "sub-";
                        var level = root.level + 1;
                        var pages = [];
                        for (var i = 0; i < n; i++) {
                            pages.push({ page: "../DynamicNavigationPage.qml", properties: { pageText: prefix + root.pageText, level: level } });
                            prefix += "sub-";
                            level += 1;
                        }
                        pageStack.push(pages);
                    }
                }
            }
        }
    }
}
