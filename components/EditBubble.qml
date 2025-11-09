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
import "Utils.js" as Utils
import "EditBubble.js" as Private
import "UIConstants.js" as UI // Ensure this imports UIConstants.js

Item {
    id: bubble
    property Item textInput: null
    property bool valid: rect.canCut || rect.canCopy || rect.canPaste || rect.canSelectAll
    property alias privateRect: rect
    property Style platformStyle: EditBubbleStyle {}
    property variant position: Qt.point(0,0)
    anchors.fill: parent
    Flickable {
        id: rect
        property int positionOffset: 40;
        property int arrowOffset: 0
        property int arrowBorder: platformStyle.arrowMargin
        property bool arrowDown: true
        property bool changingText: false
        property bool pastingText: false
        property bool validInput: textInput != null
        property bool canCut: rect.canCopy && !textInput.readOnly
        // TextEdit will have echoMode == null
        property bool canCopy: textSelected && (textInput.echoMode === undefined || textInput.echoMode === TextInput.Normal)
        property bool canPaste: validInput && (textInput.canPaste && !textInput.readOnly)
        property bool textSelected: validInput && (textInput.selectedText !== "")
        property bool canSelectAll: textSelected && textInput.selectedText.length < textInput.text.length
        property bool opened: false
        property bool outOfView: false
        property Item bannerInstance: null

        flickableDirection: Flickable.HorizontalAndVerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        visible: opened && !outOfView
        width: row.width
        height: row.height
        z: 1020
        onPositionOffsetChanged: if (rect.visible) Private.adjustPosition(bubble)
        onWidthChanged: if (rect.visible) Private.adjustPosition(bubble)
        onHeightChanged: if (rect.visible) Private.adjustPosition(bubble)
        onVisibleChanged: {
            if (visible === true) {
                autoHideoutTimer.running = true
                Private.adjustPosition(bubble)
            } else if (autoHideoutTimer.running === true) {
                autoHideoutTimer.running = false
            }
        }

        BasicRow {
            id: row
            Component.onCompleted: Private.updateButtons(row);
            EditBubbleButton {
                id: buttonCut
                objectName: "cutButton";
                text: "cut" //textTranslator.translate("qtn_comm_cut");
                visible: rect.canCut
                onClicked: {
                    rect.changingText = true;
                    textInput.cut();
                    rect.changingText = false;
                    Private.closePopup(bubble);
                }
                onVisibleChanged: Private.updateButtons(row);
            }

            EditBubbleButton {
                id: buttonCopy
                objectName: "copyButton";
                text: "copy" //textTranslator.translate("qtn_comm_copy");
                visible: rect.canCopy
                onClicked: {
                    textInput.copy();
                    Private.closePopup(bubble);
                }
                onVisibleChanged: Private.updateButtons(row);
            }

            EditBubbleButton {
                id: buttonPaste
                objectName: "pasteButton";
                text: "paste" //textTranslator.translate("qtn_comm_paste");
                visible: rect.canPaste
                onClicked: {
                    rect.changingText = true;
                    if (textInput.inputMethodComposing) {
                        //var cursorAdjust = textInput.preedit.length - textInput.preeditCursorPosition;
                        inputContext.reset();
                        //textInput.cursorPosition -= cursorAdjust;
                    }
                    rect.pastingText = true;
                    var text = textInput.text;
                    textInput.paste();
                    // PastingText is set to false and clipboard is cleared if we catch onTextChanged
                    if (rect.pastingText && textInput && text === textInput.text) {
                        if (rect.bannerInstance === null) {
                            // create new notification banner
                            var root = Utils.findRootItemNotificationBanner(textInput);
                            rect.bannerInstance = notificationBanner.createObject(root);
                        }
                        rect.bannerInstance.show();
                        rect.bannerInstance.timerEnabled = true;
                        rect.pastingText = false;
                    }
                    rect.changingText = false;
                    Private.closePopup(bubble);
                }
                onVisibleChanged: Private.updateButtons(row);
            }
            EditBubbleButton {
                id: buttonSelectAll
                objectName: "selectAllButton"
                text: "select all"
                visible: rect.canSelectAll
                onClicked: {
                    textInput.selectAll()
                }
                onVisibleChanged: Private.updateButtons(row)
            }
            Component {
                id : notificationBanner
                NotificationBanner{
                    id: errorBannerPrivate
                    // Assuming textTranslator is globally available
                    text: "cantpaste"//textTranslator.translate("qtn_comm_cantpaste");
                    timerShowTime: 5*1000
                    topMargin: 8
                    leftMargin: 8
                }
            }
        }

        Image {
            id: bottomTailBackground
            source: platformStyle.bottomTailBackground
            visible: rect.arrowDown && bubble.valid
            anchors.bottom: row.bottom
            anchors.horizontalCenter: row.horizontalCenter
            anchors.horizontalCenterOffset: rect.arrowOffset
        }

        Image {
            id: topTailBackground
            source: platformStyle.topTailBackground
            visible: !rect.arrowDown && bubble.valid
            anchors.bottom: row.top
            anchors.bottomMargin: -platformStyle.backgroundMarginBottom - 2
            anchors.horizontalCenter: row.horizontalCenter
            anchors.horizontalCenterOffset: rect.arrowOffset
        }
    }

    Timer {
        id: autoHideoutTimer
        interval: 5000
        onTriggered: {
            running = false
            state = "hidden"
        }
    }
    state: "closed"
    states: [
        State {
            name: "opened"
            ParentChange { target: rect; parent: Utils.findRootItem(textInput); }
            PropertyChanges { target: rect; opened: true; opacity: 1.0 }
        },
        State {
            name: "hidden"
            ParentChange { target: rect; parent: Utils.findRootItem(textInput); }
            PropertyChanges { target: rect; opened: true; opacity: 0.0; }
        },
        State {
            name: "closed"
            ParentChange { target: rect; parent: bubble; }
            PropertyChanges { target: rect; opened: false; }
        }
    ]
    transitions: [
        Transition {
            from: "opened"; to: "hidden";
            reversible: false
            SequentialAnimation {
                NumberAnimation {
                    target: rect
                    properties: "opacity"
                    duration: 1000
                }
                ScriptAction {
                    script: {
                        Private.closePopup(bubble);
                    }
                }
            }
        }
    ]
    Connections {
        target: Utils.findFlickable(textInput)
        function onContentYChanged() {
            if (rect.visible)
                Private.adjustPosition(bubble);
            rect.outOfView = ( ( rect.arrowDown === false // reduce flicker due to changing bubble orientation
                  && Private.geometry().top < 0 )
                  || Private.geometry().bottom > screen.platformHeight - Utils.toolBarCoveredHeight ( bubble ) );
        }
    }
    Connections {
        target: screen
        function onCurrentOrientationChanged() {
            if (rect.visible)
                Private.adjustPosition(bubble);
            rect.outOfView = ( ( rect.arrowDown === false // reduce flicker due to changing bubble orientation
                  && Private.geometry().top < 0 )
                  || Private.geometry().bottom > screen.platformHeight - Utils.toolBarCoveredHeight ( bubble ) );
        }
    }
    function findWindowRoot() {
        var item = Utils.findRootItem(bubble, "windowRoot");
        if (item.objectName !== "windowRoot")
            item = Utils.findRootItem(bubble, "pageStackWindow");
        return item;
    }
    Connections {
       target: findWindowRoot();
       ignoreUnknownSignals: true
       function onOrientationChangeFinished() {
           Private.adjustPosition(bubble);
           rect.outOfView = ( ( rect.arrowDown === false
                 && Private.geometry().top < 0 )
                 || Private.geometry().bottom > screen.platformHeight - Utils.toolBarCoveredHeight ( bubble ) );
       }
    }
}

