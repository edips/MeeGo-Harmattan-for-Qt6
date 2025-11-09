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

/*
    Class: InfoBanner
    The InfoBanner component is used to display information to the user. The number of lines of text
    shouldn't exceed 3.
*/

Item {
    id: root
    visible: false

    // --- YOUR ORIGINAL PROPERTIES (Unchanged) ---
    property url iconSource: ""
    property alias text: text.text
    property bool timerEnabled: true
    property alias timerShowTime: sysBannerTimer.interval
    property int topMargin: 8
    y: topMargin
    property int leftMargin: 8
    x: leftMargin

    // --- YOUR ORIGINAL FUNCTIONS (Unchanged) ---
    function show() {
        root.visible = true
        animationShow.running = true;
        if (root.timerEnabled)
            sysBannerTimer.restart();
    }
    function hide() {
        animationHide.running = true;
    }

    // --- SIZING UPDATED FOR MATERIAL DESIGN ---
    // The height is now determined by the content, with a minimum standard height.
    implicitHeight: Math.max(48, contentRow.implicitHeight)
    implicitWidth: parent.width - (leftMargin * 2)
    scale: 0

    BorderImage {
        source: "qrc:images/meegotouch-notification-system-background.png"
        anchors.fill: root
        border { left: 10; top: 10; right: 10; bottom: 10 }
        // Opacity can be controlled from a style file if needed
    }

    // A Row is used for a simpler, more stable declarative layout.
    Row {
        id: contentRow
        anchors.fill: parent
        // ✅ PADDING: Standard 16dp horizontal padding.
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        // ✅ SPACING: Standard 16dp gap between icon and text.
        spacing: 16

        Image {
            id: image
            anchors.verticalCenter: parent.verticalCenter
            source: root.iconSource
            visible: root.iconSource !== ""
            // ✅ SIZING: Standard 24x24dp icon size.
            width: 24
            height: 24
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: text
            // The text now fills the available space in the Row.
            width: root.width - (parent.anchors.leftMargin + parent.anchors.rightMargin + parent.spacing + image.width)
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            wrapMode: Text.Wrap
            // ✅ FONT SIZE: Standard 14sp font size for snackbars/banners.
            font.pixelSize: 14
            maximumLineCount: 3
            elide: Text.ElideRight
        }
    }

    // This QtObject is kept for the animation logic, but layout functions are removed.
    QtObject {
        id: internal
        function getScaleValue() {
            return root.x * 2 / root.width + 1;
        }
    }

    // --- YOUR ORIGINAL TIMER AND MOUSEAREA (Unchanged) ---
    Timer {
        id: sysBannerTimer
        repeat: false
        running: false
        interval: 3000
        onTriggered: hide()
    }
    MouseArea {
        id: mouseInfo
        anchors.fill: parent
        onClicked: hide()
        enabled: root.visible
    }

    // --- YOUR ORIGINAL ANIMATIONS (Unchanged) ---
    SequentialAnimation {
        id: animationShow
        NumberAnimation {
            target: root
            property: "scale"
            from: 0
            to: internal.getScaleValue()
            duration: 200
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            target: root
            property: "scale"
            from: internal.getScaleValue()
            to: 1
            duration: 200
        }
    }
    NumberAnimation {
        id: animationHide
        target: root
        property: "scale"
        to: 0
        duration: 200
        easing.type: Easing.InExpo
        onFinished: {
            root.visible = false
        }
    }
}
