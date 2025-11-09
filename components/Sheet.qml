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
import meego
import com.meego.components 1.0

MouseArea {
    id: root

    width: parent ? parent.width : 0
    height: parent ? parent.height : 0

    property alias title: header.children
    default property alias content: contentField.data
    property alias buttons: header.children
    property Item visualParent
    property int status: DialogStatus.Closed

    property alias acceptButtonText: acceptButton.text
    property alias rejectButtonText: rejectButton.text

    property alias acceptButton: acceptButton
    property alias rejectButton: rejectButton

    property alias acceptButtonEnabled: acceptButton.enabled
    property alias rejectButtonEnabled: rejectButton.enabled

    signal accepted
    signal rejected

    property QtObject platformStyle: SheetStyle {}

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    function reject() {
        close();
        rejected();
    }

    function accept() {
        close();
        accepted();
    }

    function __goBack() {
        // This function will be called by the animation when it's safe to navigate.
        if (parent && typeof parent.goBack === 'function') {
            parent.goBack();
        }
    }

    visible: status !== DialogStatus.Closed;

    function open() {
        parent = visualParent || __findParent();
        sheet.state = "";
        root.focus = true; // Explicitly set focus when opening
    }

    function close() {
        sheet.state = "closed";
        root.focus = false; // Explicitly remove focus when closing
    }

    function __findParent() {
        var next = parent;
        while (next && next.parent
               && next.objectName != "appWindowContent"
               && next.objectName != "windowContent") {
            next = next.parent;
        }
        return next;
    }

    function getButton(name) {
        for (var i=0; i<buttons.length; ++i) {
            if (buttons[i].objectName === name)
                return buttons[i];
        }
        return undefined;
    }
    // Close the dialog with back button
    // Back key handling
    // Focus is now explicitly managed by open() and close() functions
    // onStatusChanged is no longer solely responsible for setting focus, but still updates GlobalSettings
    onStatusChanged: {
        if(root.status !== DialogStatus.Closed) {
            GlobalSettings.sheetFocus = true;
        } else {
            GlobalSettings.sheetFocus = false;
        }
    }

    // This handler is critical for intercepting the back button.
    Keys.onReleased: (event) => {
        // Only handle the Back key if the sheet is currently visible.
        if (event.key === Qt.Key_Back && root.visible) {
            event.accepted = true; // *** CRITICAL: IMMEDIATELY accept the event to prevent propagation ***
            sheet.state = "closed"; // Start the closing animation, but don't navigate yet.
        }
    }
    Item {
        id: sheet
        //when the sheet is part of a page do nothing
        //when the sheet is a direct child of a PageStackWindow, consider the status bar
        /*property int statusBarOffset: (parent.objectName != "windowContent") ? 0
                                     : (typeof __statusBarHeight == "undefined") ? 0
                                     : __statusBarHeight*/
        width: parent.width
        height: parent.height //- statusBarOffset

        //y: statusBarOffset

        //clip: true

        property int transitionDurationIn: 300
        property int transitionDurationOut: 450

        state: "closed"

        function transitionStarted() {
            status = (state == "closed") ? DialogStatus.Closing : DialogStatus.Opening;
        }

        function transitionEnded() {
            status = (state == "closed") ? DialogStatus.Closed : DialogStatus.Open;
        }

        states: [
            // Closed state.
            State {
                name: "closed"
                // consider input panel height when input panel is open
                PropertyChanges { target: sheet; y: !inputContext.softwareInputPanelVisible
                                                 ? height : inputContext.softwareInputPanelRect.height + height; }
            }
        ]

        transitions: [
            // Transition between open and closed states.
            Transition {
                from: ""; to: "closed"; reversible: false
                SequentialAnimation {
                    ScriptAction { script: if (sheet.state == "closed") { sheet.transitionStarted(); } else { sheet.transitionEnded(); } }
                    PropertyAnimation { properties: "y"; easing.type: Easing.InOutQuint; duration: sheet.transitionDurationOut }
                    ScriptAction { script: if (sheet.state == "closed") { sheet.transitionEnded(); } else { sheet.transitionStarted(); } }
                    ScriptAction { script: if (sheet.state == "closed") { __goBack(); } }
                }
            },
            Transition {
                from: "closed"; to: ""; reversible: false
                SequentialAnimation {
                    ScriptAction { script: if (sheet.state == "") { sheet.transitionStarted(); } else { sheet.transitionEnded(); } }
                    PropertyAnimation { properties: "y"; easing.type: Easing.OutQuint; duration: sheet.transitionDurationIn }
                    ScriptAction { script: if (sheet.state == "") { sheet.transitionEnded(); } else { sheet.transitionStarted(); } }
                }
            }
        ]

        BorderImage {
            id: contentField
            source: platformStyle.background
            width: parent.width
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
        }

        BorderImage {
            id: header
            width: parent.width
            border {
                left: platformStyle.headerBackgroundMarginLeft
                right: platformStyle.headerBackgroundMarginRight
                top: platformStyle.headerBackgroundMarginTop
                bottom: platformStyle.headerBackgroundMarginBottom
            }
            source: platformStyle.headerBackground

            SheetButton {
                id: rejectButton
                objectName: "rejectButton"
                anchors.left: parent.left
                anchors.leftMargin: root.platformStyle.rejectButtonLeftMargin
                anchors.verticalCenter: parent.verticalCenter
                visible: text != ""
                onClicked: close()
            }
            SheetButton {
                id: acceptButton
                objectName: "acceptButton"
                anchors.right: parent.right
                anchors.rightMargin: root.platformStyle.acceptButtonRightMargin
                anchors.verticalCenter: parent.verticalCenter
                platformStyle: SheetButtonAccentStyle { }
                visible: text != ""
                onClicked: close()
            }
            /*Component.onCompleted: {
                acceptButton.clicked.connect(accepted)
                rejectButton.clicked.connect(rejected)
            }*/
        }
    }
}
