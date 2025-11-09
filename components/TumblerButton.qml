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
import "constants.js" as UI

/*
   Class: TumblerButton
   button component that has a label and has click event handling.

   A button is a component that accepts user input and send a clicked() signal for
   the application to handle. The button has resizable properties, event
   handling, and can undergo state changes and transitions.

   The TumblerButton has a fixed width. Longer text will be elided.
   To avoid that for longer texts please set the implicitWidth explicitly.

   <code>
       // Create a button with different icon states:
       // This approach works for all supported states: normal, disabled, pressed, selected, selected && disabled
       TumblerButton {
           text: "Tumbler Button"
       }
   </code>
*/
Item {
    id: tumblerbutton

    property Style platformStyle: LabelStyle{}

    /*
     * Property: text
     * [string] The text displayed on button.
     */
    property string text: "Get Value"

    /*
     * Property: pressed
     * [bool] (ReadOnly) Is true when the button is pressed
     */
    property alias pressed: mouse.pressed

    property QtObject style: TumblerButtonStyle{}

    /*
     * Event: clicked
     * Is emitted after the button is released
     */
    signal clicked

    height: UI.SIZE_BUTTON
    width: UI.WIDTH_TUMBLER_BUTTON // fixed width to prevent jumping size after selecting value from tumbler

    BorderImage {
        border { top: 0; bottom: 0;
            left: 25; right: 25 }
        anchors.fill: parent
        source: mouse.pressed ?
                tumblerbutton.style.pressedBackground : tumblerbutton.enabled ?
                    tumblerbutton.style.background : tumblerbutton.style.disabledBackground;
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        enabled: parent.enabled
        onClicked: {
            parent.clicked()
        }
    }

    Image {
        id: icon

        anchors { right: (label.text != "") ? parent.right : undefined;
            rightMargin: UI.INDENT_DEFAULT;
            horizontalCenter: (label.text != "") ? undefined : parent.horizontalCenter;
            verticalCenter: parent.verticalCenter;
        }
        height: sourceSize.height
        width: sourceSize.width
        source: "qrc:/images/meegotouch-combobox-indicator" +(tumblerbutton.enabled ? "" : "-disabled") + (mouse.pressed ? "-pressed" : "") + ".png"
        //(tumblerbutton.style.inverted ? "-inverted" : "") +(tumblerbutton.enabled ? "" : "-disabled") + (mouse.pressed ? "-pressed" : "")
    }

    Text {
        id: label

        anchors { left: parent.left; right: icon.left;
            leftMargin: UI.INDENT_DEFAULT; rightMargin: UI.INDENT_DEFAULT;
            verticalCenter: parent.verticalCenter }
        font { family: platformStyle.fontFamily; pixelSize: platformStyle.fontPixelSize;
            bold: UI.FONT_BOLD_BUTTON; capitalization: tumblerbutton.style.fontCapitalization }
        text: tumblerbutton.text
        color: (mouse.pressed) ?
            tumblerbutton.style.pressedTextColor :
                (tumblerbutton.enabled) ?
                    tumblerbutton.style.textColor : tumblerbutton.style.disabledTextColor ;
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
    }
}
