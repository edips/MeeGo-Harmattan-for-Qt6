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

import QtQuick 2.1

import "UIConstants.js" as UI
import "Utils.js" as Utils

// ### Display Entered / Exited! Pause animation when not "on display".
// ### LayoutDirection

Item {
    id: root

    property bool running: false

    property Style platformStyle: BusyIndicatorStyle{}

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    // --- SIZING REVERTED TO PREVENT CRASH ---
    // The application's resources (QRC) only contain spinner images for specific sizes
    // (e.g., "spinner_32_1.png"). Using other sizes like 48px or 64px will cause a
    // "Cannot open" error because the corresponding image files are missing.
    // This has been reverted to the original, stable values.
    implicitWidth: platformStyle.size === "small" ? 24 : platformStyle.size === "medium" ? 32 : 96
    implicitHeight: implicitWidth

    QtObject {
        id: internal
        property Flickable flick
        property bool offScreen: false
    }

    Image {
        id: spinner
        anchors.fill: parent // Ensure spinner fills the item size
        property int index: 1
        // This is re-evaluated for each frame. Could be optimized by calculating the sources separately is js
        source: root.platformStyle.spinnerFrames + "_" + root.implicitWidth + "_" + index
        smooth: true

        NumberAnimation on index {
            from: 1; to: root.platformStyle.numberOfFrames
            duration: root.platformStyle.period
            running: root.running && root.visible && Qt.application.active && !internal.offScreen
            loops: Animation.Infinite
        }
    }

    Connections {
        target: internal.flick

        onMovementStarted: internal.offScreen = false

        onMovementEnded: {
            var pos = mapToItem(internal.flick, 0, 0)
            internal.offScreen = (pos.y + root.height <= 0) || (pos.y >= internal.flick.height) || (pos.x + root.width <= 0) || (pos.x >= internal.flick.width)
        }
    }

    Component.onCompleted: {
        var flick = Utils.findFlickable()
        if (flick)
            internal.flick = flick
    }
}

