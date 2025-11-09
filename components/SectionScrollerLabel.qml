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

Item {
    id: root

    property alias text: label.current
    property alias up: label.up
    property bool highlighted: false

    width: wrapper.width
    height: wrapper.height

    property Style platformStyle: SectionScrollerStyle {}

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    Item {
        id: wrapper

        clip: true
        height: label.height

        Text {
            id: label

            property string current: ""
            property bool up: true
            property int shift: 30

            height: 60
            width: parent.width - 40
            text: ""
            x: 20
            color: root.highlighted ? root.platformStyle.textColorHighlighted : root.platformStyle.textColor
            font {
                bold: root.platformStyle.fontBoldProperty
                pixelSize: root.platformStyle.fontPixelSize
            }
            verticalAlignment: Text.AlignVCenter
            onCurrentChanged: {
                text = current;
            }
            onTextChanged: {
                var w = paintedWidth
                parent.width = w + 40;
            }

            Behavior on current {
                SequentialAnimation {
                    NumberAnimation { target: label; property: "y"; to: label.up ? label.shift : -label.shift; duration: 50 }
                    PropertyAction { target: label; property: "y"; value: label.up ? -label.shift : label.shift }
                    NumberAnimation { target: label; property: "y"; to: 0; duration: 50 }
                }
            }
        }
    }
}
