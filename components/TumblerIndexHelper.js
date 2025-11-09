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

var __origIndex = [];

function saveIndex(src) {
    __origIndex = [];
    for (var i = 0; i < src.columns.length; i++) {
        __origIndex.push(src.columns[i].selectedIndex);
    }
}

function restoreIndex(src) {
    for (var i = 0; i < __origIndex.length; i++) {
        // position view at the right index then make sure selectedIndex
        // is updated to reflect that
        if (src.privateTemplates[i].view.currentIndex > __origIndex[i]) {
            while (src.privateTemplates[i].view.currentIndex != __origIndex[i]) {
                src.privateTemplates[i].view.decrementCurrentIndex()
            }
        } else if (src.privateTemplates[i].view.currentIndex < __origIndex[i]) {
            while (src.privateTemplates[i].view.currentIndex != __origIndex[i]) {
                src.privateTemplates[i].view.incrementCurrentIndex()
            }
        }
        src.columns[i].selectedIndex = __origIndex[i];
    }
}
