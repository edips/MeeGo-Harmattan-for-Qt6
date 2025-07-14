import QtQuick 2.1
import com.meego.components 1.0

/*
   Class: InfoBanner
   The InfoBanner component is used to display information to the user. The number of lines of text
   shouldn't exceed 3.
*/

Item {
    id: root

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
    property alias topMargin: root.y

    /*
     * Property: leftMargin
     * [int=8 pix] Allows user to customize left margin if needed
     */
    property alias leftMargin: root.x

    /*
     * Function: show
     * Show InfoBanner
     */
    function show() {
        parent = __findParent();

        var window = __findWindow();
        if(window !== null) root.pos.y = 8 + window.__statusBarHeight;

        animationShow.running = true;
        if (root.timerEnabled)
            sysBannerTimer.restart();
    }

    function __findParent() {
        var next = parent;
        while (next && next.parent && next.objectName !== "windowContent") {
            next = next.parent;
        }
        return next;
    }

    function __findWindow() {
        var result = null;
        for(var item = parent; item != null; item = item.parent) {
            if(item.objectName === 'pageStackWindow') {
                result = item;
                break;
            }
        }
        return result;
    }

    /*
     * Function: hide
     * Hide InfoBanner
     */
    function hide() {
        animationHide.running = true;
    }

    width: internal.getBannerHeight()
    height: internal.getBannerWidth()
    x:parseInt(8 * ScaleFactor); y:parseInt(8 * ScaleFactor)
    scale: 0

    Behavior on y {NumberAnimation {easing.type:Easing.InOutExpo;duration:500}}

    BorderImage {
        source: "image://theme/meegotouch-notification-system-background"
        anchors.fill: root
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
        border { left: parseInt(10 * ScaleFactor); top: parseInt(10 * ScaleFactor); right: parseInt(10 * ScaleFactor); bottom: parseInt(10 * ScaleFactor) }
        opacity: 1
    }

    Image {
        id: image
        anchors { left: parent.left; leftMargin: parseInt(16 * ScaleFactor); top: parent.top; topMargin: parseInt(16 * ScaleFactor) }
        source: root.iconSource
        visible: root.iconSource != ""
    }

    Text {
        id: text
        width: internal.getTextWidth()
        anchors { left: (image.visible ? image.right : parent.left); leftMargin: (image.visible ? 14:16);
            top: parent.top; topMargin: internal.getTopMargin(); bottom: parent.bottom }
        color: "white"
        wrapMode: Text.Wrap
        verticalAlignment: Text.AlignHCenter
        font.pixelSize: 24
        font.family: "Nokia Pure"
        font.letterSpacing: -1.2
        //maximumLineCount: 3
        elide: Text.ElideRight
    }

    QtObject {
        id: internal

        function getBannerHeight() {
            if (image.visible) {
                if (text.lineCount <= 2)
                    return parseInt(80 * ScaleFactor);
                else
                    return parseInt(80 * ScaleFactor); //106
            } else {
                if (text.lineCount <= 1)
                    return parseInt(80 * ScaleFactor); //64
                else if (text.lineCount <= 2)
                    return parseInt(80 * ScaleFactor);
                else
                    return parseInt(80 * ScaleFactor); //106
            }
        }

        function getBannerWidth() {
            if ( screen.currentOrientation===Screen.Portrait || screen.currentOrientation===Screen.PortraitInverted ) {
                // In portrait mode, the width of the banner is equal to the width of parent minus left
                // and right margins in-between banner and parent.
                return parent.width-root.x*2;
            } else {
                if (image.visible) {
                    // If an icon image is specified...
                    if ((image.width+text.paintedWidth+46) <= parent.width*0.54 && text.lineCount <= 1) {
                        // 46 is the sum of all horizontal margins within the banner. The above condition basically
                        // says that if there's only one line of text, and the sum of width of icon, text, and required
                        // margins is less then 54% of the screen width, banner width should be 54% of the screen.
                        return parent.width*0.54;
                    } else {
                        return parent.width-root.x*2;
                    }
                } else {
                    // If no icon image specified...
                    if ((text.paintedWidth+32) <= parent.width*0.54 && text.lineCount <= 1) {
                        // 32 is the sum of all horizontal margins within the banner. The above condition basically
                        // says that if there's only one line of text, and the sum of width of text and required
                        // margins is less then 54% of the screen width, banner width should be 54% of the screen.
                        return parent.width-root.x*2;
                    } else {
                        return parent.width-root.x*2;
                    }
                }
            }
        }

        function getTopMargin() {
            if (text.lineCount <= 1 && !image.visible) {
                // If there's only one line of text and no icon image, top and bottom margins are equal.
                return (root.height-text.paintedHeight)/2;
            } else {
                // In all other cases, top margin is 4 px more than bottom margin.
                return (root.height-text.paintedHeight)/2 + 2;
            }
        }

        function getTextWidth() {
            // 46(32 when there's no icon) is sum of all margins within banner. root.x*2 is sum of margins outside banner.
            // Text element width is dertermined by substracting parent width(screen width) by all the margins and
            // icon width(if applicable).
            return image.visible ? (parent.width-root.x*2-46-image.width) : (parent.width-root.x*2-32);
        }

        function getScaleValue() {
            // When banner is displayed, as part of transition effect, it'll first be enlarged to the point where its width
            // is equal to screen width. root.x*2/root.width calculates the amount of expanding required, where root.x*2 is
            // equal to screen.displayWidth minus banner.width
            return root.x*2/root.width + 1;
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
        anchors.fill: parent
        onClicked: hide()
    }

    SequentialAnimation {
        id: animationShow
        NumberAnimation { target: root; property: "scale"; from: 0; to: internal.getScaleValue(); duration: 200; easing.type: Easing.OutQuad}
        NumberAnimation { target: root; property: "scale"; from: internal.getScaleValue(); to: 1; duration: 200 }
    }

    NumberAnimation {
        id: animationHide
        target: root; property: "scale"; to: 0; duration: 200; easing.type: Easing.InExpo
    }

    Component.onCompleted: {
        //__owner = parent;
        var window = __findWindow();
        if(window !== null) {
            window.showStatusBarChanged.connect(function() {
                root.topMargin = parseInt(8 * ScaleFactor) + window.__statusBarHeight;
            });
        }
    }
}
