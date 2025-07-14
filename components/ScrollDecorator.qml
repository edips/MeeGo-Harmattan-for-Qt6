import QtQuick
import com.meego.components 1.0
import "."
import "UIConstants.js" as UI

/**
  * Class: ScrollDecorator
  * A ScrollDecorator shows the current position in a scrollable area.
  */
Item {
    id: root

    /**
      * Property: flickableItem
      * [Flickable] The Item that should show the ScrollDecorator
      */
    property Flickable flickableItem

    property int __topPageMargin: 0
    property int __bottomPageMargin: 0
    property int __leftPageMargin: 0
    property int __rightPageMargin: 0
    property bool __hasPageWidth : false
    property bool __hasPageHeight: false

    // These can also be modified (but probably shouldn't)
    property int __minIndicatorSize: parseInt(20 * ScaleFactor)
    property int __hideTimeout: 500

    property bool __alwaysShowIndicator: true

    property Style platformStyle: ScrollDecoratorStyle{}

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    // This function ensures that we allways anchor the decorator correctly according
    // to the page margins.
    function __updatePageMargin() {
        if (!flickableItem)
            return
        var p = flickableItem.parent
        while (p) {
            if (p.hasOwnProperty("__isPage")) {
                __hasPageHeight = function() { return p.height == flickableItem.height }
                __hasPageWidth = function() { return p.width == flickableItem.width }
                __topPageMargin = function() { return p.anchors.topMargin }
                __bottomPageMargin = function() { return p.anchors.bottomMargin }
                __leftPageMargin = function() { return p.anchors.leftMargin }
                __rightPageMargin = function() { return p.anchors.rightMargin }
                return;
            } else {
                p = p.parent;
            }
        }
    }

    onFlickableItemChanged: { __updatePageMargin() }

    QtObject {
        id: privateApi
        function canFlick(direction) {
           return flickableItem.flickableDirection === direction
                  || flickableItem.flickableDirection === Flickable.HorizontalAndVerticalFlick
                  || flickableItem.flickableDirection === Flickable.AutoFlickDirection;
        }
    }

    // Private stuff
    anchors.fill: flickableItem

    Timer {
        // Hack to have the indicators flash when the view is shown the first time.
        // Ideally we would wait until the Flickable is complete, but it doesn't look
        // possible given the current limitations of QML.
        interval: 100
        running: true
        repeat: false
        onTriggered: {
            if (verticalIndicator.shouldShow) {
                verticalIndicator.state = "visible";
                verticalIndicator.state = "";
            }
            if (horizontalIndicator.shouldShow) {
                horizontalIndicator.state = "visible";
                horizontalIndicator.state = "";
            }
        }
    }

    Component {
       id: verticalSizerWrapper
        ScrollDecoratorSizerCPP {
            id: verticalSizer
            positionRatio: flickableItem ? flickableItem.visibleArea.yPosition : 0
            sizeRatio: flickableItem ? flickableItem.visibleArea.heightRatio : 0
            maxPosition: flickableItem ? flickableItem.height : 0
            minSize: __minIndicatorSize
        }
   }

    Component {
        id: horizontalSizerWrapper
        ScrollDecoratorSizerCPP {
            id: horizontalSizer
            positionRatio: flickableItem ? flickableItem.visibleArea.xPosition : 0
            sizeRatio: flickableItem ? flickableItem.visibleArea.widthRatio : 0
            maxPosition: flickableItem ? flickableItem.width : 0
            minSize: __minIndicatorSize
        }
    }

    Loader {id: verticalSizerLoader}
    Loader {id: horizontalSizerLoader}

    Item {
        id: verticalIndicator
        property bool shouldShow: flickableItem != null && ((__alwaysShowIndicator && privateApi.canFlick(Flickable.VerticalFlick)) && (flickableItem.height > 0 && flickableItem.contentHeight > flickableItem.height))
        opacity: 0
        anchors.right: parent.right
        anchors.rightMargin: UI.SCROLLDECORATOR_LONG_MARGIN - (__hasPageWidth ? __rightPageMargin : 0)
        anchors.top: parent.top
        anchors.topMargin: UI.SCROLLDECORATOR_SHORT_MARGIN - (__hasPageWidth ? __topPageMargin : 0)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: UI.SCROLLDECORATOR_SHORT_MARGIN - (__hasPageWidth ? __bottomPageMargin : 0)

        onShouldShowChanged: {
            if (shouldShow)
                verticalSizerLoader.sourceComponent = verticalSizerWrapper;
            else
                verticalSizerLoader.sourceComponent = undefined;
        }

        Image {
            source: platformStyle.background
            height: parent.height
            anchors.right: parent.right
        }
        BorderImage {
            source: platformStyle.indicator
            border { left: 2; top: 4; right: 2; bottom: 4 }
            anchors.right: parent.right
            y:      verticalIndicator.shouldShow && verticalSizerLoader.status == Loader.Ready ? verticalSizerLoader.item.position : 0
            height: verticalIndicator.shouldShow && verticalSizerLoader.status == Loader.Ready ?
                    verticalSizerLoader.item.size - parent.anchors.topMargin - parent.anchors.bottomMargin : 0
        }

        states: State {
            name: "visible"
            when: verticalIndicator.shouldShow && flickableItem.moving
            PropertyChanges {
                target: verticalIndicator
                opacity: 1
            }
        }

        transitions: Transition {
            from: "visible"; to: ""
            NumberAnimation {
                properties: "opacity"
                duration: root.__hideTimeout
            }
        }
    }

    Item {
        id: horizontalIndicator
        property bool shouldShow: flickableItem != null && ((__alwaysShowIndicator && privateApi.canFlick(Flickable.HorizontalFlick)) && (flickableItem.width > 0 && flickableItem.contentWidth > flickableItem.width))
        opacity: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: UI.SCROLLDECORATOR_LONG_MARGIN - (__hasPageHeight  ? __bottomPageMargin : 0)
        anchors.right: parent.right
        anchors.rightMargin: UI.SCROLLDECORATOR_SHORT_MARGIN - (__hasPageHeight  ? __rightPageMargin : 0)
        anchors.left: parent.left
        anchors.leftMargin: UI.SCROLLDECORATOR_SHORT_MARGIN - (__hasPageHeight  ? __leftPageMargin : 0)

        onShouldShowChanged: {
            if (shouldShow)
                horizontalSizerLoader.sourceComponent = horizontalSizerWrapper;
            else
                horizontalSizerLoader.sourceComponent = undefined;
        }

        Image {
            source: platformStyle.backgroundHorizontal
            width: parent.width
            anchors.left: parent.left
            anchors.bottom: parent.bottom
        }
        BorderImage {
            source: platformStyle.indicatorHorizontal
            border { left: 4; top: 2; right: 4; bottom: 2 }
            anchors.bottom: parent.bottom
            x:     horizontalIndicator.shouldShow && horizontalSizerLoader.status == Loader.Ready ? horizontalSizerLoader.item.position : 0
            width: horizontalIndicator.shouldShow && horizontalSizerLoader.status == Loader.Ready ?
                    horizontalSizerLoader.item.size - parent.anchors.leftMargin - parent.anchors.rightMargin : 0
        }

        states: State {
            name: "visible"
            when: horizontalIndicator.shouldShow && flickableItem.moving
            PropertyChanges {
                target: horizontalIndicator
                opacity: 1
            }
        }

        transitions: Transition {
            from: "visible"; to: ""
            NumberAnimation {
                properties: "opacity"
                duration: root.__hideTimeout
            }
        }
    }
}

