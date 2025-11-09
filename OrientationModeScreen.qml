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
    id: orientationModeScreen
    anchors.margins: UiConstants.DefaultMargin

    Column {
        anchors.centerIn: parent
        spacing: 20
        Row {
            Label {
                text: "Orientation Locking"
                font.pixelSize: 30
            }
        }
        Row {
            Column {
                CheckBox {
                    id: cbLandscape
                    text: "Landscape"
                    checked: screen.allowedOrientations & Screen.Landscape
                    onClicked:
                        if(cbLandscape.checked)
                            screen.allowedOrientations = screen.allowedOrientations | Screen.Landscape;
                        else
                            screen.allowedOrientations = screen.allowedOrientations & ~Screen.Landscape;
                }
                CheckBox {
                    id: cbPortrait
                    text: "Portrait"
                    checked: screen.allowedOrientations & Screen.Portrait
                    onClicked:
                        if(cbPortrait.checked)
                            screen.allowedOrientations = screen.allowedOrientations | Screen.Portrait;
                        else
                            screen.allowedOrientations = screen.allowedOrientations & ~Screen.Portrait;
                }
                CheckBox {
                    id: cbLandscapeInverted
                    text: "LandscapeInverted"
                    checked: screen.allowedOrientations & Screen.LandscapeInverted
                    onClicked:
                        if(cbLandscapeInverted.checked)
                            screen.allowedOrientations = screen.allowedOrientations | Screen.LandscapeInverted;
                        else
                            screen.allowedOrientations = screen.allowedOrientations & ~Screen.LandscapeInverted;
                }
                CheckBox {
                    id: cbPortraitInverted
                    text: "PortraitInverted"
                    checked: screen.allowedOrientations & Screen.PortraitInverted
                    onClicked:
                        if(cbPortraitInverted.checked)
                            screen.allowedOrientations = screen.allowedOrientations | Screen.PortraitInverted;
                        else
                            screen.allowedOrientations = screen.allowedOrientations & ~Screen.PortraitInverted;
                }
                Label {
                    text: "Text field for VKB orientation lock testing:"
                }
                TextField {
                    anchors {left: parent.left; right: parent.right;}
                    placeholderText: "Default text"
                    maximumLength: 80

                    Keys.onReturnPressed: {
                        text = "Return key pressed";
                        parent.focus = true;
                    }
                }
                Label {
                    text: "Custom VKB:"
                }

                TextField {
                    id: aTextField
                    anchors {left: parent.left; right: parent.right;}
                    //platformCustomSoftwareInputPanel: redVkb
                    property string backspaceTitle: "Delete"

                    Connections {
                        target: inputContext
                        onSoftwareInputPanelEventChanged: {
                            if(aTextField.activeFocus) {
                                if(inputContext.softwareInputPanelEvent === "Backspace") {
                                    if(aTextField.text.length > 0)
                                        aTextField.text = aTextField.text.substring(0, aTextField.text.length - 1)
                                } else {
                                    aTextField.text = aTextField.text + inputContext.softwareInputPanelEvent
                                }
                            }
                        }
                    }
                }

            }
        }
        Row {
            Button {
                text: "Default"
                onClicked: {
                    screen.allowedOrientations = Screen.Portrait | Screen.Landscape
                    cbLandscape.checked = true;
                    cbPortrait.checked = true;
                    cbLandscapeInverted.checked = false;
                    cbPortraitInverted.checked = false;
                }
            }
        }
        Row {
            Label {
                text: "If hardware keyboard is open, \norientation is always locked to landscape."
                wrapMode: Text.Wrap
            }
        }
    }

    Component {
        id: redVkb

        Rectangle {
            id: rec
            color: "red"
            height: 100

            Item {
                anchors.centerIn: parent
                Button {
                    id: addA
                    width: 150
                    anchors.right: removeA.left
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Add 'A'"
                    onClicked: inputContext.softwareInputPanelEvent = "A"
                }

                Button {
                    id: removeA
                    width: 150
                    anchors.verticalCenter: parent.verticalCenter
                    text: inputContext.targetInputFor(redVkb).backspaceTitle
                    onClicked: inputContext.softwareInputPanelEvent = "Backspace"
                }
            }
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
