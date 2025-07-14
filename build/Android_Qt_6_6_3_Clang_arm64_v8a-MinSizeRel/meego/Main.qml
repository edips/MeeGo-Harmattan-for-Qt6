import QtQuick 2.15
import com.meego.components 1.0
import "components"

PageStackWindow {
    id: rootWindow
    initialPage : mainPage
    showStatusBar : false
    showToolBar : true

    /* trigger notification
       with a given message */
    function notify(text) {
        notification.text = text;
        notification.show()
    }
    QueryDialog {
        id: quDialog
        onPrivateClicked: {}
        anchors.centerIn: parent
        titleText: "Modal Dialog"
        rejectButtonText: "Cancel"
        onRejected: { console.log ("Rejected");}
    }

    /** Grey background **/

    Page {
        /** Window content **/
        id : mainPage
        anchors.fill : parent
        tools : commonTools
        Flickable {
            anchors.topMargin : 10
            anchors.fill : parent
            //anchors.centerIn : parent
            Column {
                anchors.fill : parent
                spacing : 16
                Text {
                    text: "<h1>MeeGo is coming!</h1>"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: "hahhahahahaaaaa"
                    font.pixelSize : 25
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                TextField {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id : entryField
                    width : 180
                    height : 52
                    text : "image caption"
                }
                Image {
                    id : pysideImage
                    anchors.horizontalCenter: parent.horizontalCenter
                    width : 300
                    height : 157
                    smooth : true
                    // NOTE: the image provider name in the Image.source URL is automatically lower-cased !!
                    source : "qrc:/images/NokiaN9.jpg"
                    opacity: 0
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width : 200
                    id : startButton
                    text : "notification"
                    onClicked : {
                        rootWindow.notify("entry field content:<br><b>" + entryField.text + "</b>")
                    }
                }
            }
        }
    }


    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            iconId: "icon-m-toolbar-back"
            onClicked: {
                console.log("Back clicked")
                Qt.callLater(Qt.quit)
            }
        }
        ToolIcon { iconId: "icon-m-toolbar-refresh" }
        ToolIcon {
            iconId: "icon-m-toolbar-add"
            onClicked: {
                console.log("Add clicked")
                quDialog.open()
            }
        }
        ToolIcon { iconId: "icon-m-toolbar-image-edit-dimmed-white"
            onClicked : toolsMenu.open()
            Menu {
                id: toolsMenu
                visualParent: pageStack
                MenuLayout {
                    Label {
                        text : "Image rotation"
                    }
                    Slider {
                        stepSize : 1
                        minimumValue : 0
                        maximumValue : 360
                        valueIndicatorVisible : true
                        value : pysideImage.rotation
                        onValueChanged : {
                            pysideImage.rotation = value
                        }


                    }
                    Label {
                        text : "Image opacity"
                    }
                    Slider {
                        stepSize : 0.01
                        minimumValue : 0.0
                        maximumValue : 1.0
                        valueIndicatorVisible : true
                        value : pysideImage.opacity
                        onValueChanged : {
                            pysideImage.opacity = value
                        }
                    }
                }
            }
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }
    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("Sample menu item 1") }
            MenuItem { text: qsTr("Sample menu item 2") }
            MenuItem { text: qsTr("Sample menu item 3") }
            MenuItem { text: qsTr("Sample menu item 4") }
            MenuItem { text: qsTr("Sample menu item 5") }
        }
    }

    /** Notification banner **/

    InfoBanner {
        id: notification
        //timerShowTime : 5000
        height : rootWindow.height/5.0
        // prevent overlapping with status bar
        y : 8

    }
}
