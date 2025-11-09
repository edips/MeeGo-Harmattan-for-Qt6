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
    property string size: "medium"
    property int period: 1000

    property int numberOfFrames: 10

    __invertedString: inverted? "inverted" : "" // The spinner frames do not follow the common inverted file naming :(

    property url spinnerFrames: "qrc:/images/spinner"+__invertedString
}
