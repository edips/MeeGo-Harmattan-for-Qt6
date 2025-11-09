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

import "Utils.js" as Utils


Item {
    id: container

    property alias minimumValue: progressModel.minimumValue
    property alias maximumValue: progressModel.maximumValue
    property alias value: progressModel.value
    property bool indeterminate: false

    property Style platformStyle: ProgressBarStyle{}

    implicitWidth: platformStyle.sizeButton
    implicitHeight: background.height

    QtObject {
        id: internal
        property Flickable flick
        property bool offScreen: false
    }

    BorderImage {
        id: background
        width: parent.width
        height: 6
        horizontalTileMode: BorderImage.Repeat
        source: platformStyle.barBackground

        border {
            left: 6
            top: 4
            right: 6
            bottom: 4
        }
    }

    MaskedItem {
        id: foreground
        width: parent.width
        height: parent.height

        mask: BorderImage {
            width: indeterminate ? container.width : progressModel.position
            height: foreground.height
            source: platformStyle.barMask

            border {
                left: 4
                top: 4
                right: 4
                bottom: 4
            }
        }

        Image {
            id: texture
            // Corrected width: For determinate, the Image's visual width should match progressModel.position.
            // For indeterminate, it needs to be wide enough for the animation.
            width: indeterminate ? (foreground.width + sourceSize.width + 25) : progressModel.position
            height: foreground.height
            fillMode: Image.Tile

            property real xTemp: 0

            source: indeterminate ? platformStyle.unknownTexture : platformStyle.knownTexture

            onXTempChanged: {
                texture.x = Math.round(texture.xTemp) * 4;
            }

            NumberAnimation on xTemp {
                running: indeterminate && container.visible && Qt.application.active && !internal.offScreen
                loops: Animation.Infinite
                from: -texture.sourceSize.width
                to: 0
                duration: (1000 * texture.sourceSize.width / 10)
            }
        }
    }

    RangeModel {
        id: progressModel
        positionAtMinimum: 0
        positionAtMaximum: background.width

        minimumValue: 0
        maximumValue: 1.0
    }

    Connections {
        target: internal.flick

        onMovementStarted: internal.offScreen = false

        onMovementEnded: {
            var pos = mapToItem(internal.flick, 0, 0)
            internal.offScreen = (pos.y + container.height <= 0) || (pos.y >= internal.flick.height) || (pos.x + container.width <= 0) || (pos.x >= internal.flick.width)
        }
    }

    Component.onCompleted: {
        console.log("height of progress bar: ", background.height)
        var flick = Utils.findFlickable()
        if (flick)
            internal.flick = flick
    }
}
