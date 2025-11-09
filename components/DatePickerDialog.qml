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

import QtQuick 2.15 // Using QtQuick 2.15 for Qt 6.6 compatibility
import "TumblerIndexHelper.js" as TH
import com.meego.components 1.0
import meego
import "UIConstants.js" as UiConstants

/*
    Class: DatePickerDialog
    Dialog that shows a date picker.
*/

Dialog {
    id: root
    // Back key handling
    focus: GlobalSettings.menuFocus
    // RESTORED: This handler is necessary for the menu to intercept the back button
    // and prevent the event from propagating to the PageStackWindow.
    Keys.onReleased: (event) => {
        if (event.key === Qt.Key_Back && DialogStatus.Open) {
            close()
            event.accepted = true // IMPORTANT: This stops the event from reaching the PageStackWindow
        }
    }
    /*
     * Property: titleText
     * [string] If not null, it will be used as the title text for the dialog.
     * If further customization is needed, use property title instead
     */
    property alias titleText: title.text

    /*
     * Property: year
     * [int] The displayed year.
     */
    property int year: dateTime.currentYear()

    /*
     * Property: month
     * [int] The displayed month.
     */
    property int month: 1

    /*
     * Property: day
     * [int] The displayed day.
     */
    property int day: 1

    /*
     * Property: minimumYear
     * [int] Optional, the minimum year shown on the tumbler. This property should
     * only be set once during construction. If the value is not specified,
     * it is default to current year - 1.
     */
    property int minimumYear: dateTime.currentYear() - 1

    /*
     * Property: maximumYear
     * [int] Optional, the maximum year shown on the tumbler. This property should
     * only be set once during construction. If the value is not specified,
     * it is default to current year + 20.
     */
    property int maximumYear: dateTime.currentYear() + 20

    /*
     * Property: acceptButtonText
     * [string] Optional, the button text for the accept button.
     */
    property alias acceptButtonText: confirmButton.text

    /*
     * Property: rejectButtonText
     * [string] Optional, the button text for the reject button.
     */
    property alias rejectButtonText: rejectButton.text

    // TODO do not dismiss the dialog when empty area is clicked
    style: DialogStyle {
        titleBarHeight: 48
        // Assuming 'screen' is a context property provided by C++ (e.g., MDeclarativeScreen::instance())
        // and Screen.Portrait/PortraitInverted are accessible enums.
        leftMargin: screen.currentOrientation === Screen.Portrait || screen.currentOrientation === Screen.PortraitInverted ? 16 : 215
        rightMargin: screen.currentOrientation === Screen.Portrait || screen.currentOrientation === Screen.PortraitInverted ? 16 : 215
        centered: true
    }
    title: Text {
        id: title
        objectName: "title"
        text: "Pick Date"
        visible: text.length > 0
        color: "white"//theme.selectionColor // Assuming 'theme' is a context property
        font { pixelSize: 32; family: UiConstants.DefaultFontFamilyBold } // Assuming UiConstants is defined
        elide: Text.ElideRight
    }
    content: Item {
        id: dialogContent
        height: 300
        width: parent.width

        Tumbler {
            id: tumbler

            function _handleTumblerChanges(index) {
                if (index === 1 || index === 2) {
                    var curYear = yearColumn.selectedIndex + yearList.get(0).value;
                    var curMonth = monthColumn.selectedIndex + 1;

                    var d = dateTime.daysInMonth(curYear, curMonth); // Assuming 'dateTime' is a context property
                    if (dayColumn.selectedIndex >= d)
                        dayColumn.selectedIndex = d - 1
                    while (dayList.count > d)
                        dayList.remove(dayList.count - 1)
                    while (dayList.count < d)
                        dayList.append({"value" : dayList.count + 1})
                }
            }

            columns:  [dayColumn, monthColumn, yearColumn]
            // FIX: Explicitly declare 'index' parameter in onChanged handler
            onChanged: function(index) {
                _handleTumblerChanges(index);
            }
            height: 300
            privateDelayInit: true // Assuming this property is handled by Tumbler

            TumblerColumn {
                id: dayColumn
                items: ListModel {
                    id: dayList
                }
                label: "DAY"
                selectedIndex: root.day - (root.day > 0 ?  1 : 0)
            }

            TumblerColumn {
                id: monthColumn
                items: ListModel {
                    id: monthList
                }
                label: "MONTH"
                selectedIndex: root.month - (root.month > 0 ?  1 : 0)
            }

            TumblerColumn {
                id: yearColumn
                items: ListModel {
                    id: yearList
                }
                label: "YEAR"
                selectedIndex: yearList.length > 0 ? internal.year - yearList.get(0).value : 0
            }
        }
    }
    buttons: Row {
        height: 56
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 6
        Button {
            id: confirmButton
            text: "accept" //textTranslator.translate("qtn_comm_command_accept"); // Assuming textTranslator is defined
            onClicked: accept()
            width: (root.width / 2) - 3
            style: ButtonStyle { inverted: true } // Assuming ButtonStyle is defined
        }
        Button {
            id: rejectButton
            text: "cancel" //textTranslator.translate("qtn_comm_cancel");
            onClicked: reject()
            width: (root.width / 2) - 3
            platformStyle: ButtonStyle { inverted: true } // Assuming ButtonStyle is defined
        }
    }
    onMinimumYearChanged: {
        if (!internal.surpassUpdate) {
            internal.year = root.year
            internal.minYear = root.minimumYear

            if (internal.minYear < 0)
                internal.minYear = dateTime.currentYear() - 1;
            else if (internal.minYear > root.maximumYear)
                internal.minYear = root.maximumYear;

            internal.updateYearList()
            internal.validateDate()
            internal.year = internal.year < internal.minYear ? internal.minYear :
                                (internal.year > root.maximumYear ? root.maximumYear :internal.year)
        }
    }
    onMaximumYearChanged: {
        internal.minYear = root.minimumYear

        if (root.maximumYear < 0)
            root.maximumYear = dateTime.currentYear() + 20;
        else if (root.maximumYear < internal.minYear)
            root.maximumYear = internal.minYear;

        internal.updateYearList()
        internal.validateDate()
        internal.year = internal.year > root.maximumYear ? root.maximumYear :
                                (internal.year < internal.minYear ? internal.minYear : internal.year)
        if (internal.minYear < 0)
            root.minimumYear = dateTime.currentYear() - 1
    }
    onStatusChanged: {
        // When the dialog is opening
        if (status === DialogStatus.Opening) {
            // Save current tumbler index
            TH.saveIndex(tumbler); // TH = TumblerIndexHelper

            // Initialize data models if not already done
            if (!internal.initialized)
                internal.initializeDataModels();

            // Set year selection if valid
            if (internal.year > 0)
                yearColumn.selectedIndex = internal.year - yearList.get(0).value;

            // Trigger tumbler and day selection logic
            tumbler._handleTumblerChanges(2);
            dayColumn.selectedIndex = root.day - 1;
        }

        // When the dialog is closing
        if (status === DialogStatus.Closing) {
            internal.surpassUpdate = true;

            if (internal.surpassUpdate) {
                root.year = internal.year;
                root.minimumYear = internal.minYear;
            }

            internal.surpassUpdate = false;
        }

        // Update global focus flag based on dialog visibility
        GlobalSettings.menuFocus = (
            root.status === DialogStatus.Open ||
            root.status === DialogStatus.Opening
        );
    }
    onDayChanged: {
        internal.validateDate()
        if (dayColumn.items.length > root.day - 1)
            dayColumn.selectedIndex = root.day - 1
    }
    onMonthChanged: {
        internal.validateDate()
        monthColumn.selectedIndex = root.month - 1
    }
    onYearChanged: {
        if (!internal.surpassUpdate) {
            internal.year = root.year
            internal.validateDate()
            internal.year = internal.year < internal.minYear ? internal.minYear :
                                    (internal.year > root.maximumYear ? root.maximumYear : internal.year)

            if (internal.initialized)
                yearColumn.selectedIndex = internal.year - yearList.get(0).value
        }
    }
    onAccepted: {
        tumbler.privateForceUpdate(); // Assuming this function exists on Tumbler
        root.year = yearColumn.selectedIndex + yearList.get(0).value;
        root.month = monthColumn.selectedIndex + 1;
        root.day = dayColumn.selectedIndex + 1;
    }
    onRejected: {
        TH.restoreIndex(tumbler); // Assuming TH is TumblerIndexHelper
    }

    QtObject {
        id: internal

        property variant initialized: false
        property int year
        property int minYear
        property bool surpassUpdate: false

        function initializeDataModels() {
            var currentYear = new Date().getFullYear();
            minimumYear = minimumYear ? minimumYear : currentYear - 1;
            maximumYear = maximumYear ? maximumYear : currentYear + 20;

            for (var y = minimumYear; y <= maximumYear; ++y)
                yearList.append({"value" : y}) // year

            var nDays = dateTime.daysInMonth(internal.year, root.month);
            for (var d = 1; d <= nDays; ++d)
                dayList.append({"value" : d})  // day
            for (var m = 1; m <= 12; ++m)
                // FIX: Changed dateTime.monthName(m, QLocale.ShortFormat) to dateTime.shortMonthName(m)
                // as MDateTimeHelper's shortMonthName already handles the short format internally.
                monthList.append({"value" : dateTime.shortMonthName(m)});

            tumbler.privateInitialize(); // Assuming this function exists on Tumbler
            internal.initialized = true;
        }

        function updateYearList() {
            if (internal.initialized) {
                var tmp = yearColumn.selectedIndex;
                yearList.clear();
                for (var i = internal.minYear; i <= root.maximumYear; ++i)
                    yearList.append({"value" : i})
                if (tmp < yearList.count) {
                    yearColumn.selectedIndex = 0;
                    yearColumn.selectedIndex = tmp;
                }
            }
        }

        function validateDate() {
            if (internal.year < 1){
                internal.year = new Date().getFullYear()
                if (maximumYear < internal.year)
                    root.maximumYear = dateTime.currentYear() + 20;
                if (minimumYear > internal.year)
                    internal.minYear = dateTime.currentYear() - 1;
            }

            root.month = Math.max(1, Math.min(12, root.month))
            var d = dateTime.daysInMonth(internal.year, root.month);
            root.day = Math.max(1, Math.min(d, root.day))
        }
    }
}
