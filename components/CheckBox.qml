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
import "UIConstants.js" as UI

Item {
    id: checkbox

    property Style platformStyle: CheckBoxStyle{}
    property alias platformMouseAnchors: mouseArea.anchors

    //Deprecated, TODO Remove this on w13
    property alias style: checkbox.platformStyle

    property string text
    property bool checked: false
    property bool pressed
    signal clicked

    implicitWidth: image.width + body.spacing + label.implicitWidth
    implicitHeight: body.height

    onWidthChanged: if (width > 0 && width != implicitWidth)
                        label.width = checkbox.width - body.spacing - image.width

    Binding {
        target: checkbox
        property: "pressed"
        value: mouseArea.pressed && mouseArea.containsMouse
    }

    property alias __imageSource: image.source

    function __handleChecked() {
        checkbox.checked = !checkbox.checked;
    }

    Row {
        id: body
        spacing: 8

        BorderImage {
            id: image
            smooth: true

            width: 28; height: 28

            source: !checkbox.enabled ? platformStyle.backgroundDisabled :
                    checkbox.pressed ? platformStyle.backgroundPressed :
                    checkbox.checked ? platformStyle.backgroundSelected :
                    platformStyle.background

            border {
                left: 1
                top: 1
                right: 1
                bottom: 1
            }
        }

        Label {
            id: label
            anchors.verticalCenter: image.verticalCenter
            text: checkbox.text
            elide: checkbox.platformStyle.elideMode
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: body
        anchors.topMargin: platformStyle.mouseMarginTop
        anchors.leftMargin: platformStyle.mouseMarginLeft
        anchors.rightMargin: platformStyle.mouseMarginRight
        anchors.bottomMargin: platformStyle.mouseMarginBottom

        onPressed: {
            // TODO: enable feedback without old themebridge
            // if (checkbox.checked)
            //     meegostyle.feedback("pressOnFeedback");
            // else
            //     meegostyle.feedback("pressOffFeedback");
        }

        onClicked: {
            __handleChecked();
            // TODO: enable feedback without old themebridge
            // if (checkbox.checked)
            //     meegostyle.feedback("releaseOnFeedback");
            // else
            //     meegostyle.feedback("releaseOffFeedback");
        }
    }
    Component.onCompleted: mouseArea.clicked.connect(clicked)
}
