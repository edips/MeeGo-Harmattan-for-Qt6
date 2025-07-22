import QtQuick
import "."

Window {
    id: root
    width: 480
    height: 854
    visible: true

    property alias color: background.color

    default property alias content: windowContent.data

    // Read only property true if window is in portrait
    property alias inPortrait: window.portrait

    // Extendend API (for fremantle only)
    property bool allowSwitch: true
    property bool allowClose: true

    property Style platformStyle: WindowStyle {}

    signal orientationChangeAboutToStart
    signal orientationChangeStarted
    signal orientationChangeFinished

    Rectangle {
        id: background
        anchors.fill: parent
        color: platformStyle.colorBackground
    }

    Item {
        id: window
        property bool portrait

        //on Android, the screen resolution is resized by the system
        //width: window.portrait ? screen.displayHeight : screen.displayWidth
        //height: window.portrait ? screen.displayWidth : screen.displayHeight
        width: parent.width //screen.displayWidth
        height: parent.height//screen.displayHeight

        anchors.centerIn: parent

        MouseArea {
            id: switchButton
            enabled: allowSwitch
            z: platformStyle.buttonZIndex
            width: platformStyle.buttonWidth
            height: platformStyle.buttonHeight
            anchors {
                top: parent.top
                left: parent.left
                topMargin: platformStyle.buttonVerticalMargin
                leftMargin: platformStyle.buttonHorizontalMargin
            }
            onClicked: screen.minimized = true
        }

        MouseArea {
            id: closeButton
            enabled: true//allowClose && screen.allowSwipe
            z: platformStyle.buttonZIndex
            width: platformStyle.buttonWidth
            height: platformStyle.buttonHeight
            anchors {
                top: parent.top
                right: parent.right
                topMargin: platformStyle.buttonVerticalMargin
                rightMargin: platformStyle.buttonHorizontalMargin
            }
            onClicked: Qt.quit()
        }

        Item {
            id: windowContent
            width: parent.width
            height: parent.height - heightDelta

            // Used for resizing windowContent when virtual keyboard appears
            property int heightDelta: 0

            objectName: "windowContent"
            clip: true
        }

        SoftwareInputPanel {
            id: softwareInputPanel
            active: false//inputContext.customSoftwareInputPanelVisible
            anchors.bottom: parent.bottom

            onHeightChanged: {
                windowContent.heightDelta = height;
            }

            Loader {
                id: softwareInputPanelLoader
                width: parent.width
                source: ""//inputContext.customSoftwareInputPanelComponent
            }
        }

        /*Snapshot {
            id: snapshot
            anchors.centerIn: parent
            width: screen.displayWidth
            height: screen.displayHeight
            snapshotWidth: screen.displayWidth
            snapshotHeight: screen.displayHeight
            opacity: 0
        }*/

        state: ""//screen.orientationString

        // on Android, rotation works by screen resize & system handles
        // rotation animation, so we can skip this
        /**
        states: [
            State {
                name: "Landscape"
                PropertyChanges { target: window; rotation: 0; portrait: false; }
            },
            State {
                name: "Portrait"
                PropertyChanges { target: window; rotation: 270; portrait: true; }
            },
            State {
                name: "LandscapeInverted"
                PropertyChanges { target: window; rotation: 180; portrait: false; }
            },
            State {
                name: "PortraitInverted"
                PropertyChanges { target: window; rotation: 90; portrait: true; }
            }
        ] **/

        transitions: [
            Transition {
                // use this transition when sip is visible
                from: "disabled"//(inputContext.softwareInputPanelVisible ? "*" : "disabled")
                to: "disabled"//(inputContext.softwareInputPanelVisible ? "*" : "disabled")
                PropertyAction {
                    target: window
                    properties: "rotation"
                }
                ScriptAction {
                    script: {
                        root.orientationChangeAboutToStart();
                        platformWindow.startSipOrientationChange(window.rotation);
                        // note : we should really connect these signals to MInputMethodState
                        // signals so that they are emitted at the appropriate time
                        // but there aren't any
                        root.orientationChangeStarted();
                        root.orientationChangeFinished();
                    }
                }
            },
            Transition {
                // use this transition when sip is not visible
                from: "disabled"//(screen.minimized ? "disabled" : (inputContext.softwareInputPanelVisible ? "disabled" : "*"))
                to: "disabled" //(screen.minimized ? "disabled" : (inputContext.softwareInputPanelVisible ? "disabled" : "*"))
                SequentialAnimation {
                    alwaysRunToEnd: true

                    ScriptAction {
                        script: {
                            snapshot.take();
                            snapshot.opacity = 1.0;
                            snapshot.rotation = -window.rotation;
                            snapshot.smooth = false; // Quick & coarse rotation consistent with MTF
                            platformWindow.animating = true;
                            root.orientationChangeAboutToStart();
                        }
                    }
                    PropertyAction {
                        target: window
                        properties: "portrait"
                    }
                    ScriptAction {
                        script: {
                            windowContent.opacity = 0.0;
                            root.orientationChangeStarted();
                        }
                    }
                    ParallelAnimation {
                        NumberAnimation {
                            target: windowContent
                            property: "opacity"
                            to: 1.0
                            easing.type: Easing.InOutExpo
                            duration: 800
                        }
                        NumberAnimation {
                            target: snapshot
                            property: "opacity"
                            to: 0.0
                            easing.type: Easing.InOutExpo
                            duration: 800
                        }
                        RotationAnimation {
                            target: window
                            property: "rotation"
                            direction: RotationAnimation.Shortest
                            easing.type: Easing.InOutExpo
                            duration: 800
                        }
                    }
                    ScriptAction {
                        script: {
                            snapshot.free();
                            root.orientationChangeFinished();
                            platformWindow.animating = false;
                        }
                    }
                }
            }
        ]

        focus: true
        Keys.onReleased: event=> {
            if (event.key === Qt.Key_I && event.modifiers === Qt.AltModifier) {
                theme.inverted = !theme.inverted;
            }
            if (event.key === Qt.Key_E && event.modifiers === Qt.AltModifier) {
                if (screen.currentOrientation === Screen.Landscape) {
                    screen.allowedOrientations = Screen.Portrait;
                } else if (screen.currentOrientation === Screen.Portrait) {
                    screen.allowedOrientations = Screen.LandscapeInverted;
                } else if (screen.currentOrientation === Screen.LandscapeInverted) {
                    screen.allowedOrientations = Screen.PortraitInverted;
                } else if (screen.currentOrientation === Screen.PortraitInverted) {
                    screen.allowedOrientations = Screen.Landscape;
                }
            }
        }
    }
}
