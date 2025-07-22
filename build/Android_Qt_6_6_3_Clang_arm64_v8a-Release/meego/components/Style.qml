import QtQuick

QtObject {
    id: styleClass
    // Settings
    property bool inverted: false
    property string __invertedString: inverted ? "-inverted" : ""
    //property string __colorString: theme.colorString
    property string __colorString: ""

    // some style classes like SelectionDialogStyle are using nested elements (for example Text),
    // which isn't allowed by QtObject; this fix makes this possible
    default property alias children: styleClass.__defaultPropertyFix
    property list<QtObject> __defaultPropertyFix: [
        Item {}
    ] //QML doesn't allow an empty list here

}
