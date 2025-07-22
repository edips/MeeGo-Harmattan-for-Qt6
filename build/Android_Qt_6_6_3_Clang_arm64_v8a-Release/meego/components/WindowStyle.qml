import QtQuick
import "."

Style {
    property color colorBackground: "#E0E1E2"

    // pseudo buttons size
    property int buttonWidth: parseInt(30 * ScaleFactor)//theme.constants.QtcCore.WINDOW_BUTTON_WIDTH
    property int buttonHeight: parseInt(50 * ScaleFactor)//theme.constants.QtcCore.WINDOW_BUTTON_HEIGHT

    // pseudo buttons position
    property double buttonVerticalMargin: 0
    property double buttonHorizontalMargin: 0

    // ppseudo buttons index
    property int buttonZIndex: 0//theme.constants.QtcCore.STATUS_BAR_Z_INDEX
}
