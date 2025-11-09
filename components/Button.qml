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
import "."
import "UIConstants.js" as UI

Item {
    id: button

    //=========================================================================
    // Public API
    //=========================================================================
    property bool checked: false
    property bool checkable: false
    property alias pressed: mouseArea.pressed
    property alias text: label.text
    property url iconSource: ""
    property alias platformMouseAnchors: mouseArea.anchors

    signal clicked

    //=========================================================================
    // Styling API
    //=========================================================================
    property Style platformStyle: ButtonStyle {}

    // Deprecated, TODO remove
    property alias style: button.platformStyle
    property alias font: label.font

    //=========================================================================
    // Sizing and Configuration
    //=========================================================================
    implicitWidth: platformStyle.buttonWidth
    implicitHeight: platformStyle.buttonHeight
    width: implicitWidth

    // This is a critical safeguard. It ensures that no child
    // item (like the text) can ever draw outside the button's boundaries.
    clip: true


    //=========================================================================
    // Private Properties
    //=========================================================================
    property bool __dialogButton: false
    property string __buttonType // Used in ButtonGroup.js


    //=========================================================================
    // UI Implementation
    //=========================================================================
    BorderImage {
        id: background
        anchors.fill: parent
        border {
            left: button.platformStyle.backgroundMarginLeft
            top: button.platformStyle.backgroundMarginTop
            right: button.platformStyle.backgroundMarginRight
            bottom: button.platformStyle.backgroundMarginBottom
        }
        source: __dialogButton ? (pressed ? button.platformStyle.pressedDialog : button.platformStyle.dialog) : !enabled ? (checked ? button.platformStyle.checkedDisabledBackground : button.platformStyle.disabledBackground) : pressed ? button.platformStyle.pressedBackground : checked ? button.platformStyle.checkedBackground : button.platformStyle.background
    }

    // A Row is used to lay out the icon and text horizontally.
    Row {
        id: contentRow
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: ( button.iconSource.toString() !== "" ) ? UI.MARGIN_ICONBUTTON : 0

        // Icon Image
        Image {
            id: iconImage
            source: button.iconSource
            anchors.verticalCenter: parent.verticalCenter
            width: button.iconSource.toString() === "" ? 0 : platformStyle.iconSize
            height: button.iconSource.toString() === "" ? 0 : platformStyle.iconSize
            fillMode: Image.PreserveAspectFit
            visible: button.iconSource.toString() !== ""
        }

        // Text Label
        Text {
            id: label
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

            // This gives the Text element a strict width limit, which is
            // what makes the "elide" property work correctly. It calculates
            // the available space after accounting for icon, spacing, and padding.
            width: button.width - iconImage.width - contentRow.spacing - (8) * 2

            // This conditionally aligns the text. It centers the text if there's no
            // icon, otherwise, it aligns it to the left to sit next to the icon.
            horizontalAlignment: button.iconSource.toString() === "" ? Text.AlignHCenter : Text.AlignLeft

            // Font and color properties
            font.family: button.platformStyle.fontFamily
            font.weight: checked ? button.platformStyle.checkedFontWeight : button.platformStyle.fontWeight
            font.pixelSize: button.platformStyle.fontPixelSize
            font.capitalization: button.platformStyle.fontCapitalization
            color: !enabled ? button.platformStyle.disabledTextColor : pressed ? button.platformStyle.pressedTextColor : checked ? button.platformStyle.checkedTextColor : button.platformStyle.textColor
            text: "" // The text is set via the alias from the root
            visible: text !== ""
        }
    }

    // This MouseArea covers the entire button, making the whole component clickable.
    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: {
            if (button.checkable) {
                button.checked = !button.checked
            }
            button.clicked() // Emit the root signal
        }
    }
}
