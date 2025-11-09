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

// ToolButton is a push-button style button intended for use with toolbars.

import QtQuick
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
