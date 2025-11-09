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
    width: parent.width
    height: 0

    objectName: "softwareInputPanel"

    property bool active: false

    states: State {
        when: active
        PropertyChanges { target: root; height: childrenRect.height; }
    }

    transitions: Transition {
        reversible: true
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutCubic; duration: 200 }
    }
}
