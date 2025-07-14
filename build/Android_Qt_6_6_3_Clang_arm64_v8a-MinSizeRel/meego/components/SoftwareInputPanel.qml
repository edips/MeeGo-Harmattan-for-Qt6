import QtQuick

Item {
    id: root
    width: parent.width
    height: 0

    objectName: "softwareInputPanel"

    property bool active: false

    states: State {
        when: active
        PropertyChanges { target: root; height: childrenRect.height; }
    }

    transitions: Transition {
        reversible: true
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutCubic; duration: 200 }
    }
}
