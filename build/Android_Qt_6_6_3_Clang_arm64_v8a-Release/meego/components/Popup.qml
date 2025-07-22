import QtQuick
import com.meego.components 1.0
import "."

Item {
    id: root
    visible: false

    // api
    property alias visualParent: fader.visualParent

    // possible states: Opening, Open, Closing, Closed
    // Opening and Closing are used during animation (when the dialog fades/moves/pops/whatever in)
    property int status: DialogStatus.Closed

    // private api
    property double __dim: 0.9
    property int __fadeInDuration
    property int __fadeOutDuration
    property int __fadeInDelay
    property int __fadeOutDelay
    property int __fadeInEasingType
    property int __fadeOutEasingType
    property string __faderBackground

    property bool __platformModal: false

    function open() {
        if (status === DialogStatus.Closed) {
            status = DialogStatus.Opening;
            root.visible = true
        }
    }

    function close() {
        if (status === DialogStatus.Open) {
            status = DialogStatus.Closing;
            root.visible = false
        }
    }

    signal privateClicked

    //Deprecated, TODO Remove the following two lines on w13
   signal clicked
   onClicked: {privateClicked();}

    QtObject {
        id: parentCache
        property QtObject oldParent: null
    }

    Component.onCompleted: {
        parentCache.oldParent = parent;
        fader.parent = parent;
        parent = fader;
        //fader.privateClicked.connect(privateClicked) // it was disabled from simulator's SDK
    }

    //if this is not given, application may crash in some cases
    Component.onDestruction: {
        if (parentCache.oldParent != null) {
            parent = parentCache.oldParent
            fader.parent = root
        }
    }



    Fader {
        id: fader
        dim: root.__dim
        fadeInDuration: root.__fadeInDuration
        fadeOutDuration: root.__fadeOutDuration
        fadeInDelay: root.__fadeInDelay
        fadeOutDelay: root.__fadeOutDelay
        fadeInEasingType: root.__fadeInEasingType
        fadeOutEasingType: root.__fadeOutEasingType
        onPrivateClicked: {root.privateClicked();}


        background: root.__faderBackground

        MouseArea {
            anchors.fill: parent
            enabled: root.status === DialogStatus.Opening || root.status === DialogStatus.Closing
            z: Number.MAX_VALUE
        }
    }

    function __fader() {
        return fader;
    }
}
