import QtQuick

// Background dimming
Rectangle {
    id: faderBackground

    property double dim: 0.9
    property int fadeInDuration: 250
    property int fadeOutDuration: 250

    property int fadeInDelay: 0
    property int fadeOutDelay: 0

    property int fadeInEasingType: Easing.InQuint
    property int fadeOutEasingType: Easing.OutQuint

    property string background: ""

    property Item visualParent: null
    property Item originalParent: parent

    // widen the edges to avoid artefacts during rotation
    anchors.topMargin:    -1
    anchors.rightMargin:  -1
    anchors.bottomMargin: -1
    anchors.leftMargin:   -1

    // opacity is passed to child elements - that is not, what we want
    // so we need to use alpha value here
    property double alpha: dim

    signal privateClicked

     //Deprecated, TODO Remove the following two lines on w13
    signal clicked
    onClicked: privateClicked()

    // we need the possibility to fetch the red, green, blue components from a color
    // see http://bugreports.qt.nokia.com/browse/QTBUG-14731
    color: background ? "transparent" : Qt.rgba(0.0, 0.0, 0.0, alpha)
    state: 'hidden'

    anchors.fill: parent

    // eat mouse events
    MouseArea {
        id: mouseEventEater
        anchors.fill: parent
        enabled: faderBackground.alpha != 0.0
        onClicked: { parent.privateClicked() }
    }

    Component {
        id: backgroundComponent
        BorderImage {
            id: backgroundImage
            source: background

            width: faderBackground.width
            height: faderBackground.height

            opacity: faderBackground.alpha
        }
    }
    Loader {id: backgroundLoader}

    onAlphaChanged: {
          if (background && faderBackground.alpha && backgroundLoader.sourceComponent == undefined) {
            backgroundLoader.sourceComponent = backgroundComponent;
          }
          if (!faderBackground.alpha) {
            backgroundLoader.sourceComponent = undefined;
          }
    }

    function findRoot() {
        var next = parent;

        if (next != null) {
            while (next.parent) {
                if(next.objectName === "appWindowContent" || next.objectName === "windowContent"){
                    break
                }

                next = next.parent;
            }
        }
        return next;
    }


    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: faderBackground
                alpha: dim
            }
        },
        State {
            name: "hidden"
            PropertyChanges {
                target: faderBackground
                alpha: 0.0
            }
        }
    ]
    
    transitions: [
        Transition {
            from: "hidden"; to: "visible"
            //reparent fader whenever it is going to be visible
            SequentialAnimation {
                ScriptAction {script: {
                        //console.log("=============00=============");
                        // the algorithm works in the following way:
                        // First:  Check if visualParent property is set; if yes, center the fader in visualParent
                        // Second: If not, center inside window content element
                        // Third:  If no window was found, use root window
                        originalParent = faderBackground.parent;
                        if (visualParent != null) {
                            faderBackground.parent = visualParent
                        } else {
                            var root = findRoot();
                            if (root !== null) {
                                faderBackground.parent = root;
                            } else {
                               // console.log("Error: Cannot find root");
                            }
                        }
                    }
                }
                PauseAnimation { duration: fadeInDelay }

                NumberAnimation {
                    properties: "alpha"
                    duration: faderBackground.fadeInDuration
                    easing.type: faderBackground.fadeInEasingType;
                }
            }
        },
        Transition {
            from: "visible"; to: "hidden"
            SequentialAnimation {
                PauseAnimation { duration: fadeOutDelay }

                NumberAnimation {
                    properties: "alpha"
                    duration: faderBackground.fadeOutDuration
                    easing.type: faderBackground.fadeOutEasingType;
                }
                ScriptAction {script: {
                        faderBackground.parent = originalParent;
                    }
                }
            }
        }
    ]
}



