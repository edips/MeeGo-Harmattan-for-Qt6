// ToolItem is a component that is used to add actions to toolbars.

import QtQuick
import "."

Item {
    id: root
    property url iconSource
    property string platformIconId

    // TODO: deprecated
    property alias iconId: root.platformIconId
    //width: 66; height: 50
    width: parseInt(80 * ScaleFactor); height: parseInt(64 * ScaleFactor)
    signal clicked

    // Styling for the ToolItem
    property Style platformStyle: ToolItemStyle{}

    // TODO: deprecated
    //property Style style: root.platformStyle

    Image {
        source: mouseArea.pressed ? platformStyle.pressedBackground : ""
        anchors.centerIn: parent

        Image {
            function handleIconSource(iconId) {
                if (iconSource != "")
                    return iconSource;

                var prefix = "icon-m-"
                // check if id starts with prefix and use it as is
                // otherwise append prefix and use the inverted version if required

                if (iconId.indexOf(prefix) !== 0)
                    iconId =  prefix.concat(iconId).concat("-white.png");

                // Uncomment this when theme deamon works
                /*
                if (iconId.indexOf(prefix) !== 0)
                    iconId =  prefix.concat(iconId).concat(theme.inverted ? "-white.png" : "");
                */


                return "qrc:/images/" + iconId;
            }

            source: handleIconSource(iconId)
            anchors.centerIn: parent
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            parent.clicked()
        }
    }
}
