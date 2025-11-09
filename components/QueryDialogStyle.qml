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

DialogStyle {
    property string titleFontFamily: UI.FONT_FAMILY
    property int titleFontPixelSize: UI.FONT_XLARGE
    property int titleFontCapitalization: Font.MixedCase
    property bool titleFontBold: true
    property color titleTextColor: "white"
    property int contentFieldMinSize: 24
    //spacing
    property int contentTopMargin: 21
    property int buttonTopMargin: 38
    property int titleColumnSpacing: 17
    property string messageFontFamily: UI.FONT_FAMILY
    property int messageFontPixelSize: UI.FONT_DEFAULT
    property color messageTextColor: "#ffffff"
    // fader properties
    property double dim: 0.9
    property int fadeInDuration: 250 // ms
    property int fadeOutDuration: 250 // ms
    property int fadeInDelay: 0 // ms
    property int fadeOutDelay: 100 // ms
    //properties inherited by DialogStyle
    buttonsColumnSpacing: 16
    leftMargin: 33
    rightMargin: 33
}
