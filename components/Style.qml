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
