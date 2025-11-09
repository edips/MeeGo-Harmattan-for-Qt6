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
    property int acceptButtonRightMargin: 15
    property int rejectButtonLeftMargin: 15
    
    property url background: "qrc:/images/meegotouch-applicationpage-background" + __invertedString + ".png";
    property url headerBackground: "qrc:/images/meegotouch-sheet-header" + __invertedString + "-background" + ".png";
    
    property int headerBackgroundMarginLeft: 10
    property int headerBackgroundMarginRight: 10
    property int headerBackgroundMarginTop: 10
    property int headerBackgroundMarginBottom: 2
}
