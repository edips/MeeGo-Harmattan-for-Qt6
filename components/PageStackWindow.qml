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

import QtQuick // Ensure QtQuick 2.15 or higher for modern QML features
import com.meego.components 1.0
import meego

Window {
    id: window
    width: 480
    height: 854
    visible: true
    property bool showToolBar: true
    property variant initialPage
    property alias pageStack: contentArea
    property Style platformStyle: PageStackWindowStyle{}
    property alias platformToolBarHeight: toolBar.height // read-only


    //private api
    property int __statusBarHeight: 0

    objectName: "pageStackWindow"

    property alias color: background.color
    default property alias content: windowContent.data

    // Read only property true if window is in portrait
    //property alias inPortrait: window.portrait

    // Extendend API (for fremantle only)
    property bool allowSwitch: true
    property bool allowClose: true

    signal orientationChangeAboutToStart
    signal orientationChangeStarted
    signal orientationChangeFinished

    onClosing: (close) => {
        // Case 1: The virtual keyboard is open.
        if (inputContext.softwareInputPanelVisible || inputContext.customSoftwareInputPanelVisible) {
            // By forcing focus to the page, the TextInput will lose focus,
            // causing the keyboard to hide.
            pageStack.currentPage.forceActiveFocus();
            close.accepted = false; // Prevent closing
            return;
        }

        // Case 2: The keyboard is not open. Proceed with navigation.
        if (pageStack.depth > 1) {
            pageStack.pop();
            close.accepted = false; // Prevent closing
        } else {
            // If we are on the last page, allow the application to quit.
            close.accepted = true;
        }
    }

    Rectangle {
        id: background2
        anchors.fill: parent
        color: platformStyle.colorBackground
    }

    Item {
        width: parent.width //screen.displayWidth
        height: parent.height//screen.displayHeight
        anchors.centerIn: parent

        Item {
            id: windowContent
            width: parent.width
            height: parent.height - heightDelta
            // Used for resizing windowContent when virtual keyboard appears
            property int heightDelta: 0
            objectName: "windowContent"
            clip: true
        }

        SoftwareInputPanel {
            id: softwareInputPanel
            active: inputContext.customSoftwareInputPanelVisible
            anchors.bottom: parent.bottom
            onHeightChanged: {
                windowContent.heightDelta = height;
            }

            Loader {
                id: softwareInputPanelLoader
                width: parent.width
                source: inputContext.customSoftwareInputPanelComponent || ""
            }
        }
    }

    Rectangle {
        id: background
        visible: platformStyle.background === ""
        color: platformStyle.backgroundColor
        anchors { top: parent.top; left: parent.left; bottom: parent.bottom; right: parent.right; }
    }

    Image {
        id: backgroundImage
        visible: platformStyle.background !== ""
        source: orientation.orientation === "Portrait" ? platformStyle.portraitBackground : platformStyle.landscapeBackground
        fillMode: platformStyle.backgroundFillMode
        anchors { top: parent.top; left: parent.left; bottom: parent.bottom; right: parent.right; }
    }

    Item {
        objectName: "appWindowContent"
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        // content area
        PageStack {
            id: contentArea
            anchors { top: parent.top; left: parent.left; right: parent.right; bottom: parent.bottom; }
            anchors.bottomMargin: toolBar.visible || (toolBar.opacity==1)? toolBar.height : 0
            toolBar: toolBar

            onBusyChanged: {
                if (!busy && pageStack.currentPage) {
                    pageStack.currentPage.forceActiveFocus();
                }
            }
        }

        Item {
            id: roundedCorners
            visible: platformStyle.cornersVisible
            anchors.fill: parent
            z: 10001

            Image {
                anchors.top: parent.top
                anchors.left: parent.left
                source: "qrc:/images/meegotouch-applicationwindow-corner-top-left.png"
            }
            Image {
                anchors.top: parent.top
                anchors.right: parent.right
                source: "qrc:/images/meegotouch-applicationwindow-corner-top-right.png"
            }
            Image {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                source: "qrc:/images/meegotouch-applicationwindow-corner-bottom-left.png"
            }
            Image {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                source: "qrc:/images/meegotouch-applicationwindow-corner-bottom-right.png"
            }
        }

        ToolBar {
            id: toolBar
            anchors.bottom: parent.bottom
            privateVisibility: window.showToolBar ? ToolBarVisibility.Visible : ToolBarVisibility.Hidden
        }
    }

    // event preventer when page transition is active
    MouseArea {
        anchors.fill: parent
        enabled: pageStack.busy
    }

    Component.onCompleted: {
        if (initialPage)
            pageStack.push(initialPage);
    }
}
