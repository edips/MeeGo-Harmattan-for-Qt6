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
//import Qt.labs.components 1.1 as QtComponents

/*
   Class: RatingIndicator
   Component to indicate user specified ratings.

   A rating indicator is a component that shows the rating value within the maximum allowed range according
   to the user's specification.  The user can also specify the display type to select the positive/negative
   visual.  Optionally, the user can also specify a count value that will be displayed next to the images.
*/
Item {
    id: root

    /*
     * Property: maximumValue
     * [double] The maximum rating.  The number should be larger or equal to 0.
     */
    property alias maximumValue: model.maximumValue

    /*
     * Property: ratingValue
     * [double] The rating value.  The number should be larger or equal to 0.
     */
    property alias ratingValue: model.value

    /*
     * Property: count
     * [int] A number to be displayed next to the rating images.  It is usually used to count the number of
     * votes cast. It is only displayed if a number larger or equal to 0 is specified.
     */
    property int count: -1

    /*
     * Property: inverted
     * [string] Specify whether the visual for the rating indicator uses the inverted color.  The value is
     * false for use with a light background and true for use with a dark background.
     */
    property bool inverted: theme.inverted

    implicitHeight: Math.max(background.height, text.paintedHeight);
    implicitWidth: background.width + (count >= 0 ? internal.textSpacing + text.paintedWidth : 0);

    RangeModel {
        id: model
        value: 0.0
        minimumValue: 0.0
        maximumValue: 0.0
    }

    QtObject {
        id: internal

        property int imageWidth: 16
        property int imageHeight: 16
        property int indicatorSpacing: 5  // spacing between images
        property int textSpacing: 8  // spacing between image and text
        property url backgroundImageSource: inverted ?
                                                 "qrc:/images/meegotouch-indicator-rating-inverted-background-star.png" :
                                                 "qrc:/images/meegotouch-indicator-rating-background-star.png"
        property url indicatorImageSource: inverted ?
                                             "qrc:/images/meegotouch-indicator-rating-inverted-star.png" :
                                             "qrc:/images/meegotouch-indicator-rating-star.png"
        property string textColor: inverted ? "#fafafa" : "#505050"
    }

    Image {
        id: background
        width: internal.imageWidth * maximumValue + (Math.max(Math.ceil(maximumValue-1), 0)) * internal.indicatorSpacing;
        height: internal.imageHeight
        anchors.verticalCenter: height < text.paintedHeight ? text.verticalCenter : undefined
        fillMode: Image.Tile
        source: internal.backgroundImageSource

        Image {
            id: indicator
            width: internal.imageWidth * ratingValue + Math.max((Math.ceil(ratingValue) - 1), 0) * internal.indicatorSpacing
            height: internal.imageHeight
            fillMode: Image.Tile
            source: internal.indicatorImageSource
        }
    }

    Text {
        id: text
        visible: count >= 0
        text: "(" + count + ")"
        color: internal.textColor
        font { family: "Nokia Standard Light"; pixelSize: 18 }
        anchors.left: background.right
        anchors.leftMargin: internal.textSpacing
    }
}
