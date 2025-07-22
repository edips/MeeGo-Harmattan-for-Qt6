import QtQuick
import com.meego.components 1.0

Popup {
    id: root

    // Common API
    default property alias content: contentField.children

    // Common API inherited from Popup:
    /*
        function open()
        function close()

        property Item visualParent
        property int status
    */

    // platformStyle API
    property Style platformStyle: MenuStyle{}
    property alias style: root.platformStyle // Deprecated
    property alias platformTitle: titleBar.children
    property alias title: titleBar.children // Deprecated
    property alias __footer: footerBar.children

    // private api
    property int __statusBarDelta: visualParent ? 0 :
                 __findItem( "appWindowContent") !== null ? 0 :
                 __findItem( "pageStackWindow") !== null && __findItem( "pageStackWindow").showStatusBar ? 36 * ScaleFactor : 0

    property string __animationChief: "abstractMenu"
    property int __pressDelay: platformStyle.pressDelay
    property alias __statesWrapper: statesWrapper
    property alias __menuPane: menuPane

    // This item will find the object with the given objectName ... or will return
    function __findItem( objectName ) {
        var next = parent;

        if (next != null) {
            while (next) {
                if(next.objectName === objectName){
                    return next;
                }

                next = next.parent;
            }
        }

        return null;
    }

    __dim: platformStyle.dim
    __fadeInDuration: platformStyle.fadeInDuration
    __fadeOutDuration: platformStyle.fadeOutDuration
    __fadeInDelay: platformStyle.fadeInDelay
    __fadeOutDelay: platformStyle.fadeOutDelay
    __faderBackground: platformStyle.faderBackground
    __fadeInEasingType: platformStyle.fadeInEasingType
    __fadeOutEasingType: platformStyle.fadeOutEasingType

    anchors.fill: parent

    // When application is minimized menu is closed.
    /*Connections {
        target: platformWindow
        function onActiveChanged() {
            if(!platformWindow.active)
                close()
        }
    }*/

    // This is needed for menus which are not instantiated inside the
    // content window of the PageStackWindow:
    Item {
        id: roundedCorners
        visible: root.status != DialogStatus.Closed && !visualParent
                 && __findItem( "pageStackWindow") !== null && __findItem( "pageStackWindow").platformStyle.cornersVisible
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: parent.height - __statusBarDelta - parseInt(2 * ScaleFactor)
        z: 10001

        // compensate for the widening of the edges of the fader (which avoids artefacts during rotation)
        anchors.topMargin:    +1
        anchors.rightMargin:  +1
        anchors.bottomMargin: +1
        anchors.leftMargin:   +1

        Image {
            anchors.top : parent.top
            anchors.left: parent.left
            source: "qrc:/images/meegotouch-applicationwindow-corner-top-left.png"
        }
        Image {
            anchors.top: parent.top
            anchors.right: parent.right
            source: "qrc:/images/meegotouch-applicationwindow-corner-top-right.png"
        }
        Image {
            anchors.bottom : parent.bottom
            anchors.left: parent.left
            source: "qrc:/images/meegotouch-applicationwindow-corner-bottom-left.png"
        }
        Image {
            anchors.bottom : parent.bottom
            anchors.right: parent.right
            source: "qrc:/images/meegotouch-applicationwindow-corner-bottom-right.png"
        }
    }

    // Shadows:
    Image {
        anchors.top : menuPane.top
        anchors.right: menuPane.left
        anchors.bottom : menuPane.bottom
        source: "qrc:/images/meegotouch-menu-shadow-left.png"
        visible: root.status !== DialogStatus.Closed
    }
    Image {
        anchors.bottom : menuPane.top
        anchors.left: menuPane.left
        anchors.right : menuPane.right
        source: "qrc:/images/meegotouch-menu-shadow-top.png"
        visible: root.status !== DialogStatus.Closed
    }
    Image {
        anchors.top : menuPane.top
        anchors.left: menuPane.right
        anchors.bottom : menuPane.bottom
        source: "qrc:/images/meegotouch-menu-shadow-right.png"
        visible: root.status !== DialogStatus.Closed
    }
    Image {
        anchors.top : menuPane.bottom
        anchors.left: menuPane.left
        anchors.right : menuPane.right
        source: "qrc:/images/meegotouch-menu-shadow-bottom.png"
        visible: root.status !== DialogStatus.Closed
    }

    Item {
        id: menuPane
        //ToDo: add support for layoutDirection Qt::RightToLeft
        x: platformStyle.leftMargin

        width:  parent.width - platformStyle.leftMargin - platformStyle.rightMargin  // ToDo: better width heuristic
        height: orientation.orientation === "Portrait" ?
                /* Portrait  */ titleBar.height + flickableContent.height + footerBar.height :
                /* Landscape */ parent.height - platformStyle.topMargin - platformStyle.bottomMargin - __statusBarDelta
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        visible: opacity !== 0.0

        state: __statesWrapper.state

        // Acts as debounce during orientation change.
        Behavior on height {NumberAnimation {duration:1}}

        BorderImage {
           id: backgroundImage
           source: // !enabled ? root.platformStyle.disabledBackground :
                   root.platformStyle.background
           anchors.fill : parent
           verticalTileMode : BorderImage.Repeat
           //border { left: 22; top: theme.inverted ? 124 : 22; right: 22; bottom: theme.inverted ? 2 : 22 }
           border { left: parseInt(ScaleFactor * 22); top: parseInt(ScaleFactor * 22); right: parseInt(ScaleFactor * 22); bottom: parseInt(ScaleFactor * 22) }
        }

        // this item contains the whole menu (content rectangle)
        Item {
            id: backgroundRect
            anchors.fill: parent

                Item {
                    id: titleBar
                    anchors.left: parent.left
                    anchors.right: parent.right

                    height: childrenRect.height
                }

                Item {
                    // Required to have the ScrollDecorator+Flickable handled
                    // by the column as a single item while keeping the
                    // ScrollDecorator working
                    id: flickableContent
                    anchors.left: parent.left
                    anchors.right: parent.right

                    anchors.top: backgroundRect.top
                    anchors.topMargin: titleBar.height
                    property int maxHeight : visualParent
                                             ? visualParent.height - platformStyle.topMargin - __statusBarDelta
                                               - footerBar.height - titleBar.height
                                             : root.parent
                                                     ? root.parent.height - platformStyle.topMargin - __statusBarDelta
                                                       - footerBar.height - titleBar.height
                                                     : parseInt(ScaleFactor * 350)

                    height: contentField.childrenRect.height + platformStyle.topPadding + platformStyle.bottomPadding < maxHeight
                            ? contentField.childrenRect.height + platformStyle.topPadding + platformStyle.bottomPadding
                            : maxHeight

                    Flickable {
                        id: flickable
                        anchors.fill: parent
                        contentWidth: parent.width
                        contentHeight: contentField.childrenRect.height + platformStyle.topPadding + platformStyle.bottomPadding
                        interactive: contentHeight > flickable.height
                        flickableDirection: Flickable.VerticalFlick
                        pressDelay: __pressDelay
                        clip: true

                        Item {
                            id: contentRect
                            height: contentField.childrenRect.height

                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: platformStyle.topPadding
                            anchors.bottomMargin: platformStyle.bottomPadding
                            anchors.leftMargin: platformStyle.leftPadding
                            anchors.rightMargin: platformStyle.rightPadding

                            Item {
                                id: contentField
                                anchors.fill: contentRect

                                function closeMenu() { root.close(); }
                            }
                        }
                    }
                    ScrollDecorator {
                        id: scrollDecorator
                        flickableItem: flickable
                    }
                }

                Item {
                    id: footerBar
                    anchors.left: parent.left
                    anchors.right: parent.right

                    anchors.top: backgroundRect.top
                    anchors.topMargin: titleBar.height + flickableContent.height
                    height: childrenRect.height
                }

        }
    }

    onPrivateClicked: close() // "reject()"

    StateGroup {
        id: statesWrapper

        state: "hidden"

        states: [
            State {
                name: "visible"
                when: root.__animationChief == "abstractMenu" && (root.status === DialogStatus.Opening || root.status === DialogStatus.Open)
                PropertyChanges {
                    target: __menuPane
                    opacity: 1.0
                }
            },
            State {
                name: "hidden"
                when: root.__animationChief == "abstractMenu" && (root.status === DialogStatus.Closing || root.status === DialogStatus.Closed)
                PropertyChanges {
                    target: __menuPane
                    opacity: 0.0
                }
            }
        ]

    }
}
