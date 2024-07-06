import QtQuick
import "components"

PageStackWindow {
    id: rootWindow
    initialPage: mainPage
    showStatusBar: false
    showToolBar: true

    /* trigger notification
       with a given message */
    function notify(text) {
        notification.text = text;
        notification.show();
    }
    /** Grey background **/
    Page {
        /** Window content **/
        id: mainPage
        anchors.fill: parent

        //tools: commonTools

        Button {
            id: btn
            anchors.centerIn: parent
            text: "Click me!"
            font.pixelSize: 15
            width: 300
            onClicked: {
                console.log("clicked");
                notify("Hello Meego! Long time no see");
            }
        }
    }

    /** Notification banner **/
    InfoBanner {
        id: notification
        timerShowTime: 5000
        height: 50//rootWindow.height / 5.0
        // prevent overlapping with status bar
        y: 8
    }
}
