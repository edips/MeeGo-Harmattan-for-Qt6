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

MenuStyle {
     id: root
     property string titleFontFamily: UI.DefaultFontFamily
     property int titleFontPixelSize: UI.FONT_SMALL
     property int titleFontCapitalization: Font.MixedCase
     property color titleTextColor: "white"

     property int titleBarHeight: 56

     // fader properties
     property double dim: 0.9
     property int fadeInDuration: 250 // ms
     property int fadeOutDuration: 350 // ms
     property int fadeInDelay: 0 // ms
     property int fadeOutDelay: 0 // ms
     property int fadeInEasingType:  Easing.OutQuint
     property int fadeOutEasingType: Easing.InOutQuint
     property string faderBackground: "qrc:/images/meegotouch-menu-dimmer.png"
}
