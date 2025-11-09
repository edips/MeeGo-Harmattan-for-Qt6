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
import "UIConstants.js" as UiConstants
import com.meego.components 1.0

/*
   Class: CountBubble
   CountBubble component is a flexible shape that holds a number and can be added in lists or
   notification banners for example.
*/

Item {
    id: root

    /*
     * Property: largeSized
     * [bool=false] Use small or large count bubble.
     */
    property bool largeSized: false

    /*
     * Property: value
     * [int=0] Reflects the current value.
     */
    property int value: 0

    implicitWidth: internal.getBubbleWidth()
    implicitHeight: largeSized ? 32:24

    BorderImage {
        source: "qrc:/images/" + "meegotouch-countbubble-background" + ( largeSized ? "-large" : "" ) + ".png"  // + theme.colorString + "meegotouch-countbubble-background"+(largeSized ? "-large":"")
        anchors.fill: parent
        border { left: 10; top: 10; right: 10; bottom: 10 }
    }

    Text {
        id: text
        height: parent.height
        y:1
        color: largeSized ? "#FFFFFF" : "black"
        font.family: UiConstants.DefaultFontFamily
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: largeSized ? 22:18
        text: root.value
    }

    QtObject {
        id: internal

        function getBubbleWidth() {
            if (largeSized) {
                if (root.value < 10)
                    return 32;
                else if (root.value < 100)
                    return 40;
                else if (root.value < 1000)
                    return 52;
                else
                    return text.paintedWidth+19
            } else {
                if (root.value < 10)
                    return 24;
                else if (root.value < 100)
                    return 30;
                else if (root.value < 1000)
                    return 40;
                else
                    return text.paintedWidth+13
            }
        }
    }
}
