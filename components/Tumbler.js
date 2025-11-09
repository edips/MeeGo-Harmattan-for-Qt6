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

var __columns = [];
var __autoColumnWidth = 0;
var __suppressLayoutUpdates = false;

function initialize() {
    // check the width requested by fixed width columns
    var requestedWidth = 0;
    var requestedCount = 0;
    var invisibleCount = 0;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].visible) {
            if (columns[i].width > 0 && !columns[i].privateIsAutoWidth) {
                requestedWidth += columns[i].width;
                requestedCount++;
            }
        } else {
            invisibleCount++;
        }
    }

    // allocate the rest to auto width columns
    if ((columns.length - requestedCount - invisibleCount) > 0) {
        __autoColumnWidth = Math.floor((parent.width - requestedWidth) / (columns.length - requestedCount - invisibleCount));
    }

    for (var i = 0; i < columns.length; i++) {
        var comp = Qt.createComponent("TumblerTemplate.qml");
        var newObj = comp.createObject(tumblerRow);
        if (!columns[i].width || columns[i].privateIsAutoWidth) {
            columns[i].width = __autoColumnWidth;
            columns[i].privateIsAutoWidth = true;
        }
        if (columns[i].label) {
            // enable label for the tumbler
            internal.hasLabel = true;
        }
        newObj.height = root.height;
        newObj.index = i;
        newObj.tumblerColumn = columns[i];
        newObj.widthChanged.connect(layout);
        newObj.visibleChanged.connect(layout);
        __columns.push(newObj);
    }
    privateTemplates = __columns;
}

function clear() {
    var count = __columns.length;
    for (var i = 0; i < count; i++) {
        var tmp = __columns.pop();
        tmp.destroy();
    }
}

function forceUpdate() {
    for (var i = 0; i < columns.length; i++) {
        columns[i].selectedIndex = __columns[i].view.currentIndex;
    }
}

function layout() {
    if (__suppressLayoutUpdates) {
        // guard against onWidthChanged triggering again during this process
        return;
    }
    var requestedWidth = 0;
    var requestedCount = 0;
    var invisibleCount = 0;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].visible) {
            var w = columns[i].width;
            var a = columns[i].privateIsAutoWidth;
            if (!a || (a && w != __autoColumnWidth)) {
                requestedWidth += columns[i].width;
                requestedCount++;
                columns[i].privateIsAutoWidth = false;
            } else {
                columns[i].privateIsAutoWidth = true;
            }
        } else {
            invisibleCount++;
        }
    }

    if ((columns.length - requestedCount - invisibleCount) > 0) {
        __autoColumnWidth = Math.floor((parent.width - requestedWidth) / (columns.length - requestedCount - invisibleCount));
    }

    // guard against onWidthChanged triggering again during this process
    __suppressLayoutUpdates = true;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].privateIsAutoWidth) {
            columns[i].width = __autoColumnWidth;
        }
    }
    __suppressLayoutUpdates = false;
}
