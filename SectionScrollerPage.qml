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
    id: sectionScrollerPage
    anchors.margins: UiConstants.DefaultMargin
    tools: commonTools

    Item {
        anchors.fill: parent

        ListModel {
            id: testModel
            ListElement { title: "A Cat 1"; alphabet: "A" }
            ListElement { title: "A Cat 2"; alphabet: "A" }
            ListElement { title: "A Cat 3"; alphabet: "A" }
            ListElement { title: "A Cat 1"; alphabet: "A" }
            ListElement { title: "A Cat 2"; alphabet: "A" }
            ListElement { title: "A Cat 3"; alphabet: "A" }
            ListElement { title: "Boo 1"; alphabet: "B" }
            ListElement { title: "Boo 2"; alphabet: "B" }
            ListElement { title: "Boo 3"; alphabet: "B" }
            ListElement { title: "Cat 1"; alphabet: "C" }
            ListElement { title: "Cat 2"; alphabet: "C" }
            ListElement { title: "Cat 3"; alphabet: "C" }
            ListElement { title: "Cat 4"; alphabet: "C" }
            ListElement { title: "Cat 5"; alphabet: "C" }
            ListElement { title: "Cat 6"; alphabet: "C" }
            ListElement { title: "Dog 1"; alphabet: "D" }
            ListElement { title: "Dog 2"; alphabet: "D" }
            ListElement { title: "Dog 3"; alphabet: "D" }
            ListElement { title: "Dog 4"; alphabet: "D" }
            ListElement { title: "Dog 5"; alphabet: "D" }
            ListElement { title: "Dog 6"; alphabet: "D" }
            ListElement { title: "Dog 7"; alphabet: "D" }
            ListElement { title: "Dog 8"; alphabet: "D" }
            ListElement { title: "Dog 9"; alphabet: "D" }
            ListElement { title: "Elephant 1"; alphabet: "E" }
            ListElement { title: "Elephant 2"; alphabet: "E" }
            ListElement { title: "Elephant 3"; alphabet: "E" }
            ListElement { title: "Elephant 4"; alphabet: "E" }
            ListElement { title: "Elephant 5"; alphabet: "E" }
            ListElement { title: "Elephant 6"; alphabet: "E" }
            ListElement { title: "FElephant 1"; alphabet: "F" }
            ListElement { title: "FElephant 2"; alphabet: "F" }
            ListElement { title: "FElephant 3"; alphabet: "F" }
            ListElement { title: "FElephant 4"; alphabet: "F" }
            ListElement { title: "FElephant 5"; alphabet: "F" }
            ListElement { title: "FElephant 6"; alphabet: "F" }
            ListElement { title: "Guinea pig"; alphabet: "G" }
            ListElement { title: "Goose"; alphabet: "G" }
            ListElement { title: "Giraffe"; alphabet: "G" }
            ListElement { title: "Guinea pig"; alphabet: "G" }
            ListElement { title: "Goose"; alphabet: "G" }
            ListElement { title: "Giraffe"; alphabet: "G" }
            ListElement { title: "Guinea pig"; alphabet: "G" }
            ListElement { title: "Goose"; alphabet: "G" }
            ListElement { title: "Giraffe"; alphabet: "G" }
            ListElement { title: "Horse"; alphabet: "H" }
            ListElement { title: "Horse"; alphabet: "H" }
            ListElement { title: "Horse"; alphabet: "H" }
            ListElement { title: "Parrot"; alphabet: "P" }
            ListElement { title: "Parrot"; alphabet: "P" }
            ListElement { title: "Parrot"; alphabet: "P" }
            ListElement { title: "Parrot"; alphabet: "P" }
        }

        ListView {
            id: list
            anchors.fill: parent
            delegate:  ListDelegate {}
            model: testModel
            section.property: "alphabet"
            section.criteria: ViewSection.FullString
            section.delegate: Item {
                // "GroupHeader" component?
                width: parent.width
                height: 40
                Text {
                    id: headerLabel
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 8
                    anchors.bottomMargin: 2
                    text: section
                    font.bold: true
                    font.pointSize: 18
                    color: "#3C3C3C"; // theme.inverted ? "#4D4D4D" : "#3C3C3C";
                }
                Image {
                    anchors.right: headerLabel.left
                    anchors.left: parent.left
                    anchors.verticalCenter: headerLabel.verticalCenter
                    anchors.rightMargin: 24
                    source: "qrc:/images/meegotouch-groupheader" +  "-background.png" //(theme.inverted ? "-inverted" : "") + "-background"
                }
            }
        }

        SectionScroller {
            listView: list
        }
        ScrollDecorator {
            flickableItem: list
        }
    }
}
