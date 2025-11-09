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
    id: labelsPage
    anchors.margins: UiConstants.DefaultMargin
    tools: commonTools

    Flickable {
        id: labelFlick
        contentWidth: col.width
        contentHeight: col.height
        flickableDirection: Flickable.VerticalFlick

        anchors.fill: parent
        Column {
            id: col
            SelectableLabel { text: "Plain label"; }
            Label { text: "<a href=\"http://www.nokia.com\">Invert</a> label via link";
                    onLinkActivated: platformStyle.inverted = !platformStyle.inverted; }
            SelectableLabel { text: "Bold label"; font.bold: true; }
            SelectableLabel { text: "Italic label"; font.italic: true; }
            SelectableLabel { text: "Large label"; font.pixelSize: 100;  }

            SelectableLabel {
                id: coloredLabel
                text: "Large label with MouseArea"
                width: parent.width
                font.pixelSize: 48
                color: Qt.rgba(1.0, 0.5, 0.5, 1.0)
                wrapMode: Text.WordWrap

                MouseArea {
                    id: ma
                    anchors.fill:  parent
                    onClicked: coloredLabel.color ===  Qt.rgba(1.0, 0.5, 0.5, 1.0) ?
                                   coloredLabel.color =  Qt.rgba(0.5, 1.0, 0.5, 1.0)
                                 : coloredLabel.color =  Qt.rgba(1.0, 0.5, 0.5, 1.0)
                }

            }

            SelectableLabel { text: "Red label"; color: "red"; }
            SelectableLabel { text: "Elided labels are too long"; font.italic: true; width: 200; elide: Text.ElideRight; }
            Label { text: "Unselectable plain label <br>" }
            SelectableLabel {
                text: "<b>Wrapping label with a lot of text:</b> The quick brown fox jumps over the lazy dog. \
                The quick brown fox jumps over the lazy dog. <br>The quick brown fox jumps over the lazy dog. \
                The quick brown fox jumps over the lazy dog."
                font.pixelSize: 30
                wrapMode: Text.Wrap
                width: labelsPage.width
            }

        }
    }
}
