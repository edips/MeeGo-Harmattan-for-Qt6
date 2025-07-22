import QtQuick 2.15 // Ensure QtQuick 2.15 or higher for modern QML features
import com.meego.components 1.0
import "EditBubble.js" as PopupJS // Import JS for functions
import "Magnifier.js" as MagnifierJS // Import JS for functions

Window2 {
    id: window

    property bool showStatusBar: true
    property bool showToolBar: true
    property variant initialPage
    property alias pageStack: stack
    property Style platformStyle: PageStackWindowStyle {}

    //Deprecated, TODO Remove this on w13
    property alias style: window.platformStyle

    //private api
    property int __statusBarHeight: showStatusBar ? statusBar.height : 0

    objectName: "pageStackWindow"

    StatusBar {
        id: statusBar
        anchors.top: parent.top
        width: parent.width
        showStatusBar: window.showStatusBar
    }

    Rectangle {
        id: background
        visible: platformStyle.background === ""
        color: platformStyle.backgroundColor
        width: parent.width
        height: parent.height
        anchors {
            top: statusBar.bottom
            left: parent.left
        }
    }

    Image {
        id: backgroundImage
        visible: platformStyle.background !== ""
        source: window.inPortrait ? platformStyle.portraitBackground : platformStyle.landscapeBackground
        fillMode: platformStyle.backgroundFillMode
        width: parent.width
        height: parent.height
        anchors {
            top: statusBar.bottom
            left: parent.left
        }
    }

    Item {
        objectName: "appWindowContent"
        width: parent.width
        anchors.top: statusBar.bottom
        anchors.bottom: parent.bottom

        // content area
        Item {
            id: contentArea
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            anchors.bottomMargin: toolBar.visible || (toolBar.opacity === 1) ? toolBar.height : 0
            PageStack {
                id: stack
                anchors.fill: parent
                toolBar: toolBar
            }
        }

        Item {
            id: roundedCorners
            visible: platformStyle.cornersVisible
            anchors.fill: parent
            z: 0

            Image {
                anchors.top: parent.top
                anchors.left: parent.left
                source: "qrc:/images/meegotouch-applicationwindow-corner-top-left.png"
            }
            Image {
                anchors.top: parent.top
                anchors.right: parent.right
                source: "qrc:/images/meegotouch-applicationwindow-corner-top-right.png"
            }
            Image {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                source: "qrc:/images/meegotouch-applicationwindow-corner-bottom-left.png"
            }
            Image {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                source: "qrc:/images/meegotouch-applicationwindow-corner-bottom-right.png"
            }
        }

        ToolBar {
            id: toolBar
            anchors.bottom: parent.bottom
            privateVisibility: 0
        }

        // --- CHANGE START: Moved EditBubble and Magnifier inside appWindowContent ---
        EditBubble {
            id: globalEditBubble
            // Initially hidden, will be made visible by EditBubble.js
            visible: false
            // Parent is now implicitly appWindowContent
            z: 100 // Ensure it's above other content but below other specific popups
        }

        Magnifier {
            id: globalMagnifier
            // Initially hidden, will be made visible by Magnifier.js
            visible: false
            // Parent is now implicitly appWindowContent
            z: 101 // Ensure it's above the edit bubble
        }
        // --- CHANGE END ---
    }

    // event preventer when page transition is active
    MouseArea {
        anchors.fill: parent
        enabled: pageStack.busy
    }

    Component.onCompleted: {
        if (initialPage)
            pageStack.push(initialPage);

        // Initialize JS singletons with pre-instantiated QML objects
        PopupJS.init(globalEditBubble);
        MagnifierJS.init(globalMagnifier);
    }
}
