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

    Row {
        Item {
            width: 420
            height: 360

            Tumbler {
                id: tumblerWidget
                anchors { top: parent.top; topMargin: 16; horizontalCenter: parent.horizontalCenter }
                columns: [ dayColumn, monthColumn, yearColumn ]
            }
        }

        Flickable {
            width: col.width
            height: parent.height
            contentWidth: col.width
            contentHeight: col.height

            Column {
                id: col

                ButtonRow {
                    exclusive: false
                    Button {
                        text: "Show 4 columns"
                        onClicked: {
                            tumblerWidget.columns = [ dayColumn, monthColumn, yearColumn, extraColumn ]
                        }
                    }
                    Button {
                        text: "Show 2 columns"
                        onClicked: {
                            tumblerWidget.columns = [ monthColumn, yearColumn ]
                        }
                    }
                }
                Button {
                    text: "Fix width"
                    onClicked: {
                        dayColumn.width = 80
                    }
                }
                Button {
                    text: "Set today"
                    onClicked: {
                        var d = new Date();
                        dayColumn.selectedIndex = d.getDate() - 1;
                        monthColumn.selectedIndex = d.getMonth();
                        yearColumn.selectedIndex = d.getFullYear() - 2000;
                    }
                }

                CheckBox {
                    text: "Day column visible?"
                    checked: true
                    onCheckedChanged: dayColumn.visible = checked
                }
                CheckBox {
                    text: "Month column visible?"
                    checked: true
                    onCheckedChanged: monthColumn.visible = checked
                }
                CheckBox {
                    text: "Year column visible?"
                    checked: true
                    onCheckedChanged: yearColumn.visible = checked
                }

                CheckBox {
                    text: "Day column enabled?"
                    checked: true
                    onCheckedChanged: dayColumn.enabled = checked
                }
                CheckBox {
                    text: "Month column enabled?"
                    checked: true
                    onCheckedChanged: monthColumn.enabled = checked
                }
                CheckBox {
                    text: "Year column enabled?"
                    checked: true
                    onCheckedChanged: yearColumn.enabled = checked
                }
            }
        }
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

    TumblerColumn {
        id: extraColumn
        items: ListModel {
            ListElement { value: "Mon" }
            ListElement { value: "Tue" }
            ListElement { value: "Wed" }
            ListElement { value: "Thurs" }
            ListElement { value: "Fri" }
            ListElement { value: "Sat" }
            ListElement { value: "Sun" }
        }
        label: "DATE"
    }
}
