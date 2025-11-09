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
import "components"

Page {
     id: listPage
     anchors.margins: rootWindow.pageMargin

     function openFile(file) {
         var component = Qt.createComponent(file)
         if (component.status === Component.Ready)
             pageStack.push(component);
         else
             console.log("Error loading component:", component.errorString());
     }

     ListModel {
         id: pagesModel
         ListElement {
             page: "SimpleExamplesPage.qml"
             title: "Simple examples"
             subtitle: "Buttons, TextField, ToolBar and ViewMenu"
         }
         ListElement {
             page: "DialogsPage.qml"
             title: "Dialogs"
             subtitle: "How to use different dialogs"
         }
     }

     ListView {
         id: listView
         anchors.fill: parent
         model: pagesModel

         delegate:  Item {
             id: listItem
             height: 88
             width: parent.width

             BorderImage {
                 id: background
                 anchors.fill: parent
                 // Fill page borders
                 anchors.leftMargin: -listPage.anchors.leftMargin
                 anchors.rightMargin: -listPage.anchors.rightMargin
                 visible: mouseArea.pressed
                 source: "qrc:/images/meegotouch-list-background-pressed-center.png"
             }

             Row {
                 anchors.fill: parent

                 Column {
                     anchors.verticalCenter: parent.verticalCenter

                     Label {
                         id: mainText
                         text: model.title
                         font.weight: Font.Bold
                         font.pixelSize: 26
                     }

                     Label {
                         id: subText
                         text: model.subtitle
                         font.weight: Font.Light
                         font.pixelSize: 22
                         color: "#cc6633"

                         visible: text != ""
                     }
                 }
             }

             Image {
                 source: "qrc:/images/icon-m-common-drilldown-arrow.png"//+ (theme.inverted ? "-inverse" : "")
                 anchors.right: parent.right;
                 anchors.verticalCenter: parent.verticalCenter
             }

             MouseArea {
                 id: mouseArea
                 anchors.fill: background
                 onClicked: {
                     listPage.openFile(page)
                 }
             }
         }
     }
     ScrollDecorator {
         flickableItem: listView
     }
 }
