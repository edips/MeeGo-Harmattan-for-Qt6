import QtQuick
import "UIConstants.js" as UI

Text {
    id: root

    // Styling for the Button
    property Style platformStyle: LabelStyle {}

    //Deprecated, TODO Remove this on w13
    //property alias style: root.platformStyle

    font.family: platformStyle.fontFamily
    font.pixelSize: platformStyle.fontPixelSize
    color: platformStyle.textColor

    wrapMode: Text.Wrap
}
