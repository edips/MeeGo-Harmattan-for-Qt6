// The ToolBar is a container for toolbar items such as ToolItem or ToolButton.

import QtQuick
import "UIConstants.js" as UI
import "."

Item {
    id: root
    property int baseHeight: 72 // Pixel size of the border image source

    width: parent ? parent.width : 0
    height: parseInt(baseHeight * ScaleFactor)

    // Dummy property to allow qt component deprecated API clients to fail more gracefully
    property bool __hidden: false

    property int privateVisibility: 0//ToolBarVisibility.Visible

    // Styling for the ToolBar
    property Style platformStyle: ToolBarStyle {}

    // Deprecated, TODO remove
    property alias style: root.platformStyle

    // Shadows:
    Image {
        anchors.top: bgImage.top
        anchors.right: bgImage.left
        anchors.bottom: bgImage.bottom
        source: "qrc:/images/meegotouch-menu-shadow-left.png"
    }
    Image {
        anchors.bottom: bgImage.top
        anchors.left: bgImage.left
        anchors.right: bgImage.right
        source: "qrc:/images/meegotouch-menu-shadow-top.png"
    }
    Image {
        anchors.top: bgImage.top
        anchors.left: bgImage.right
        anchors.bottom: bgImage.bottom
        source: "qrc:/images/meegotouch-menu-shadow-right.png"
    }
    Image {
        anchors.top: bgImage.bottom
        anchors.left: bgImage.left
        anchors.right: bgImage.right
        source: "qrc:/images/meegotouch-menu-shadow-bottom.png"
    }
    // Toolbar background.
    BorderImage {
        id: bgImage
        width: root.width
        height: root.baseHeight * ScaleFactor
        border.left: parseInt(10 * ScaleFactor)
        border.right: parseInt(10 * ScaleFactor)
        border.top: parseInt(10 * ScaleFactor)
        border.bottom: parseInt(10 * ScaleFactor)
        source: "qrc:/images/meegotouch-toolbar-portrait-background.png"

        // Mousearea that eats clicks so they don't go through the toolbar to content
        // that may exist below it in z-order, such as unclipped listview items.
        MouseArea {
            anchors.fill: parent
        }
    }

    states: [
        // Inactive state.
        State {
            name: "hidden"
            when: tools == null
            PropertyChanges {
                target: root
                height: 0
            }
        },
        State {
            name: "HiddenImmediately"
            when: false
            PropertyChanges {
                target: root
                height: 0
            }
        },
        State {
            name: ""
            when: true
            PropertyChanges {
                target: root
                height: parseInt(root.baseHeight * ScaleFactor)
            }
        }
    ]

    transitions: [
        // Transition between active and inactive states.
        Transition {
            from: ""
            to: "hidden"
            reversible: true
            ParallelAnimation {
                PropertyAnimation {
                    properties: "height"
                    easing.type: Easing.InOutExpo
                    duration: platformStyle.visibilityTransitionDuration
                }
            }
        }
    ]

    // The current set of tools.
    property Item tools: null

    onToolsChanged: {
        __performTransition(__transition || transition);
        __transition = undefined;
    }

    // The transition type. One of the following:
    //      set         an instantaneous change (default)
    //      push        follows page stack push animation
    //      pop         follows page stack pop animation
    //      replace     follows page stack replace animation
    property string transition: "set"

    // The currently displayed container; null if none.
    property Item __currentContainer: null

    // Alternating containers used for transitions.
    property Item __containerA: null
    property Item __containerB: null

    // The transition to perform next.
    property variant __transition

    // Sets the tools with a transition.
    function setTools(tools, transition) {
        __transition = transition;
        root.tools = tools;
    }

    // Performs a transition between tools in the toolbar.
    function __performTransition(transition) {
        // lazily create containers if they have not been created
        if (!__currentContainer) {
            // Parent is bgImage because it doesn't change height when toolbar gets hidden
            __containerA = containerComponent.createObject(bgImage);
            __containerB = containerComponent.createObject(bgImage);
            __currentContainer = __containerB;
        }

        // no transition if the tools are unchanged
        if (__currentContainer.tools === tools) {
            return;
        }

        // select container states based on the transition animation
        var transitions = {
            "set": {
                "new": "",
                "old": "hidden"
            },
            "push": {
                "new": "right",
                "old": "left"
            },
            "pop": {
                "new": "left",
                "old": "right"
            },
            "replace": {
                "new": "front",
                "old": "back"
            }
        };
        var animation = transitions[transition];

        // initialize the free container
        var container = __currentContainer == __containerA ? __containerB : __containerA;
        container.state = "hidden";
        if (tools) {
            container.tools = tools;
            container.owner = tools.parent;
            tools.parent = container;
            tools.visible = true;
        }

        // perform transition
        __currentContainer.state = animation["old"];
        if (tools) {
            container.state = animation["new"];
            container.state = "";
        }
        __currentContainer = container;
    }

    // Component for toolbar containers.
    Component {
        id: containerComponent

        Item {
            id: container

            width: parent ? parent.width : 0
            height: parent ? parent.height : 0

            // The states correspond to the different possible positions of the container.
            state: "hidden"

            // The tools held by this container.
            property Item tools: null
            // The owner of the tools.
            property Item owner: null

            states: [
                // Start state for pop entry, end state for push exit.
                State {
                    name: "left"
                    PropertyChanges {
                        target: container
                        x: -30
                        opacity: 0.0
                    }
                },
                // Start state for push entry, end state for pop exit.
                State {
                    name: "right"
                    PropertyChanges {
                        target: container
                        x: 30
                        opacity: 0.0
                    }
                },
                // Start state for replace entry.
                State {
                    name: "front"
                    PropertyChanges {
                        target: container
                        scale: 1.25
                        opacity: 0.0
                    }
                },
                // End state for replace exit.
                State {
                    name: "back"
                    PropertyChanges {
                        target: container
                        scale: 0.85
                        opacity: 0.0
                    }
                },
                // Inactive state.
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: container
                        visible: false
                    }
                    StateChangeScript {
                        script: {
                            if (container.tools) {
                                // re-parent back to original owner
                                tools.visible = false;
                                tools.parent = owner;

                                // reset container
                                container.tools = container.owner = null;
                            }
                        }
                    }
                }
            ]

            transitions: [
                // Pop entry and push exit transition.
                Transition {
                    from: ""
                    to: "left"
                    reversible: true
                    SequentialAnimation {
                        PropertyAnimation {
                            properties: "x,opacity"
                            easing.type: Easing.InCubic
                            duration: platformStyle.contentTransitionDuration / 2
                        }
                        PauseAnimation {
                            duration: platformStyle.contentTransitionDuration / 2
                        }
                        ScriptAction {
                            script: if (state == "left")
                                state = "hidden"
                        }
                    }
                },
                // Push entry and pop exit transition.
                Transition {
                    from: ""
                    to: "right"
                    reversible: true
                    SequentialAnimation {
                        PropertyAnimation {
                            properties: "x,opacity"
                            easing.type: Easing.InCubic
                            duration: platformStyle.contentTransitionDuration / 2
                        }
                        PauseAnimation {
                            duration: platformStyle.contentTransitionDuration / 2
                        }
                        ScriptAction {
                            script: if (state == "right")
                                state = "hidden"
                        }
                    }
                },
                Transition {
                    // Replace entry transition.
                    from: "front"
                    to: ""
                    SequentialAnimation {
                        PropertyAnimation {
                            properties: "scale,opacity"
                            easing.type: Easing.InOutExpo
                            duration: platformStyle.contentTransitionDuration
                        }
                    }
                },
                Transition {
                    // Replace exit transition.
                    from: ""
                    to: "back"
                    SequentialAnimation {
                        PropertyAnimation {
                            properties: "scale,opacity"
                            easing.type: Easing.InOutExpo
                            duration: platformStyle.contentTransitionDuration
                        }
                        ScriptAction {
                            script: if (state == "back")
                                state = "hidden"
                        }
                    }
                }
            ]
        }
    }
}
