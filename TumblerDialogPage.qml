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

import QtQuick
import com.meego.components 1.0
import "components/"
import "components/UIConstants.js" as UiConstants
Page {
    id: container
    anchors.margins: UiConstants.DefaultMargin
    tools: commonTools

    Item {
        anchors {
            margins: 16
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        TumblerButton {
            id: tumblerButton
            anchors.top: parent.top
            anchors.topMargin: 10
            width: 206
            text: "Open Tumbler"
            onClicked: launchDialog()
        }
    }

    function launchDialog() {
        console.log("main::launchDialog");
        tDialog.open();
    }

    function callbackFunction() {
        tumblerButton.text =
            dayList.get(dayColumn.selectedIndex).value + " " +
            monthList.get(monthColumn.selectedIndex).value + " " +
            yearList.get(yearColumn.selectedIndex).value;
    }

    TumblerDialog {
        id: tDialog
        titleText: "Date of birth"
        acceptButtonText: "Ok"
        rejectButtonText: "Cancel"
        columns: [ dayColumn, monthColumn, yearColumn ]
        onAccepted: callbackFunction()
    }

    function initializeDataModels() {
        for (var year = 2000; year <= 2020; year++) {
            yearList.append({"value" : year});
        }

        for (var day = 1; day <= 31; day++) {
            dayList.append({"value" : day});
        }
    }

    Component.onCompleted: {
        initializeDataModels();
    }

    TumblerColumn {
        id: dayColumn
        items: ListModel { id: dayList }
        label: "DAY"
        selectedIndex: 21
    }

    TumblerColumn {
        id: monthColumn
        items: ListModel {
            id: monthList
            ListElement { value: "Jan" }
            ListElement { value: "Feb" }
            ListElement { value: "Mar" }
            ListElement { value: "Apr" }
            ListElement { value: "May" }
            ListElement { value: "Jun" }
            ListElement { value: "Jul" }
            ListElement { value: "Aug" }
            ListElement { value: "Sep" }
            ListElement { value: "Oct" }
            ListElement { value: "Nov" }
            ListElement { value: "Dec" }
        }
        label: "MONTH"
        selectedIndex: 9
    }

    TumblerColumn {
        id: yearColumn
        items: ListModel { id: yearList }
        label: "YEAR"
        selectedIndex: 10
    }
}
