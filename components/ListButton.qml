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
import "UIConstants.js" as UI

Item {
    id: button

    // --- YOUR ORIGINAL PROPERTIES (Unchanged) ---
    property bool checked: false
    property bool checkable: false
    property alias pressed: mouseArea.pressed
    property alias text: label.text
    property url iconSource
    signal clicked
    property string __buttonType
    property Style platformStyle: ButtonStyle {}
    property alias style: button.platformStyle
    property alias font: label.font

    // --- SIZING UPDATED TO MATERIAL GUIDELINES ---
    // These now use the standard Material values.
    property int padding_xlarge: UI.LIST_ITEM_PADDING_HORIZONTAL // 16dp
    property int button_label_marging: UI.BUTTON_ICON_TEXT_SPACING // 8dp
    property int size_icon_default: UI.LIST_ICON_SIZE // 24dp

    implicitWidth: iconAndLabel.prefferedWidth
    implicitHeight: UI.BUTTON_HEIGHT // 48dp

    BorderImage {
        id: background
        anchors.fill: parent

        border { left: button.platformStyle.backgroundMarginLeft; top: button.platformStyle.backgroundMarginTop;
                 right: button.platformStyle.backgroundMarginRight; bottom: button.platformStyle.backgroundMarginBottom }
        source: !enabled ?
                    (checked ? button.platformStyle.checkedDisabledBackground : button.platformStyle.disabledBackground) :
                    pressed ?
                        button.platformStyle.pressedBackground :
                    checked ?
                        button.platformStyle.checkedBackground :
                        button.platformStyle.background;
    }

    // --- LAYOUT (Logic Unchanged, uses updated sizing properties) ---
    Item {
        id: iconAndLabel
        property real xMargins: icon.visible ? (padding_xlarge + button_label_marging + padding_xlarge) : (padding_xlarge * 2)
        property real prefferedWidth: xMargins + (icon.visible ? icon.width : 0) + (label.visible ? label.prefferedSize.width : 0)

        width: xMargins + (icon.visible ? icon.width : 0) + (label.visible? label.width : 0)
        height: button.implicitHeight

        anchors.verticalCenter: button.verticalCenter
        anchors.horizontalCenter: button.horizontalCenter
        anchors.verticalCenterOffset: -1

        Image {
            id: icon
            source: button.iconSource
            x: padding_xlarge
            anchors.verticalCenter: iconAndLabel.verticalCenter
            width: size_icon_default // Uses updated 24dp
            height: size_icon_default // Uses updated 24dp
            visible: source.toString() !== ""
            fillMode: Image.PreserveAspectFit
        }

        Label {
            id: label
            x: icon.visible ? (icon.x + icon.width + button_label_marging) : padding_xlarge
            anchors.verticalCenter: iconAndLabel.verticalCenter
            anchors.verticalCenterOffset: 1

            property real availableWidth: button.width - iconAndLabel.xMargins - (icon.visible ? icon.width : 0)
            width: Math.min(prefferedSize.width, availableWidth)

            elide: Text.ElideRight
            font.family: button.platformStyle.fontFamily
            font.weight: Font.Normal // Material titles are typically normal weight
            // --- FONT SIZE UPDATED ---
            font.pixelSize: UI.LIST_TITLE_FONT_SIZE // Uses 16sp from constants
            font.capitalization: button.platformStyle.fontCapitalization
            color: !enabled ? button.platformStyle.disabledTextColor :
                     pressed ? button.platformStyle.pressedTextColor :
                     checked ? button.platformStyle.checkedTextColor :
                                 button.platformStyle.textColor;
            text: ""
            visible: text != ""

            // --- YOUR PREFERRED SIZE LOGIC (Unchanged) ---
            Label {
                id: prefferedSize
                font: parent.font
                text: parent.text
                visible: false
            }
            property alias prefferedSize: prefferedSize
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: {
            if (button.checkable)
                button.checked = !button.checked;
            button.clicked();
        }
    }
}
