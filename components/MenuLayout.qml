import QtQuick 2.1
import com.meego.components 1.0

Item {
    id: root
    anchors.left: parent!==undefined?parent.left:undefined
    anchors.right: parent!==undefined?parent.right:undefined
    height: menuItemColumn.height

    default property alias menuChildren: menuItemColumn.children

    Column {
        id: menuItemColumn

        anchors.left: parent.left
        anchors.right: parent.right
        height: childrenRect.height

        function closeLayout() {
            root.parent.closeMenu();
        }
    }
}
