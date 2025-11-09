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
import "."
import "UIConstants.js" as UI
import com.meego.components 1.0

Style {
    // Background
    property url background: "qrc:/images/meegotouch-toolbar-" +
                             (orientation.orientation == "Portrait" ? "portrait" : "landscape") +
                             "-background.png"

    property int visibilityTransitionDuration: 250
    property int contentTransitionDuration: 400

    // 1. Use the Connections element to explicitly target the C++ 'orientation' object
    Connections {
        // The 'target' property points to the C++ object exposed via setContextProperty
        target: orientation // This refers to the 'orientationMonitor' from main.cpp

        // 2. Define the signal handler using the 'on' prefix and the signal name
        function onOrientationChanged() {
            // This code block will execute whenever orientation.orientationChanged() signal is emitted
            console.log("QML: Orientation changed to:", orientation.orientation);
        }
    }


}
