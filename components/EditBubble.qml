import QtQuick 2.1
import com.meego.components 1.0
import "Utils.js" as Utils
import "EditBubble.js" as Private
import "UIConstants.js" as UI // Ensure this imports UIConstants.js

Item {
    id: bubble
    property Item textFieldRoot: null
    property Item textInput: null // This property is set by EditBubble.js
    property bool valid: rect.canCut || rect.canCopy || rect.canPaste

    property alias privateRect: rect

    property Style platformStyle: EditBubbleStyle {}

    property variant position: Qt.point(0,0)

    anchors.fill: parent

    Flickable {
        id: rect
        flickableDirection: Flickable.HorizontalAndVerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        visible: opened && !outOfView

        width: row.width
        height: row.height
        property int positionOffset: 40;
        property int arrowOffset: 0
        property int arrowBorder: platformStyle.arrowMargin
        property bool arrowDown: true
        property bool changingText: false
        property bool pastingText: false

        property bool validInput: bubble.textInput != null
        property bool canCut: rect.canCopy && bubble.textInput && !bubble.textInput.readOnly // Added null check for bubble.textInput

        property bool canCopy: textSelected && bubble.textInput && (bubble.textInput.echoMode === null || bubble.textInput.echoMode === TextInput.Normal) // Added null check
        property bool canPaste: validInput && bubble.textInput && (bubble.textInput.canPaste && !bubble.textInput.readOnly) // Added null check
        property bool textSelected: validInput && bubble.textInput && (bubble.textInput.selectedText !== "") // Added null check
        property bool opened: false
        property bool outOfView: false
        property Item bannerInstance: null

        z: 1020

        onPositionOffsetChanged: if (rect.visible) Private.adjustPosition(bubble)

        onWidthChanged: if (rect.visible) Private.adjustPosition(bubble)

        onHeightChanged: if (rect.visible) Private.adjustPosition(bubble)

        onVisibleChanged: {
            if (visible === true) {
                if (buttonPaste.visible === true &&
                    buttonCut.visible === false &&
                    buttonCopy.visible === false) {
                    autoHideoutTimer.running = true
                }
                Private.adjustPosition(bubble)
            } else if (autoHideoutTimer.running === true) {
                autoHideoutTimer.running = false
            }
        }

        BasicRow {
            id: row
            Component.onCompleted: Private.updateButtons(row);

            EditBubbleButton {
                id: buttonCut
                objectName: "cutButton";
                // Assuming textTranslator is globally available or provided by a specific import
                text:"cut"// textTranslator.translate("qtn_comm_cut");
                visible: rect.canCut
                onClicked: {
                    rect.changingText = true;
                    if (bubble.textInput) bubble.textInput.cut(); // Added null check
                    rect.changingText = false;
                    Private.closePopup(bubble);
                }
                onVisibleChanged: Private.updateButtons(row);
            }

            EditBubbleButton {
                id: buttonCopy
                objectName: "copyButton";
                // Assuming textTranslator is globally available
                text: "copy"//textTranslator.translate("qtn_comm_copy");
                visible: rect.canCopy
                onClicked: {
                    if (bubble.textInput) bubble.textInput.copy(); // Added null check
                    Private.closePopup(bubble);
                }
                onVisibleChanged: Private.updateButtons(row);
            }

            EditBubbleButton {
                id: buttonPaste
                objectName: "pasteButton";
                // Assuming textTranslator is globally available
                text: "paste"//textTranslator.translate("qtn_comm_paste");
                visible: rect.canPaste
                onClicked: {
                    rect.changingText = true;
                    if (bubble.textInput && bubble.textInput.inputMethodComposing) { // Added null check
                        inputContext.reset();
                    }
                    rect.pastingText = true;
                    var text = bubble.textInput ? bubble.textInput.text : ""; // Added null check
                    if (bubble.textInput) bubble.textInput.paste(); // Added null check

                    if (rect.pastingText && text === (bubble.textInput ? bubble.textInput.text : "")) { // Added null check
                        if (rect.bannerInstance === null) {
                            var root = Utils.findRootItemNotificationBanner(bubble.textInput);
                            rect.bannerInstance = notificationBanner.createObject(root);
                        }
                        rect.bannerInstance.show();
                        rect.bannerInstance.timerEnabled = true;
                        rect.pastingText = false;
                    }
                    rect.changingText = false;
                    Private.closePopup(bubble);
                }

                onVisibleChanged: Private.updateButtons(row);
            }

            Component {
                id : notificationBanner
                NotificationBanner{
                    id: errorBannerPrivate
                    // Assuming textTranslator is globally available
                    text: "cantpaste"//textTranslator.translate("qtn_comm_cantpaste");
                    timerShowTime: 5*1000
                    topMargin: 8
                    leftMargin: 8
                }
            }
        }

        Image {
            id: bottomTailBackground
            source: platformStyle.bottomTailBackground
            visible: rect.arrowDown && bubble.valid

            anchors.bottom: row.bottom
            anchors.horizontalCenter: row.horizontalCenter
            anchors.horizontalCenterOffset: rect.arrowOffset
        }

        Image {
            id: topTailBackground
            source: platformStyle.topTailBackground
            visible: !rect.arrowDown && bubble.valid

            anchors.bottom: row.top
            anchors.bottomMargin: -platformStyle.backgroundMarginBottom - 2

            anchors.horizontalCenter: row.horizontalCenter
            anchors.horizontalCenterOffset: rect.arrowOffset
        }
    }

    Timer {
        id: autoHideoutTimer
        interval: 5000
        onTriggered: {
            running = false
            state = "hidden"
        }
    }

    state: "closed"

    states: [
        State {
            name: "opened"
            ParentChange { target: rect; parent: Utils.findRootItem(bubble.textInput); }
            PropertyChanges { target: rect; opened: true; opacity: 1.0 }
        },
        State {
            name: "hidden"
            ParentChange { target: rect; parent: Utils.findRootItem(bubble.textInput); }
            PropertyChanges { target: rect; opened: true; opacity: 0.0; }
        },
        State {
            name: "closed"
            ParentChange { target: rect; parent: bubble; }
            PropertyChanges { target: rect; opened: false; }
        }
    ]

    transitions: [
        Transition {
            from: "opened"; to: "hidden";
            reversible: false
            SequentialAnimation {
                NumberAnimation {
                    target: rect
                    properties: "opacity"
                    duration: 1000
                }
                ScriptAction {
                    script: {
                        Private.closePopup(bubble);
                    }
                }
            }
        }
    ]

    function findWindowRoot() {
        var item = Utils.findRootItem(bubble.textInput, "windowRoot");
        if (item === null || item.objectName !== "windowRoot") {
            item = Utils.findRootItem(bubble.textInput, "pageStackWindow");
        }
        return item;
    }

    Connections {
       target: findWindowRoot();
       ignoreUnknownSignals: true
       onOrientationChangeFinished: {
           Private.adjustPosition(bubble);
           rect.outOfView = ( ( rect.arrowDown === false
                 && Private.geometry().top < Utils.statusBarCoveredHeight( bubble ) )
                 || Private.geometry().bottom > screen.platformHeight - Utils.toolBarCoveredHeight ( bubble ) );
       }
    }
}

