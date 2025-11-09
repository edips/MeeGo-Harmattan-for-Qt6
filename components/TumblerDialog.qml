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
import "constants.js" as C
import "TumblerIndexHelper.js" as IH

/*
   Class: TumblerDialog
   Dialog that shows a tumbler.
*/
Dialog {
    id: root
    // Close the dialog with back button
    Connections {
        target: GlobalSettings
        function onDialogFocusChanged(dialogFocus) {
            close()
        }
    }
    /*
     * Property: titleText
     * [string] If not null, it will be used as the title text for the dialog.
     *          If further customization is needed, use property title instead
     */
    property alias titleText: title.text

    /*
     * Property: items
     * [ListModel] Array of ListModel for each column of the dialog.
     */
    property alias columns: tumbler.columns

    /*
     * Property: acceptButtonText
     * [string] The button text for the accept button.
     */
    property alias acceptButtonText: acceptButton.text

    /*
     * Property: rejectButtonText
     * [string] The button text for the reject button.
     */
    property alias rejectButtonText: rejectButton.text


    // TODO do not dismiss the dialog when empty area is clicked
    style: DialogStyle {
        titleBarHeight: 48
        leftMargin: screen.currentOrientation == Screen.Portrait || screen.currentOrientation == Screen.PortraitInverted ? 16 : 215
        rightMargin: screen.currentOrientation == Screen.Portrait || screen.currentOrientation == Screen.PortraitInverted ? 16 : 215
        centered: true
    }

    LabelStyle{ id: labelStyle }

    title: Text {
        id: title
        objectName: "titleText"
        text: "Tumbler Dialog"
        visible: text.length > 0
        //color: theme.selectionColor
        color: "#0078d7"

        font { pixelSize: 32; family: labelStyle.fontFamily }
        elide: Text.ElideRight
    }
    content: Item {
        height: 300
        width: parent.width
        Tumbler {
            id: tumbler
            height: 300
            privateDelayInit: true
        }
    }
    buttons: Row {
        height: 56
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 6
        Button {
            id: acceptButton
            text: textTranslator.translate("qtn_comm_command_accept");
            onClicked: accept()
            width: (root.width / 2) - 3
            style: ButtonStyle { inverted: true }
            visible: text != ""
        }
        Button {
            id: rejectButton
            text: textTranslator.translate("qtn_comm_cancel");
            onClicked: reject()
            width: (root.width / 2) - 3
            style: ButtonStyle { inverted: true }
            visible: text != ""
        }
    }

    QtObject {
        id: internal
        property bool init: true
    }

    onStatusChanged: {
        if (status === DialogStatus.Opening) {
            tumbler.privateInitialize();

            if (internal.init) {
                IH.saveIndex(tumbler);
                internal.init = false;
            } else {
                // Restore index when dialog was canceled or closed while
                // tumbler was still rotating. Qt sets the index to the last
                // rotated number — restore the previously saved one.
                IH.restoreIndex(tumbler);
            }
        }
    }

    onAccepted: {
        tumbler.privateForceUpdate();
        IH.saveIndex(tumbler);
    }

    onRejected: {
        IH.restoreIndex(tumbler);
    }
}
