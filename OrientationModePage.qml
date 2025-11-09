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
    id: orientationModePage
    anchors.margins: UiConstants.DefaultMargin

    ListModel {
        id: pagesModel
        ListElement {
            page: "OrientationModePage.qml"
            title: "Locked in Landscape"
            index: 1
        }
        ListElement {
            page: "OrientationModePage.qml"
            title: "Locked in Portrait"
            index: 2
        }
        ListElement {
            page: "OrientationModePage.qml"
            title: "Locked in Portrait and Landscape"
            index: 3
        }

        ListElement {
            page: "OrientationModePage.qml"
            title: "Not locked"
            index: 4
        }
    }

    function handleClick(page, index) {
        if(index === 1) {
            pageStack.push(Qt.createComponent(page), {orientationLock: PageOrientation.LockLandscape})
        } else if(index === 2) {
            pageStack.push(Qt.createComponent(page), {orientationLock: PageOrientation.LockPortrait})
        } else if(index === 3){
            pageStack.push(Qt.createComponent(page), {orientationLock: PageOrientation.LockPrevious})
        } else if(index === 4){
            pageStack.push(Qt.createComponent(page))
        }
    }

    ListView {
        anchors.fill: parent

        model: pagesModel
        delegate: ListDelegate {
            Image {
                source: "qrc:/images/icon-m-common-drilldown-arrow.png" //+ (theme.inverted ? "-inverse" : "")
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter
            }

            onClicked: handleClick(page, index)
        }
    }

    tools: ToolBarLayout {

        ToolIcon {
            iconId: "toolbar-back"; onClicked: pageStack.pop();
        }

        ToolIcon {
            iconId: "toolbar-view-menu"
        }
    }
}
