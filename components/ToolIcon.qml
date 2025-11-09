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

// ToolItem is a component that is used to add actions to toolbars.
import QtQuick
import com.meego.components 1.0
import "."

Item {
    id: root
    property url iconSource
    property string platformIconId

    // TODO: deprecated
    property alias iconId: root.platformIconId
    //width: 66; height: 50
    width: Device.gridUnit - 6; height: Device.gridUnit - 14
    signal clicked

    // Styling for the ToolItem
    property Style platformStyle: ToolItemStyle{}

    // TODO: deprecated
    //property Style style: root.platformStyle

    Image {
        source: mouseArea.pressed ? platformStyle.pressedBackground : ""
        anchors.centerIn: parent

        Image {
            width: Device.gridUnit - 14
            height: Device.gridUnit - 14
            function handleIconSource(iconId) {
                if (iconSource != "")
                    return iconSource;

                var prefix = "icon-m-"
                // check if id starts with prefix and use it as is
                // otherwise append prefix and use the inverted version if required

                if (iconId.indexOf(prefix) !== 0)
                    iconId =  prefix.concat(iconId).concat(".png");

                // Uncomment this when theme deamon works
                /*
                if (iconId.indexOf(prefix) !== 0)
                    iconId =  prefix.concat(iconId).concat(theme.inverted ? ".png" : "");
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
