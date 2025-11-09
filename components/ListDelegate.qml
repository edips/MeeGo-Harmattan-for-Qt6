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
import "UIConstants.js" as UiConstants


MouseArea {
    id: listItem

    // --- YOUR ORIGINAL PROPERTIES (Unchanged) ---
    // The default values are now set to the Material Design standard.
    property int titleSize: UI.LIST_TITLE_FONT_SIZE
    property int titleWeight: Font.Bold // Material titles are typically normal weight
    property string titleFont: UiConstants.DefaultFontFamily
    property color titleColor: UI.LIST_TITLE_COLOR //theme.inverted ? UI.LIST_TITLE_COLOR_INVERTED : UI.LIST_TITLE_COLOR
    property color titleColorPressed: UI.LIST_TITLE_COLOR_PRESSED // theme.inverted ? UI.LIST_TITLE_COLOR_PRESSED_INVERTED : UI.LIST_TITLE_COLOR_PRESSED

    property int subtitleSize: UI.LIST_SUBTITLE_FONT_SIZE
    property int subtitleWeight: Font.Normal
    property string subtitleFont: UiConstants.DefaultFontFamilyLight
    property color subtitleColor: UI.LIST_SUBTITLE_COLOR //theme.inverted ? UI.LIST_SUBTITLE_COLOR_INVERTED : UI.LIST_SUBTITLE_COLOR
    property color subtitleColorPressed: UI.LIST_SUBTITLE_COLOR_PRESSED //theme.inverted ? UI.LIST_SUBTITLE_COLOR_PRESSED_INVERTED : UI.LIST_SUBTITLE_COLOR_PRESSED

    // --- MODEL DATA (Unchanged) ---
    property string iconSource: model.iconSource ? model.iconSource : ""
    property string titleText: model.title
    property string subtitleText: model.subtitle ? model.subtitle : ""

    // --- TRAILING ICON DATA (Unchanged) ---
    property string iconId
    property bool iconVisible: false

    // --- SIZING UPDATED TO MATERIAL GUIDELINES ---
    height: subtitleText !== "" ? UI.LIST_ITEM_TWO_LINE_HEIGHT : UI.LIST_ITEM_ONE_LINE_HEIGHT
    width: ListView.view ? ListView.view.width : 0

    // --- VISUALS (Logic Unchanged) ---
    BorderImage {
        id: background
        anchors.fill: parent
        anchors.leftMargin: -UI.LIST_ITEM_PADDING_HORIZONTAL
        anchors.rightMargin: -UI.LIST_ITEM_PADDING_HORIZONTAL
        visible: listItem.pressed
        source: "qrc:/images/meegotouch-panel-background-pressed.png"
    }

    // --- LAYOUT (Padding and Spacing Updated) ---
    Row {
        anchors.fill: parent
        anchors.leftMargin: UI.LIST_ITEM_PADDING_HORIZONTAL
        spacing: UI.LIST_ITEM_ICON_TEXT_SPACING

        // --- LEADING ICON (Sizing Updated) ---
        Image {
            anchors.verticalCenter: parent.verticalCenter
            visible: listItem.iconSource ? true : false
            width: UI.LIST_ICON_SIZE
            height: UI.LIST_ICON_SIZE
            source: listItem.iconSource
            fillMode: Image.PreserveAspectFit
        }

        // --- TEXT (Uses your properties, which default to Material sizes) ---
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2 // Small gap between title and subtitle

            Label {
                id: mainText
                text: listItem.titleText
                font.family: listItem.titleFont
                font.weight: listItem.titleWeight
                font.pixelSize: listItem.titleSize // Uses your property
                color: listItem.pressed ? listItem.titleColorPressed : listItem.titleColor
            }

            Label {
                id: subText
                text: listItem.subtitleText
                font.family: listItem.subtitleFont
                font.weight: listItem.subtitleWeight
                font.pixelSize: listItem.subtitleSize // Uses your property
                color: listItem.pressed ? listItem.subtitleColorPressed : listItem.subtitleColor
                visible: text != ""
            }
        }
    }

    // --- TRAILING ICON (Logic Unchanged, Padding Added) ---
    Image {
        function handleIconId() {
            var prefix = "icon-m-"
            if (iconId.indexOf(prefix) !== 0)
                iconId =  prefix.concat(iconId);
            return "qrc:/images/" + iconId + ".png";
        }

        visible: iconVisible
        source: iconId ? handleIconId() : ""
        anchors {
            right: parent.right;
            rightMargin: UI.LIST_ITEM_PADDING_HORIZONTAL
            verticalCenter: parent.verticalCenter;
        }
    }
}

