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
import com.meego.components 1.0

Button {
    id: tabButton

    // Common public API
    property Item tab
    platformStyle: TabButtonStyle {}
    
    //Deprecated: TODO, remove this! 
    property alias style: tabButton.platformStyle

    property Item __tabGroup: tab !== null ? tab.parent : null

    Connections {
        target: __tabGroup
        function onCurrentTabChanged() {
            checked = __tabGroup.currentTab === tab;
        }
    }

    onClicked: privatePressed()

    function privatePressed() {
        if (tabButton.checkable) {
            tabButton.checked = !tabButton.checked;
        }    
        
        if (__tabGroup != null && 
            tab != null) {
            if (__tabGroup.currentTab === tab) {
                __tabGroup.currentTab.pop();
            } else {
                __tabGroup.currentTab = tab;
            }
        }		
    }
}
