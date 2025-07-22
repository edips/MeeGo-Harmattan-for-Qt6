import QtQuick

Item {
    id: root

    property alias text: label.current
    property alias up: label.up
    property bool highlighted: false

    width: wrapper.width
    height: wrapper.height

    property Style platformStyle: SectionScrollerStyle {}

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    Item {
        id: wrapper

        clip: true
        height: label.height

        Text {
            id: label

            property string current: ""
            property bool up: true
            property int shift: 30

            height: parseInt(60 * ScaleFactor)
            width: parent.width - parseInt(40 * ScaleFactor)
            text: ""
            x: 20
            color: root.highlighted ? root.platformStyle.textColorHighlighted : root.platformStyle.textColor
            font {
                bold: root.platformStyle.fontBoldProperty
                pixelSize: root.platformStyle.fontPixelSize
            }
            verticalAlignment: Text.AlignVCenter
            onCurrentChanged: {
                text = current;
            }
            onTextChanged: {
                var w = paintedWidth
                parent.width = w + parseInt(40 * ScaleFactor);
            }

            Behavior on current {
                SequentialAnimation {
                    NumberAnimation { target: label; property: "y"; to: label.up ? label.shift : -label.shift; duration: 50 }
                    PropertyAction { target: label; property: "y"; value: label.up ? -label.shift : label.shift }
                    NumberAnimation { target: label; property: "y"; to: 0; duration: 50 }
                }
            }
        }
    }
}
