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
import "Tumbler.js" as Engine
import "constants.js" as C

/*
   Class: Tumbler
   A tumbler.
*/
Item {
    id: root

    /*
     * Property: items
     * [ListModel] Array of ListModel for each column of the dialog.
     */
    property list<Item> columns

    /*
     * Event: changed
     * Is emitted when the value of the tumbler changes.
     */
    signal changed(int index)

    /* private */
    property bool privateDelayInit: false
    property list<Item> privateTemplates

    implicitWidth: C.TUMBLER_WIDTH
    implicitHeight: screen.displayWidth > screen.displayHeight ?
                        C.TUMBLER_HEIGHT_LANDSCAPE :
                        C.TUMBLER_HEIGHT_PORTRAIT

    /* private */
    function privateInitialize() {
        if (!internal.initialized) {
            Engine.initialize();
            internal.initialized = true;
        }
    }

    /* private */
    function privateForceUpdate() {
        Engine.forceUpdate();
    }

    anchors.fill: parent
    clip: true
    Component.onCompleted: {
        if (!privateDelayInit && !internal.initialized) {
            Engine.initialize();
            internal.initialized = true;
        }
    }
    onChanged: {
        if (internal.movementCount == 0)
            Engine.forceUpdate();
    }
    onColumnsChanged: {
        if (internal.initialized) {
            // when new columns are added, the system first removes all
            // the old columns
            internal.initialized = false;
            Engine.clear();
            internal.reInit = true;
        } else if (internal.reInit && columns.length > 0) {
            // timer is used because the new columns are added one by one
            // we only want to act after the last column is added
            internal.reInit = false;
            columnChangedTimer.restart();
        }
    }
    onWidthChanged: {
        Engine.layout();
    }

    QtObject {
        id: internal

        property int movementCount: 0
        property bool initialized: false
        property bool reInit: false
        property bool hasLabel: false

        property Timer timer: Timer {
            id: columnChangedTimer
            interval: 50
            onTriggered: {
                Engine.initialize();
                internal.initialized = true;
            }
        }
    }

    BorderImage {
        width: parent.width
        height: internal.hasLabel ?
                    parent.height - C.TUMBLER_LABEL_HEIGHT : // decrease by bottom text height
                    parent.height
        source: "qrc:/images/meegotouch-list-fullwidth-background-selected" //+ theme.colorString + "meegotouch-list-fullwidth-background-selected"
        anchors.top: parent.top
        border { left: C.TUMBLER_BORDER_MARGIN; top: C.TUMBLER_BORDER_MARGIN; right: C.TUMBLER_BORDER_MARGIN; bottom: C.TUMBLER_BORDER_MARGIN }
    }

    Rectangle {
        width: parent.width
        height: internal.hasLabel ?
                    parent.height - C.TUMBLER_LABEL_HEIGHT - 2 * C.TUMBLER_BORDER_MARGIN : // decrease by bottom text & border height
                    parent.height - 2*C.TUMBLER_BORDER_MARGIN
        color: C.TUMBLER_COLOR
        anchors { top: parent.top; topMargin: C.TUMBLER_BORDER_MARGIN }
    }

    Row {
        id: tumblerRow
        anchors { fill: parent; topMargin: 1 }
    }
}
