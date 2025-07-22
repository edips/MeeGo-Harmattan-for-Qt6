import QtQuick
import "constants.js" as UI

/*
   Class: InfoBanner
   The InfoBanner component is used to display information to the user. The number of lines of text
   shouldn't exceed 3.
*/

Item {
    id: root

    visible: false

    /*
     * Property: iconSource
     * [url] The path to the icon image
     */
    property url iconSource: ""

    /*
     * Property: text
     * [string] Text to be displayed in InfoBanner
     */
    property alias text: text.text

    /*
     * Property: timerEnabled
     * [bool=true] Enable/disable timer that dismisses InfoBanner
     */
    property bool timerEnabled: true

    /*
     * Property: timerShowTime
     * [int=3000ms] For setting how long InfoBanner stays visible to user before being dismissed
     */
    property alias timerShowTime: sysBannerTimer.interval

    /*
     * Property: topMargin
     * [int=8 pix] Allows user to customize top margin if needed
     */


    property int topMargin: parseInt(8 * ScaleFactor)
    y: topMargin

    /*
     * Property: leftMargin
     * [int=8 pix] Allows user to customize left margin if needed
     */
    //property alias leftMargin: root.x
    property int leftMargin: parseInt(8 * ScaleFactor)
    x: leftMargin
    /*
     * Function: show
     * Show InfoBanner
     */
    function show() {
        root.visible = true
        animationShow.running = true;
        if (root.timerEnabled)
            sysBannerTimer.restart();
    }

    /*
     * Function: hide
     * Hide InfoBanner
     */
    function hide() {
        animationHide.running = true;
    }

    implicitHeight: internal.getBannerHeight()
    implicitWidth: internal.getBannerWidth()
    //x: parseInt(8 * ScaleFactor)
    //y: parseInt(8 * ScaleFactor)
    scale: 0

    BorderImage {
        source: "qrc:images/meegotouch-notification-system-background.png"
        anchors.fill: root
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        border {
            left: parseInt(10 * ScaleFactor)
            top: parseInt(10 * ScaleFactor)
            right: parseInt(10 * ScaleFactor)
            bottom: parseInt(10 * ScaleFactor)
        }
        opacity: UI.INFO_BANNER_OPACITY
    }

    Image {
        id: image
        anchors {
            left: parent.left
            leftMargin: parseInt(16 * ScaleFactor)
            top: parent.top
            topMargin: parseInt(16 * ScaleFactor)
        }
        source: root.iconSource
        visible: root.iconSource !== ""
    }

    Text {
        id: text
        width: internal.getTextWidth()
        anchors {
            left: (image.visible ? image.right : parent.left)
            leftMargin: (image.visible ? parseInt(14 * ScaleFactor) : parseInt(16 * ScaleFactor) )
            top: parent.top
            topMargin: (text.lineCount <= 1 && !image.visible ? parseInt(16 * ScaleFactor) : parseInt(18 * ScaleFactor))//internal.getTopMargin()
            bottom: parent.bottom
        }
        color: "white"
        wrapMode: Text.Wrap
        verticalAlignment: Text.AlignHCenter
        font.pixelSize: UI.FONT_DEFAULT_SIZE
        font.family: UI.FONT_FAMILY
        font.letterSpacing: UI.INFO_BANNER_LETTER_SPACING
        maximumLineCount: 3
        elide: Text.ElideRight
    }

    QtObject {
        id: internal

        function getBannerHeight() {
            if (image.visible) {
                if (text.lineCount <= 2)
                    return parseInt(80 * ScaleFactor);
                else
                    return parseInt(106 * ScaleFactor);
            } else {
                if (text.lineCount <= 1)
                    return parseInt(64 * ScaleFactor);
                else if (text.lineCount <= 2)
                    return parseInt(80 * ScaleFactor);
                else
                    return parseInt(106 * ScaleFactor);
            }
        }

        function getBannerWidth() {
            return parent.width - root.x * 2;
        }
        // gives error: QML QQuickAnchors: Binding loop detected for property "topMargin"
        function getTopMargin() {
            if (text.lineCount <= 1 && !image.visible) {
                console.log("Look here1")
                // If there's only one line of text and no icon image, top and bottom margins are equal.
                return (root.height - text.paintedHeight) / 2;
            } else {
                console.log("Look here2")
                // In all other cases, top margin is 4 px more than bottom margin.
                return (root.height - text.paintedHeight) / 2 + 2;
            }
        }

        function getTextWidth() {
            // 46(32 when there's no icon) is sum of all margins within banner. root.x*2 is sum of margins outside banner.
            // Text element width is dertermined by substracting parent width(screen width) by all the margins and
            // icon width(if applicable).
            return image.visible ? (parent.width - root.x * 2 - parseInt(46 * ScaleFactor) - image.width) : (parent.width - root.x * 2 - parseInt(32 * ScaleFactor) );
        }

        function getScaleValue() {
            // When banner is displayed, as part of transition effect, it'll first be enlarged to the point where its width
            // is equal to screen width. root.x*2/root.width calculates the amount of expanding required, where root.x*2 is
            // equal to screen.displayWidth minus banner.width
            return root.x * 2 / root.width + 1;
        }
    }

    Timer {
        id: sysBannerTimer
        repeat: false
        running: false
        interval: 3000
        onTriggered: hide()
    }

    MouseArea {
        id: mouseInfo
        anchors.fill: parent
        onClicked: hide()
        enabled: root.visible
    }

    SequentialAnimation {
        id: animationShow
        NumberAnimation {
            target: root
            property: "scale"
            from: 0
            to: internal.getScaleValue()
            duration: 200
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            target: root
            property: "scale"
            from: internal.getScaleValue()
            to: 1
            duration: 200
        }
    }

    NumberAnimation {
        id: animationHide
        target: root
        property: "scale"
        to: 0
        duration: 200
        easing.type: Easing.InExpo
        onFinished: {
            root.visible = false
        }
    }
}
