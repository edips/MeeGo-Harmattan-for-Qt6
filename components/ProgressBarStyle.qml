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
    property int sizeButton: UI.SIZE_BUTTON

    // Images
    property url barBackground: "qrc:/images/meegotouch-progressindicator"+__invertedString+"-bar-background" + ".png"
    //property url barMask: "qrc:/images/meegotouch-progressindicator"+__invertedString+"-bar-mask" + ".png"
    property url barMask: "qrc:/images/meegotouch-progressindicator-bar-mask.png"
    property url unknownTexture: "qrc:/images/" + __colorString + "meegotouch-progressindicator"+__invertedString+"-bar-unknown-texture" + ".png"
    property url knownTexture: "qrc:/images/" + __colorString + "meegotouch-progressindicator"+__invertedString+"-bar-known-texture" + ".png"
}
