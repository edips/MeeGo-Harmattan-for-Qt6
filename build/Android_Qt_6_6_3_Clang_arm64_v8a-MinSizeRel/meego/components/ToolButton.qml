// ToolButton is a push-button style button intended for use with toolbars.

import QtQuick 2.1
import com.meego.components 1.0

Button {
    id: toolButton

    //Removes button background if set to true
    property bool flat: false

    property QtObject platformStyle: ToolButtonStyle { backgroundVisible: !toolButton.flat}

    //Deprecated item, REMOVE THIS
    property QtObject style: toolButton.platformStyle

    implicitWidth: platformStyle.buttonWidth
    implicitHeight: platformStyle.buttonHeight
}
