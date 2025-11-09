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
import meego
import com.meego.components 1.0

AbstractMenu {
  id: root
  // Close the dialog with back button
  // Back key handling
  focus: GlobalSettings.menuFocus
  onStatusChanged: {
      if(root.status === DialogStatus.Open || root.status === DialogStatus.Opening) {
          GlobalSettings.menuFocus = true
      } else {
          GlobalSettings.menuFocus = false
      }
  }
  // RESTORED: This handler is necessary for the menu to intercept the back button
  // and prevent the event from propagating to the PageStackWindow.
  Keys.onReleased: (event) => {
      if (event.key === Qt.Key_Back && DialogStatus.Open) {
          GlobalSettings.menuFocus = false
          close()
          event.accepted = true // IMPORTANT: This stops the event from reaching the PageStackWindow
      }
  }
/*
    platformTitle: BorderImage {
        id: topDivider
        anchors.left: parent.left
        anchors.right: parent.right
        height: 2
        source: "" // "qrc:/images/meegotouch-button-objectmenu-background-vertical-top.png"
        border { top: 2; bottom: 1; left: 1; right: 1 }
    }
*/

    function __beginTransformationToHidden() {
        __fader().state = "hidden";
        root.status = DialogStatus.Closing;
    }

    function __beginTransformationToVisible() {
        __fader().state = "visible";
        root.status = DialogStatus.Opening;
        __menuPane.anchors.rightMargin = 0;
        __menuPane.anchors.bottomMargin = 0;
    }



    __statesWrapper.transitions: [
        Transition {
            from: "visible"; to: "hidden"
            SequentialAnimation {
                ScriptAction {script: __beginTransformationToHidden()}

                NumberAnimation {target: __menuPane;
                                 property: orientation.orientation === "Portrait" ? "anchors.bottomMargin" : "anchors.rightMargin";
                                 easing.type: Easing.InOutQuint;
                                 to: orientation.orientation === "Portrait" ? -__menuPane.height : -__menuPane.width;
                                 from: 0; duration: 350 }

                NumberAnimation {target: __menuPane; property: "opacity";
                                 from: 1.0; to: 0.0; duration: 0}

                ScriptAction {script: status = DialogStatus.Closed}
            }
        },
        Transition {
            from: "hidden"; to: "visible"
            SequentialAnimation {
                ScriptAction {script: __beginTransformationToVisible()}

                NumberAnimation {target: __menuPane;
                                 property: orientation.orientation === "Portrait" ? "anchors.bottomMargin" : "anchors.rightMargin";
                                 easing.type: Easing.InOutQuint;
                                 from: orientation.orientation === "Portrait" ? -__menuPane.height : -__menuPane.width;
                                 to: 0; duration: 350 }

                ScriptAction {script: status = DialogStatus.Open }
            }
        }
    ]
}
