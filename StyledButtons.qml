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
    id: buttonsPage
    anchors.margins: UiConstants.DefaultMargin
    tools: commonTools

    Flickable {
        anchors.fill: parent
        contentWidth: col1.width
        contentHeight: col1.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: col1
            spacing: 30

            Label {
                width: 400
                text: "Enabled buttons of different styles"
                font.bold: true
                wrapMode: Text.Wrap
            }

            Button {
                text: "No style"
            }

            Button {
                text: "ListButtonStyle"
                style: ListButtonStyle {}
            }

            Button {
                text: "NegativeButtonStyle"
                style: NegativeButtonStyle {}
            }

            Button {
                text: "PositiveButtonStyle"
                style: PositiveButtonStyle {}
            }

            TumblerButton {
                text: "TumblerButtonStyle"
            }

            TumblerButton {
                text: "InvertedTumblerButtonStyle"
                style: TumblerButtonStyle { inverted: true }
            }
        }

        Column {
            id: col2
            spacing: 30
            anchors {left: col1.right}

            Label {
                width: 400
                text: "Disabled buttons of different styles"
                font.bold: true
                wrapMode: Text.Wrap
            }

            Button {
                text: "No style"
                enabled: false
            }

            Button {
                text: "ListButtonStyle"
                style: ListButtonStyle {}
                enabled: false
            }

            Button {
                text: "NegativeButtonStyle"
                style: NegativeButtonStyle {}
                enabled: false
            }

            Button {
                text: "PositiveButtonStyle"
                style: PositiveButtonStyle {}
                enabled: false
            }

            TumblerButton {
                text: "TumblerButtonStyle"
                enabled: false
            }

            TumblerButton {
                text: "InvertedTumblerButtonStyle"
                style: TumblerButtonStyle { inverted: true }
                enabled: false
            }
        }

    }
}
