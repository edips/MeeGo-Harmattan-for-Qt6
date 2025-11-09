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
import "constants.js" as C
import "UIConstants.js" as UiConstants

Item {
    id: template
    objectName: "tumblerColumn" + index

    property Item tumblerColumn
    property int index: -1
    property Item view: viewContainer.item

    property Style platformStyle: LabelStyle{}

    opacity: enabled ? C.TUMBLER_OPACITY_FULL : C.TUMBLER_OPACITY
    width: childrenRect.width
    visible: tumblerColumn ? tumblerColumn.visible : false
    enabled: tumblerColumn ? tumblerColumn.enabled : true
    onTumblerColumnChanged: {
        if (tumblerColumn)
            viewContainer.sourceComponent = tumblerColumn.privateLoopAround ? pViewComponent : lViewComponent;
    }

    Loader {
        id: viewContainer
        width: tumblerColumn ? tumblerColumn.width : 0
        height: parent.height - container.height - 2*C.TUMBLER_BORDER_MARGIN // decrease by text & border heights
    }

    Component {
        // Component for loop around column
        id: pViewComponent
        PathView {
            id: pView

            model: tumblerColumn ? tumblerColumn.items : undefined
            currentIndex: tumblerColumn ? tumblerColumn.selectedIndex : 0
            preferredHighlightBegin: (height / 2) / (C.TUMBLER_ROW_HEIGHT * pView.count)
            preferredHighlightEnd: preferredHighlightBegin
            highlightRangeMode: PathView.StrictlyEnforceRange
            clip: true
            delegate: defaultDelegate
            highlight: defaultHighlight
            interactive: template.enabled
            anchors.fill: parent

            onMovementStarted: {
                internal.movementCount++;
            }
            onMovementEnded: {
                internal.movementCount--;
                root.changed(template.index) // got index from delegate
            }

            Rectangle {
                width: 1
                height: parent.height
                color: C.TUMBLER_COLOR_TEXT
                opacity: C.TUMBLER_OPACITY_LOW
            }

            path: Path {
                 startX: template.width / 2; startY: 0
                 PathLine {
                     x: template.width / 2
                     y: C.TUMBLER_ROW_HEIGHT * pView.count
                 }
            }
        }
    }

    Component {
        // Component for non loop around column
        id: lViewComponent
        ListView {
            id: lView

            model: tumblerColumn ? tumblerColumn.items : undefined
            currentIndex: tumblerColumn ? tumblerColumn.selectedIndex : 0
            preferredHighlightBegin: Math.floor((height - C.TUMBLER_ROW_HEIGHT) / 2)
            preferredHighlightEnd: preferredHighlightBegin + C.TUMBLER_ROW_HEIGHT
            highlightRangeMode: ListView.StrictlyEnforceRange
            clip: true
            delegate: defaultDelegate
            highlight: defaultHighlight
            interactive: template.enabled
            anchors.fill: parent

            onMovementStarted: {
                internal.movementCount++;
            }
            onMovementEnded: {
                internal.movementCount--;
                root.changed(template.index) // got index from delegate
            }

            Rectangle {
                width: 1
                height: parent.height
                color: C.TUMBLER_COLOR_TEXT
                opacity: C.TUMBLER_OPACITY_LOW
            }
        }
    }

    Item {
        id: container
        anchors.top: viewContainer.bottom
        width: tumblerColumn ? tumblerColumn.width : 0
        height: internal.hasLabel ? C.TUMBLER_LABEL_HEIGHT : 0 // internal.hasLabel is from root tumbler

        Text {
            id: label

            text: tumblerColumn ? tumblerColumn.label : ""
            elide: Text.ElideRight
            horizontalAlignment: "AlignHCenter"
            color: C.TUMBLER_COLOR_LABEL
            font { family: UiConstants.DefaultFontFamilyLight; pixelSize: C.FONT_LIGHT_SIZE }
            anchors { fill: parent; margins: C.TUMBLER_MARGIN}
        }
    }

    Component {
        id: defaultDelegate

        Item {
            width: tumblerColumn.width
            height: C.TUMBLER_ROW_HEIGHT

            Text {
                id: txt
                elide: Text.ElideRight
                horizontalAlignment: "AlignHCenter"
                color: C.TUMBLER_COLOR_TEXT
                font { family: platformStyle.fontFamily; pixelSize: platformStyle.fontPixelSize }
                anchors { fill: parent; margins: C.TUMBLER_MARGIN }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (template.view.interactive) {
                            tumblerColumn.selectedIndex = index;  // got index from delegate
                            root.changed(template.index);
                        }
                    }
                }
            }

            Component.onCompleted: {
                try {
                    // Legacy. "value" use to be the role which was used by delegate
                    txt.text = value
                } catch(err) {
                    try {
                        // "modelData" available for JS array and for models with one role
                        txt.text = modelData
                    } catch (err) {
                        try {
                            // C++ models have "display" role available always
                            txt.text = display
                        } catch(err) {
                        }
                    }
                }
            }
        }
    }

    Component {
        id: defaultHighlight

        Image {
            id: highlight
            objectName: "highlight"
            width: tumblerColumn ? tumblerColumn.width : 0
            height: C.TUMBLER_ROW_HEIGHT
            source: "qrc:/images/meegotouch-list-fullwidth-background-selected-horizontal-center.png"  //+ theme.colorString + "meegotouch-list-fullwidth-background-selected-horizontal-center"
            fillMode: Image.TileHorizontally
        }
    }
}
