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

    property bool busy: Boolean(tabGroup.currentTab.busy)
    anchors.margins: UiConstants.DefaultMargin

    tools: ToolBarLayout {
      
        ToolIcon { 
          id: toolIcon 
          iconId: "toolbar-back" 
          onClicked: pageStack.pop()
        }
                 
        ButtonRow {
          anchors {left: toolIcon.right; right: parent.right}
            
            platformStyle: TabButtonStyle { }
            TabButton {
                text: "Tab1"
                tab: tab1
            }
            TabButton {
                text: "Tab2"
                tab: tab2
            }
            TabButton {
                text: "Tab3"
                tab: tab3
            }
        }
    }

    TabGroup {
        id: tabGroup

        currentTab: tab1

        PageStack {
            id: tab1
        }
        PageStack {
            id: tab2
        }
        Page {
            id: tab3
            Column {
                spacing: 10

                Text {
                    text: "This is a single page"
                }
            }
        }
    }

    Component {
        id: stackedPage
        Page {
            property int index
            Column {
                anchors.horizontalCenter:parent.horizontalCenter
                spacing: 10

                Text {
                    text: "This is a stacked page for tab: " + index + "\nCurrent depth: " + tabGroup.currentTab.depth
                }
                Button {
                    text: "Push another page"
                    onClicked: { tabGroup.currentTab.push(stackedPage, { index : tabGroup.currentTab == tab1 ? 1 : 2 } ); }
                }
                Button {
                     text: "Change mode"
                     onClicked: {
                         for (var i = 0, l = tabbarPage.tools.children.length; i < l; i++) {
                             var row = tabbarPage.tools.children[i];
                             if (row.hasOwnProperty("checkedButton")) {
                                 for (var j = 0, l2 = row.children.length; j < l2; j++) {
                                     var child = row.children[j];
                                     child.text = child.text ? "" : "Tab" + (j+1);
                                     child.iconSource = child.iconSource !== "" ? "" : "qrc:/images/icon-m-toolbar-search.png";
                                 }
                             }
                         }
                     }
                 }
             }
        }
    }

    Component.onCompleted: {
        tab1.push(stackedPage, { index: 1 });
        tab2.push(stackedPage, { index: 2 });
    }
}
