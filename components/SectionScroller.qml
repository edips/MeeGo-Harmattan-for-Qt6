import QtQuick
import "."
import "SectionScroller.js" as Sections

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
        width: parseInt(35 * ScaleFactor)
        height: listView.height
        x: listView.x + listView.width - width
        property bool dragging: false

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
                container.dragging = false;
                mouseDownTimer.stop()
            }

            onPositionChanged: {
                internal.adjustContentPosition(dragArea.mouseY);
            }

            Timer {
                id: mouseDownTimer
                interval: 150

                onTriggered: {
                    container.dragging = true;
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
            anchors.rightMargin: parseInt(50 * ScaleFactor)
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
                width: parseInt(8 * ScaleFactor)
                height: parseInt(16 * ScaleFactor)
                anchors.left: background.right
                property int threshold: currentSectionLabel.height
                property int yInitial: background.y + background.height/2 - height/2
                y: getYPosition()
                source: platformStyle.arrowImage

                function getYPosition() {
                    var v = internal.curPos;
                    var adjust = v === "first" ? -threshold :
                                v === "last" ? threshold : 0;

                    return yInitial + adjust;
                }

                states: [
                    State {
                        when: root.dragging && dragArea.mouseY < (root.listView.y + threshold)
                        PropertyChanges {
                            target: arrow
                            y: yInitial - threshold
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
                    when: container.dragging
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
        onCurrentSectionChanged: internal.curSect = container.dragging ? internal.curSect : ""
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
