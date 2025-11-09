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
    id: listPage
    anchors.leftMargin: UiConstants.DefaultMargin
    anchors.rightMargin: UiConstants.DefaultMargin

    tools:
        ToolBarLayout {
            ToolIcon {
               iconId: "toolbar-view-menu"
               onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
               anchors.right: parent===undefined ? undefined : parent.right
            }
        }

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
            page: "ChangeToolbarPage.qml"
            title: "Change Toolbar Page"
            subtitle: "Change Toolbar Page features"
        }
        ListElement {
            page: "InfoBannerPage.qml"
            title: "Info Banner"
            subtitle: "Info Banner features"
        }
        ListElement {
            page: "PageIndicatorPage.qml"
            title: "Page Indicator"
            subtitle: "Page Indicator features"
        }
        ListElement {
            page: "PlaybackPage.qml"
            title: "PageStack"
            subtitle: "PageStack features"
        }
        ListElement {
            page: "StyledButtons.qml"
            title: "StyledButtons.qml Window"
            subtitle: "StyledButtons.qml features"
        }
        ListElement {
            page: "TumblerPage.qml"
            title: "Tumbler Window"
            subtitle: "Tumbler features"
        }
        ListElement {
            page: "TumblerDialogPage.qml"
            title: "TumblerDialog.qml Window"
            subtitle: "TumblerDialog.qml.qml features"
        }
        ListElement {
            page: "DialogsPage.qml"
            title: "dialogs.qml Window"
            subtitle: "dialogs.qml.qml features"
        }





        ListElement {
            page: "PageStackWindowPage.qml"
            title: "PageStack Window"
            subtitle: "PageStack window features"
        }
        ListElement {
            page: "LabelPage.qml"
            title: "Labels"
            subtitle: "Assorted labels"
        }
        ListElement {
            page: "ButtonPage.qml"
            title: "Buttons"
            subtitle: "Assorted Button variants"
        }
        ListElement {
            page: "SliderPage.qml"
            title: "Sliders"
            subtitle: "Assorted Slider variants"
        }
        ListElement {
            page: "TextInputPage.qml"
            title: "Text Input"
            subtitle: "TextField and TextArea components"
        }
        ListElement {
            page: "CustomVkbPage.qml"
            title: "Custom VKB"
            subtitle: "Shows how to integrate custom VKB"
        }
        ListElement {
            page: "DialogPage.qml"
            title: "Dialogs"
            subtitle: "Using standard dialogs"
        }
        ListElement {
            page: "StaticNavigationPage.qml"
            title: "Navigation"
            subtitle: "Navigating static pages using PageStack"
        }
        ListElement {
            page: "DynamicNavigationPage.qml"
            title: "Dynamic Navigation"
            subtitle: "Navigating dynamically created pages"
        }
        ListElement {
            page: "TabBarPage.qml"
            title: "Tabs"
            subtitle: "How to use TabGroup for page navigation"
        }
        ListElement {
            page: "ToolBarPage.qml"
            title: "Tools"
            subtitle: "How to use a tool bar with different layouts"
        }
        ListElement {
            page: "OrientationPage.qml"
            title: "Orientation"
            subtitle: "How to manage the window orientation"
        }
        ListElement {
            page: "OrientationModePage.qml"
            title: "Orientation Locking Page"
            subtitle: "How to lock the orientation in a page"
        }
        ListElement {
            page: "OrientationModeScreen.qml"
            title: "Orientation Locking Screen"
            subtitle: "How to lock the orientation of the screen"
        }
        ListElement {
            page: "SectionScrollerPage.qml"
            title: "Section Scroller"
            subtitle: "How to use section scroller"
        }
        ListElement {
            page: "SheetPage.qml"
            title: "Sheets"
            subtitle: "How to use sheets"
        }
        ListElement {
            page: "MiscPage.qml"
            title: "Miscellaneous"
            subtitle: "Set of miscellaneous components"
        }
        ListElement {
            page: "VisibilityPage.qml"
            title: "Visibility"
            subtitle: "Window state notifications"
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        model: pagesModel

        delegate:  ListDelegate {
            Image {
                source: "qrc:/images/icon-m-common-drilldown-arrow"  + ".png" // + (theme.inverted ? "-inverse" : "")
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter
            }

            onClicked: { listPage.openFile(page) }
        }
    }
    ScrollDecorator {
        flickableItem: listView
    }
}
