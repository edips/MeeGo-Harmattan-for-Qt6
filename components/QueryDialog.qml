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
import meego
import "."
import "UIConstants.js" as UI

Dialog {
    id: root
    objectName: "queryDialog"
    // Close the dialog with back button
    Connections {
        target: GlobalSettings
        function onDialogFocusChanged(dialogFocus) {
            close()
        }
    }
    property string titleText
    property string message

    //are they necessary?
    property alias acceptButtonText: acceptButton.text
    property alias rejectButtonText: rejectButton.text

    //ToDof
    property alias icon: iconImage.source

    property Style platformStyle: QueryDialogStyle {}

    //__centerContentField: true

    __dim: platformStyle.dim
    __fadeInDuration:  platformStyle.fadeInDuration
    __fadeOutDuration: platformStyle.fadeOutDuration
    __fadeInDelay:     platformStyle.fadeInDelay
    __fadeOutDelay:    platformStyle.fadeOutDelay

    __animationChief: "queryDialog"

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    // the title field consists of the following parts: title string and
    // a close button (which is in fact an image)
    // it can additionally have an icon
    title: Item {
        id: titleField
        width: parent.width
        height: titleText == "" ? titleBarIconField.height :
                    titleBarIconField.height + titleLabel.height + root.platformStyle.titleColumnSpacing
        Column {
            id: titleFieldCol
            spacing: root.platformStyle.titleColumnSpacing

            anchors.left:  parent.left
            anchors.right:  parent.right
            anchors.top:  parent.top

            width: root.width

            Item {
                id: titleBarIconField
                height: iconImage.height
                width: parent.width
                Image {
                    id: iconImage
                    anchors.horizontalCenter: titleBarIconField.horizontalCenter
                    source: ""
                }

            }


            Item {
                id: titleBarTextField
                height: titleLabel.height
                width: parent.width

                Text {
                    id: titleLabel
                    width: parent.width

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment:   Text.AlignVCenter

                    font.family: root.platformStyle.titleFontFamily
                    font.pixelSize: root.platformStyle.titleFontPixelSize
                    font.bold:  root.platformStyle.titleFontBold
                    font.capitalization: root.platformStyle.titleFontCapitalization
                    elide: root.platformStyle.titleElideMode
                    color: root.platformStyle.titleTextColor
                    text: root.titleText

                }
            }

            // needed for animation
            transform: Scale {
                id: titleScale
                xScale: 1.0; yScale: 1.0
                origin.x: mapFromItem(queryContent, queryContent.width / 2, queryContent.height / 2).x
                origin.y: mapFromItem(queryContent, queryContent.width / 2, queryContent.height / 2).y
            }

        }
    }

    // the content field which contains the message text
    content: Item {
        id: queryContentWrapper

        property int upperBound: visualParent ? visualParent.height - titleField.height - buttonColFiller.height - 64
                                                : root.parent.height - titleField.height - buttonColFiller.height - 64
        property int __sizeHint: Math.min(Math.max(root.platformStyle.contentFieldMinSize, queryText.height), upperBound)

        height: __sizeHint + root.platformStyle.contentTopMargin
        width: root.width

        Item {
            id: queryContent
            width: parent.width

            y: root.platformStyle.contentTopMargin

            Flickable {
                id: queryFlickable
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                //anchors.bottom: parent.bottom
                height: queryContentWrapper.__sizeHint

                contentHeight: queryText.height
                flickableDirection: Flickable.VerticalFlick
                clip: true

                interactive:  queryText.height > queryContentWrapper.__sizeHint

                Text {
                    id: queryText
                    width: queryFlickable.width
                    horizontalAlignment: Text.AlignHCenter
                    font.family: root.platformStyle.messageFontFamily
                    font.pixelSize: root.platformStyle.messageFontPixelSize
                    color: root.platformStyle.messageTextColor
                    wrapMode: Text.WordWrap
                    text: root.message
                }

            }


            ScrollDecorator {
                id: scrollDecorator
                flickableItem: queryFlickable
                anchors.rightMargin: - UI.SCROLLDECORATOR_LONG_MARGIN - 10 //ToDo: Don't use a hard-coded gap
            }

        }
    }


    buttons: Item {
        id: buttonColFiller
        width: parent.width
        height: childrenRect.height

        anchors.top: parent.top

        //ugly hack to assure, that we're always evaluating the correct height
        //otherwise the topMargin wouldn't be considered
        Item {id: dummy; anchors.fill:  parent}

        Column {
            id: buttonCol
            anchors.top: parent.top
            anchors.topMargin: root.platformStyle.buttonTopMargin
            spacing: root.platformStyle.buttonsColumnSpacing

            height: (acceptButton.text  === "" ? 0 : acceptButton.height)
                    + (rejectButton.text === "" ? 0 : rejectButton.height)
                    + anchors.buttonTopMargin  + spacing

            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: acceptButton
                text: ""
                onClicked: accept()
                visible: text !== ""
                __dialogButton: true
                platformStyle: ButtonStyle {inverted: true}
            }
            Button {
                id: rejectButton
                text: ""
                onClicked: reject()
                visible: text !== ""
                __dialogButton: true
                platformStyle: ButtonStyle {inverted: true}
            }
        }
    }

    StateGroup {
        id: statesWrapper

        state: "__query__hidden"

        // needed for button animation
        // without resetting the button row's coordinate system would be translated
        property int __buttonSaver: buttonColFiller.y

        states: [
            State {
                name: "__query__visible"
                when: root.__animationChief == "queryDialog" && (root.status == DialogStatus.Opening || root.status == DialogStatus.Open)
                PropertyChanges {
                    target: root
                    opacity: 1.0
                }
            },
            State {
                name: "__query__hidden"
                when: root.__animationChief == "queryDialog" && (root.status == DialogStatus.Closing || root.status == DialogStatus.Closed)
                PropertyChanges {
                    target: root
                    opacity: 0.0
                }
            }
        ]

        transitions: [
            Transition {
                from: "__query__visible"; to: "__query__hidden"
                SequentialAnimation {
                    ScriptAction {script: {
                            __fader().state = "hidden";

                            statesWrapper.__buttonSaver = buttonColFiller.y
                            root.status = DialogStatus.Closing;

                        }
                    }

                    NumberAnimation { target: root; properties: "opacity"; from: 0.0; to: 1.0; duration: 0 }

                    // With a 100ms delay the background
                    // fades to alpha 0% (500ms, quint ease out).
                    // ---> done in the fader

                    ParallelAnimation {
                        // The closing transition starts with the message dimming to alpha 0% and
                        // scaling to 80% (anchorpoint in the middle of the message, 100ms, quint
                        // ease in).

                        // With no delay the buttons fade to alpha 0% and translate 30
                        // pixels upwards (100ms, quint ease in).
                        NumberAnimation {target: queryContent; properties: "opacity"; from: 1.0; to: 0.0; duration: 100}
                        NumberAnimation {target: titleField; properties: "opacity"; from: 1.0; to: 0.0; duration: 100}
                        NumberAnimation {target: titleScale; properties: "xScale,yScale"; from: 1.0 ; to: 0.8; duration: 100; easing.type: Easing.InQuint}
                        NumberAnimation {target: queryContent; property: "scale"; from: 1.0 ; to: 0.8; duration: 100; easing.type: Easing.InQuint}
                        NumberAnimation {target: buttonColFiller; properties: "opacity"; from: 1.0; to: 0.0; duration: 100}
                        NumberAnimation {target: buttonColFiller
                            properties: "y"
                            from: buttonColFiller.y
                            to: buttonColFiller.y-30
                            duration: 100
                            easing.type: Easing.InQuint
                        }
                    }

                    ScriptAction {script: {

                            // reset button
                            buttonColFiller.y = statesWrapper.__buttonSaver

                            // make sure, root isn't visible:
                            root.opacity = 0.0;
                            status = DialogStatus.Closed;

                        }
                    }

                }
            },
            Transition {
                from: "__query__hidden"; to: "__query__visible"
                SequentialAnimation {
                    ScriptAction {script: {
                            __fader().state = "visible";

                            statesWrapper.__buttonSaver = buttonColFiller.y

                            root.status = DialogStatus.Opening;
                            // UPPERCASE-UGLY, but necessary to avoid flicker
                            root.opacity = 1.0
                            titleField.opacity = 0.0
                            queryContent.opacity = 0.0
                            buttonColFiller.opacity = 0.0
                        }
                    }

                    // The opening transition starts by dimming the background to 90% (250ms,
                    // quint ease in).
                    // ---> done in the fader
                    ParallelAnimation {
                        SequentialAnimation {

                            // With a 200ms delay from the beginning the message fades
                            // from alpha 0% to 100% and scales from 80% to 100% (anchorpoint in the
                            // middle of the message, 550ms, custom ease).
                            PauseAnimation { duration: 200 }
                            ParallelAnimation {
                                NumberAnimation {target: queryContent; properties: "opacity"; from: 0.0; to: 1.0; duration: 550}
                                NumberAnimation {target: titleField; properties: "opacity"; from: 0.0; to: 1.0; duration: 550}
                                NumberAnimation {target: titleScale; properties: "xScale,yScale"; from: 0.8 ; to: 1.0; duration: 550; easing.type: Easing.OutBack}
                                NumberAnimation {target: queryContent; property: "scale"; from: 0.8 ; to: 1.0; duration: 550; easing.type: Easing.OutBack}
                            }
                        }
                        SequentialAnimation {
                            // With a 250ms delay from the
                            // beginning the buttons fade from alpha 0% to 100% and translate 25 pixels
                            // in Y axis away from their final destination (400ms, custom ease).
                            PauseAnimation { duration: 250 }
                            ParallelAnimation {
                                NumberAnimation {target: buttonColFiller; properties: "opacity"; from: 0.0; to: 1.0; duration: 400; }
                                NumberAnimation {target: buttonColFiller
                                    properties: "y"
                                    from: buttonColFiller.y-25
                                    to: buttonColFiller.y
                                    duration: 400
                                    easing.type: Easing.OutBack
                                }
                            }
                        }
                    }

                    ScriptAction {script: {

                            // reset button
                            buttonColFiller.y = statesWrapper.__buttonSaver

                            root.status = DialogStatus.Open;
                        }
                    }
                }
            }
        ]
    }

}
