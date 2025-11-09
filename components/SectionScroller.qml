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
import "."
import "SectionScroller.js" as Sections
import com.meego.components 1.0 // Ensure this import is present if using DialogStatus or other components

Item {
    id: root

    property ListView listView

    onListViewChanged: {
        if (listView && listView.model) {
            internal.initDirtyObserver();
        } else if (listView) {
            listView.modelChanged.connect(function() {
                if (listView.model) {
                    internal.initDirtyObserver();
                }
            });
        }
    }

    property Style platformStyle: SectionScrollerStyle {}

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    Rectangle {
        id: container
        color: "transparent"
        width: 35
        height: listView.height
        x: listView.x + listView.width - width
        property bool dragging: false // Correctly defined on container

        MouseArea {
            id: dragArea
            objectName: "dragArea"
            anchors.fill: parent
            drag.target: tooltip
            drag.axis: Drag.YAxis
            drag.minimumY: listView.y
            drag.maximumY: listView.y + listView.height - tooltip.height

            onPressed: {
                mouseDownTimer.restart()
            }

            onReleased: {
                container.dragging = false; // Correctly referencing container.dragging
                mouseDownTimer.stop()
            }

            onPositionChanged: {
                internal.adjustContentPosition(dragArea.mouseY);
            }

            Timer {
                id: mouseDownTimer
                interval: 150

                onTriggered: {
                    container.dragging = true; // Correctly referencing container.dragging
                    internal.adjustContentPosition(dragArea.mouseY);
                    tooltip.positionAtY(dragArea.mouseY);
                }
            }
        }
        Item {
            id: tooltip
            objectName: "popup"
            opacity: container.dragging ? 1 : 0
            anchors.right: parent.right
            anchors.rightMargin: 50
            width: childrenRect.width
            height: childrenRect.height

            function positionAtY(yCoord) {
                tooltip.y = Math.max(dragArea.drag.minimumY, Math.min(yCoord - tooltip.height/2, dragArea.drag.maximumY));
            }

            BorderImage {
                id: background
                width: childrenRect.width// + 20
                height: childrenRect.height// + 20
                anchors.left: parent.left
                source: platformStyle.backgroundImage
                border { left: 4; top: 4; right: 4; bottom: 4 }

                Column {
                    width: Math.max(previousSectionLabel.width, currentSectionLabel.width, nextSectionLabel.width)
                    height: childrenRect.height

                    SectionScrollerLabel {
                        id: previousSectionLabel
                        objectName: "previousSectionLabel"
                        text: internal.prevSection
                        highlighted: internal.curSect === text
                        up: !internal.down
                    }

                    Image {
                        objectName: "divider1"
                        source: platformStyle.dividerImage
                        width: parent.width
                        height: 1
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    SectionScrollerLabel {
                        id: currentSectionLabel
                        objectName: "currentSectionLabel"
                        text: internal.currentSection
                        highlighted: internal.curSect === text
                        up: !internal.down
                    }

                    Image {
                        objectName: "divider2"
                        source: platformStyle.dividerImage
                        width: parent.width
                        height: 1
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    SectionScrollerLabel {
                        id: nextSectionLabel
                        objectName: "nextSectionLabel"
                        text: internal.nextSection
                        highlighted: internal.curSect === text
                        up: !internal.down
                    }
                }
            }

            Image {
                id: arrow
                objectName: "arrow"
                width: 8
                height: 16
                anchors.left: background.right
                property int threshold: currentSectionLabel.height // Correctly defined on arrow
                property int yInitial: background.y + background.height/2 - height/2
                y: getYPosition()
                source: platformStyle.arrowImage

                function getYPosition() {
                    var v = internal.curPos;
                    var adjust = v === "first" ? -arrow.threshold : // Use arrow.threshold
                                 v === "last" ? arrow.threshold : 0; // Use arrow.threshold

                    return arrow.yInitial + adjust; // Use arrow.yInitial
                }

                states: [
                    State {
                        // FIX: Corrected references to container.dragging, root.listView, and arrow.threshold
                        when: container.dragging && root.listView && dragArea.mouseY < (root.listView.y + arrow.threshold)
                        PropertyChanges {
                            target: arrow
                            y: arrow.yInitial - arrow.threshold // Use arrow.yInitial and arrow.threshold
                        }
                    }
                ]

                Behavior on y {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }

            states: [
                State {
                    name: "visible"
                    when: container.dragging // Correctly referencing container.dragging
                },

                State {
                    extend: "visible"
                    name: "atTop"
                    when: internal.curPos === "first"
                    PropertyChanges {
                        target: previousSectionLabel
                        text: internal.currentSection
                    }
                    PropertyChanges {
                        target: currentSectionLabel
                        text: internal.nextSection
                    }
                    PropertyChanges {
                        target: nextSectionLabel
                        text: Sections.getNextSection(internal.nextSection)
                    }
                },

                State {
                    extend: "visible"
                    name: "atBottom"
                    when: internal.curPos === "last"
                    PropertyChanges {
                        target: previousSectionLabel
                        text: Sections.getPreviousSection(internal.prevSection)
                    }
                    PropertyChanges {
                        target: currentSectionLabel
                        text: internal.prevSection
                    }
                    PropertyChanges {
                        target: nextSectionLabel
                        text: internal.currentSection
                    }
                }
            ]

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }
    }

    Timer {
        id: dirtyTimer
        interval: 100
        running: false
        onTriggered: {
            Sections.initSectionData(listView);
            internal.modelDirty = false;
        }
    }

    Connections {
        target: root.listView
        function onCurrentSectionChanged(){
            internal.curSect = container.dragging ? internal.curSect : "" // Correctly referencing container.dragging
        }
    }

    QtObject {
        id: internal

        property string prevSection: ""
        property string currentSection: listView.currentSection
        property string nextSection: ""
        property string curSect: ""
        property string curPos: "first"
        property int oldY: 0
        property bool modelDirty: false
        property bool down: true

        function initDirtyObserver() {
            Sections.initialize(listView);
            function dirtyObserver() {
                if (!internal.modelDirty) {
                    internal.modelDirty = true;
                    dirtyTimer.running = true;
                }
            }

            if (listView.model.countChanged)
                listView.model.countChanged.connect(dirtyObserver);

            if (listView.model.itemsChanged)
                listView.model.itemsChanged.connect(dirtyObserver);

            if (listView.model.itemsInserted)
                listView.model.itemsInserted.connect(dirtyObserver);

            if (listView.model.itemsMoved)
                listView.model.itemsMoved.connect(dirtyObserver);

            if (listView.model.itemsRemoved)
                listView.model.itemsRemoved.connect(dirtyObserver);
        }

        function adjustContentPosition(y) {
            if (y < 0 || y > dragArea.height) return;

            internal.down = (y > internal.oldY);
            var sect = Sections.getClosestSection((y / dragArea.height), internal.down);
            internal.oldY = y;
            if (internal.curSect !== sect) {
                internal.curSect = sect;
                internal.curPos = Sections.getSectionPositionString(internal.curSect);
                var sec = Sections.getRelativeSections(internal.curSect);
                internal.prevSection = sec[0];
                internal.currentSection = sec[1];
                internal.nextSection = sec[2];
                var idx = Sections.getIndexFor(sect);
                listView.positionViewAtIndex(idx, ListView.Beginning);
            }
        }
    }
}
