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
   Class: PageIndicator
   Component to indicate the page user is currently viewing.

   A page indicator is a component that shows the number of availabe pages as well as the page the user is
   currently on.  The user can also specify the display type to select the normal/inverted visual.
*/
Item {
    id: root

    /*
     * Property: totalPages
     * [int] The total number of pages.  This value should be larger than 0.
     */
    property int totalPages: 0

    /*
     * Property: currentPage
     * [int] The current page the user is on.  This value should be larger than 0.
     */
    property int currentPage: 0

    /*
     * Property: inverted
     * [bool] Specify whether the visual for the rating indicator uses the inverted color.  The value is
     * false for use with a light background and true for use with a dark background.
     */
    property bool inverted: false //theme.inverted

    implicitWidth: currentImage.width * totalPages + (totalPages - 1) * internal.spacing
    implicitHeight: currentImage.height

    /* private */
    QtObject {
        id: internal

        property int spacing: 8

        property string totalPagesImageSource: inverted ?
                                                 "qrc:/images/meegotouch-inverted-pageindicator-page.png" :
                                                 "qrc:/images/meegotouch-pageindicator-page.png"
        property string currentPageImageSource: inverted ?
                                                  "qrc:/images/meegotouch-inverted-pageindicator-page-current.png" :
                                                  "qrc:/images/meegotouch-pageindicator-page-current.png"

        property bool init: true


        function updateUI() {

            if(totalPages <=0) {
                totalPages = 1;
                currentPage = 1;
            } else {
                if(currentPage <=0)
                    currentPage = 1;
                if(currentPage > totalPages)
                    currentPage = totalPages;
            }

            frontRepeater.model = currentPage - 1;
            backRepeater.model = totalPages - currentPage;
        }
    }

    Component.onCompleted: {
        internal.updateUI();
        internal.init = false;
    }

    onTotalPagesChanged: {
        if(!internal.init)
            internal.updateUI();
    }

    onCurrentPageChanged: {
        if(!internal.init)
            internal.updateUI();
    }

    Row {
        Repeater {
             id: frontRepeater

             Item {
                 height: currentImage.height
                 width:  currentImage.width + internal.spacing

                 Image {
                     source: internal.totalPagesImageSource
                 }
             }
         }

         Image {
             id: currentImage
             source:  internal.currentPageImageSource
         }

         Repeater {
             id: backRepeater

             Item {
                 height: currentImage.height
                 width:  currentImage.width + internal.spacing

                 Image {
                     source: internal.totalPagesImageSource
                     anchors.right: parent.right
                 }
             }
         }
    }
}
