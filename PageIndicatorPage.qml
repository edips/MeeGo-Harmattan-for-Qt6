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
import com.meego.components 1.0
import "components/"
import "components/UIConstants.js" as UiConstants
Page {
    id: container
    anchors.margins: UiConstants.DefaultMargin
    tools: commonTools

    Column {
        id: controls
        x: 350

        Button {
            id: nextButton
            text: "Next page"
            onClicked: { indicator.currentPage++ }
        }
        Button {
            id: previousButton
            text: "Previous page"
            onClicked: { indicator.currentPage-- }
        }
        Button {
            id: addTotal
            text: "Increase total pages"
            onClicked: { indicator.totalPages++ }
        }
        Button {
            id: removeTotal
            text: "Decrease total pages"
            onClicked: { indicator.totalPages-- }
        }
        Button {
            id: negativeButton
            text: "Inverted visual"
            onClicked: { theme.inverted = true }
        }
        Button {
            id: positiveButton
            text: "Normal visual"
            onClicked: { theme.inverted = false }
        }
    }

    Item {
        id: r1

        width: 200
        height: 50

        x: 100;
        y: 100;

        PageIndicator {
            id: indicator
            objectName: "pageIndicatorObject"
            currentPage: 2
            totalPages: 3
        }
    }

}
