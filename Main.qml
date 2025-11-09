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

PageStackWindow {
    id: rootWindow
    //showToolBar: false
    width: 400
    height: 800

    platformStyle: defaultStyle;

    property bool enableSwipe: true

    PageStackWindowStyle { id: defaultStyle }
    PageStackWindowStyle {
        id: customStyle;
        background: "qrc:/images/meegotouch-wallpaper-portrait.jpg";
        backgroundFillMode: Image.PreserveAspectCrop
    }

    // ListPage is what we see when the app starts, it links to the component specific pages
    initialPage: ListPage { }

    // These tools are shared by most sub-pages by assigning the id to a page's tools property
    ToolBarLayout {
        id: commonTools
        visible: false
        ToolIcon { iconId: "toolbar-back"; onClicked: { myMenu.close(); pageStack.pop(); } }
        ToolIcon { iconId: "toolbar-view-menu"; onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close() }
    }
    SelectionHandles{}

    Menu {
        id: myMenu
        visualParent: pageStack
        onStatusChanged: {
            if (status === DialogStatus.Closing) {
                screen.allowSwipe = enableSwipe;
            }
        }
        MenuLayout {
            MenuItem { text: "Theme color default"; }//onClicked: theme.colorScheme = 1 }
            MenuItem { text: "Theme color lightGreen";} //onClicked: theme.colorScheme = 2 }
            MenuItem { text: "Theme color green";} //onClicked: theme.colorScheme = 3 }
            MenuItem { text: "Theme color darkGreen";} //onClicked: theme.colorScheme = 4 }
            MenuItem { text: "Theme color darkestGreen";} //onClicked: theme.colorScheme = 5 }
            MenuItem { text: "Theme color lightBlue";} //onClicked: theme.colorScheme = 6 }
            MenuItem { text: "Theme color blue";}// onClicked: theme.colorScheme = 7 }
            MenuItem { text: "Theme color darkBlue";}//  onClicked: theme.colorScheme = 8 }
            MenuItem { text: "Theme color darkestBlue";}//  onClicked: theme.colorScheme = 9 }
            MenuItem { text: "Theme color darkPurple";}//  onClicked: theme.colorScheme = 10 }
            MenuItem { text: "Theme color purple";}//  onClicked: theme.colorScheme = 11 }
            MenuItem { text: "Theme color pink";}//  onClicked: theme.colorScheme = 12 }
            MenuItem { text: "Theme color lightPink";}//  onClicked: theme.colorScheme = 13 }
            MenuItem { text: "Theme color lightOrange";}//  onClicked: theme.colorScheme = 14 }
            MenuItem { text: "Theme color orange";}//  onClicked: theme.colorScheme = 15 }
            MenuItem { text: "Theme color darkOrange";}//  onClicked: theme.colorScheme = 16 }
            MenuItem { text: "Theme color darkYellow";}//  onClicked: theme.colorScheme = 17 }
            MenuItem { text: "Theme color yellow";}//  onClicked: theme.colorScheme = 18 }
            MenuItem { text: "Theme color lightYellow";}//  onClicked: theme.colorScheme = 19 }
            MenuItem { text: "Very long and extremely verbose ListTitle #20" }
        }
    }
}
