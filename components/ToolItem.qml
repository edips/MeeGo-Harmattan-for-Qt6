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
import "."

ToolIcon {
    Component.onCompleted: {
	print("Warning: ToolItem is deprecated, use ToolIcon instead")
    }
}
