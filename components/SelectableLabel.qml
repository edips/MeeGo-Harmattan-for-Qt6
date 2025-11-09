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

import QtQuick 2.1
import com.meego.components 1.0
import "UIConstants.js" as UI

import "EditBubble.js" as Popup
import "SelectionHandles.js" as SelectionHandles

Label {
    id: root

    // Common public API
    property bool platformSelectable: true
    property bool platformEnableEditBubble: true

    QtObject {
        id: privateApi
        property color __textColor
    }

    MouseArea {
        id: mouseFilter
        anchors.fill: parent

        enabled: platformSelectable

        Component {
            id: textSelectionComponent

            TextEdit {
                id: selectionTextEdit
                // Disables native selection handler in order to not overlap with Meego's selection handler
                inputMethodHints: Qt.ImhNoTextHandles
                readOnly: true
                selectByMouse: true

                // TODO: For every new QML release sync new QML TextEdit properties:
                clip : root.clip
                color : privateApi.__textColor
                font.bold : root.font.bold
                font.capitalization : root.font.capitalization
                font.family : root.font.family
                font.italic : root.font.italic
                font.letterSpacing : root.font.letterSpacing
                font.pixelSize : root.font.pixelSize
                font.pointSize : root.font.pointSize
                font.strikeout : root.font.strikeout
                font.underline : root.font.underline
                font.weight : root.font.weight
                font.wordSpacing : root.font.wordSpacing
                horizontalAlignment : root.horizontalAlignment
                smooth : root.smooth
                text : root.text
                textFormat : root.textFormat
                verticalAlignment : root.verticalAlignment
                wrapMode : root.wrapMode

                mouseSelectionMode : TextEdit.SelectWords

                selectedTextColor : platformStyle.selectedTextColor
                selectionColor : platformStyle.selectionColor

                Component.onCompleted: {
                    if ( root.elide == Text.ElideNone ) {
                        width = root.width;
                        height = root.height;
                    }
                    privateApi.__textColor = root.color;
                    root.color = Qt.rgba(0, 0, 0, 0);
                    selectWord();
                    if (platformEnableEditBubble) {
                         Popup.open(selectionTextEdit,selectionTextEdit.positionToRectangle(selectionTextEdit.cursorPosition));
                         SelectionHandles.open( selectionTextEdit )
                    }
                }
                Component.onDestruction: {
                    console.log("privateApi.__textColor; ", privateApi.__textColor)
                    //root.color = privateApi.__textColor;

                    if (Popup.isOpened(selectionTextEdit)) {
                        Popup.close(selectionTextEdit);
                    }
                    if (SelectionHandles.isOpened(selectionTextEdit)) {
                        SelectionHandles.close(selectionTextEdit);
                    }
                }

                onSelectedTextChanged: {
                    if (selectionTextEdit.selectionStart == selectionTextEdit.selectionEnd) {
                        selectionTextEdit.selectWord();
                    }
                    if (Popup.isOpened(selectionTextEdit)) {
                        Popup.close(selectionTextEdit);
                    }
                }

                MouseFilter {
                    id: mouseSelectionFilter
                    anchors.fill: parent

                    onFinished: {
                        if (platformEnableEditBubble) {
                            Popup.open(selectionTextEdit,selectionTextEdit.positionToRectangle(selectionTextEdit.cursorPosition));
                        }
                    }
                }

                InverseMouseArea {
                    anchors.fill: parent
                    enabled: textSelectionLoader.sourceComponent !== undefined

                    onPressedOutside:  mouse => { // Pressed instead of Clicked to prevent selection overlap
                        if (Popup.isOpened(selectionTextEdit) && ((mouseX > Popup.geometry().left && mouseX < Popup.geometry().right) &&
                                                       (mouseY > Popup.geometry().top && mouseY < Popup.geometry().bottom))) {
                            return
                        }
                        if (SelectionHandles.isOpened(selectionTextEdit)) {
                            if (SelectionHandles.leftHandleContains(Qt.point(mouseX, mouseY))) {
                                return
                            }
                            if (SelectionHandles.rightHandleContains(Qt.point(mouseX, mouseY))) {
                                return
                            }
                        }
                        textSelectionLoader.sourceComponent = undefined;
                    }
                    onClickedOutside: mouse => { // Handles Copy click
                        if (SelectionHandles.isOpened(selectionTextEdit) &&
                            ( SelectionHandles.leftHandleContains(Qt.point(mouseX, mouseY)) ||
                              SelectionHandles.rightHandleContains(Qt.point(mouseX, mouseY)) ) ) {
                            return
                        }
                        if (Popup.isOpened(selectionTextEdit) && ((mouseX > Popup.geometry().left && mouseX < Popup.geometry().right) &&
                                                       (mouseY > Popup.geometry().top && mouseY < Popup.geometry().bottom))) {
                            textSelectionLoader.sourceComponent = undefined;
                            return;
                        }
                    }
                }
            }
        }
        Loader {
          id: textSelectionLoader
        }

        onPressAndHold: mouse =>  {
            if (root.platformSelectable == false) return; // keep old behavior if selection is not requested

            textSelectionLoader.sourceComponent = textSelectionComponent;

            // select word that is covered by long press:
            var cursorPos = textSelectionLoader.item.positionAt(mouse.x, mouse.y);
            textSelectionLoader.item.cursorPosition = cursorPos;
            if (platformEnableEditBubble) {
                Popup.open(textSelectionLoader.item,textSelectionLoader.item.positionToRectangle(textSelectionLoader.item.cursorPosition));
            }
        }
    }
}
