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

Style {
    property int minKnobX: 4
    property int maxKnobX: 20

    // Slider
    property url switchOn: "qrc:/images/" + __colorString + "meegotouch-switch-on"+__invertedString + ".png"
    property url switchOff: "qrc:/images/meegotouch-switch-off"+__invertedString + ".png"

    // Knob
    property url thumb: "qrc:/images/meegotouch-switch-thumb"+__invertedString + ".png"
    property url thumbPressed: "qrc:/images/meegotouch-switch-thumb-pressed"+__invertedString + ".png"
    property url thumbDisabled: "qrc:/images/meegotouch-switch-thumb-disabled"+__invertedString + ".png"
    property url shadow: "qrc:/images/meegotouch-switch-shadow"+__invertedString + ".png"

    // Mouse
    property real mouseMarginRight: -UI.MARGIN_XLARGE
    property real mouseMarginLeft: -UI.MARGIN_XLARGE
    property real mouseMarginTop: -UI.MARGIN_XLARGE
    property real mouseMarginBottom: -UI.MARGIN_XLARGE
}
