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

Style {
    // Mouse
    property real mouseMarginLeft: 6
    property real mouseMarginTop: 8
    property real mouseMarginRight: 6
    property real mouseMarginBottom: 10

    // Background
    property int backgroundMarginLeft: 0
    property int backgroundMarginTop: 0
    property int backgroundMarginRight: 0
    property int backgroundMarginBottom: 14 // XXX: need to crop images

    property int arrowMargin: 16 // XXX: need to crop images

    // Images
    property url topTailBackground: "qrc:/images/meegotouch-text-editor-top-tail.png"
    property url bottomTailBackground: "qrc:/images/meegotouch-text-editor-bottom-tail.png"
}
