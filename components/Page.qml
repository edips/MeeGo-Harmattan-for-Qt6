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

// The Page item is intended for use as a root item in QML items that make
// up pages to use with the PageStack.

import QtQuick
import com.meego.components 1.0
import "."
import "UIConstants.js" as UI

Item {
    id: root

    visible: false

    // Note we do not use anchor fill here because it will force us to relayout
    // hidden children when rotating the screen as well
    width: visible && parent ? parent.width - anchors.leftMargin - anchors.rightMargin : __prevWidth
    height: visible && parent ? parent.height  - anchors.topMargin - anchors.bottomMargin : __prevHeight
    x: parent ? anchors.leftMargin : 0
    y: parent ? anchors.topMargin : 0

    onWidthChanged: __prevWidth = visible ? width : __prevWidth
    onHeightChanged: __prevHeight = visible ? height : __prevHeight

    property int __prevWidth: 0
    property int __prevHeight: 0

    property bool __isPage: true

    anchors.margins: 0 // Page margins should generally be 16 pixels as defined by UI.MARGIN_XLARGE

    // The status of the page. One of the following:
    //      PageStatus.Inactive - the page is not visible
    //      PageStatus.Activating - the page is transitioning into becoming the active page
    //      PageStatus.Active - the page is the current active page
    //      PageStatus.Deactivating - the page is transitioning into becoming inactive
    property int status: 0//PageStatus.Inactive

    // Defines the tools for the page; null for none.
    property Item tools: null

    // The page stack that the page is in.
    property PageStack pageStack

    // Defines if page is locked in landscape.
    property bool lockInLandscape: false // Deprecated
    onLockInLandscapeChanged: console.log("warning: Page.lockInLandscape is deprecated, use Page.orientationLock")

    // Defines if page is locked in portrait.
    property bool lockInPortrait: false // Deprecated
    onLockInPortraitChanged: console.log("warning: Page.lockInPortrait is deprecated, use Page.orientationLock")

    // Defines orientation lock for a page
    property int orientationLock: 1

    /*onStatusChanged: {
        if (status == PageStatus.Activating) {
            __updateOrientationLock()
        }
    }*/

    //onOrientationLockChanged: {
    //   __updateOrientationLock()
   // }

    /*
function __updateOrientationLock() {
        switch (orientationLock) {
        case PageOrientation.Automatic:
            screen.setAllowedOrientations(Screen.Portrait | Screen.Landscape);
            break
        case PageOrientation.LockPortrait:
            screen.setAllowedOrientations(Screen.Portrait);
            break
        case PageOrientation.LockLandscape:
            screen.setAllowedOrientations(Screen.Landscape);
            break
        case PageOrientation.LockPrevious:
            // Allowed orientation should be changed to current
            // if previously it was locked, it will remain locked
            // if previously it was not locked, it will be locked to current
            screen.setAllowedOrientations(screen.currentOrientation);
            break
        }
    }*/
}

