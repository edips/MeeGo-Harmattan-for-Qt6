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
/*
   Class: MoreIndicator
   Component to indicate that more content is available for the user.

   A more indicator is a component that displayes an arrow to show the user that there are more contents
   available.
*/

Image {
    source: "qrc:/images/icon-m-common-drilldown-arrow.png"
    /*!theme.inverted ?
                "qrc:/images/icon-m-common-drilldown-arrow.png" :
                "qrc:/images/icon-m-common-drilldown-arrow-inverse.png"*/
}
