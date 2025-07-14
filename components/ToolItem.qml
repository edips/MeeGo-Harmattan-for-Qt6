// ToolItem is a component that is used to add actions to toolbars.

import QtQuick
import "."

ToolIcon {
    Component.onCompleted: {
	print("Warning: ToolItem is deprecated, use ToolIcon instead")
    }
}
