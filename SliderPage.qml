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
    id: root
    tools: commonTools
    anchors.margins: UiConstants.DefaultMargin

    property int textColumnWidth: 100
    property int sliderWidth: 200

    Flickable {
        id: flickable
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick

        contentHeight: col.height
        contentWidth:flickable.width
        Column {
            id: col
            spacing: 30
            /*Row {
                Label { text: sl1.value.toFixed(2) ; color: "green"; width: 40 }
                Label { visible: screen.currentOrientation == Screen.Landscape; width: root.textColumnWidth; wrapMode: Text.Wrap; text: "Default Slider" }
                Slider { id: sl1 ; width:sliderWidth}
            }
            Row {
                Label { text: sl2.value.toFixed(2) ; color: "green"; width: 40 }
                Label { visible: screen.currentOrientation == Screen.Landscape; width: root.textColumnWidth; wrapMode: Text.Wrap; text: "Slider [0-100], indicator visible" }
                Slider { id:sl2; stepSize:1 ; valueIndicatorVisible: true; minimumValue:0 ; maximumValue:100 ; width:sliderWidth}
            }

            Row {
                Label { text: sl3.value.toFixed(2) ; color: "green"; width: 40 }
                Label { visible: screen.currentOrientation == Screen.Landscape; width: root.textColumnWidth; wrapMode: Text.Wrap; text: "Slider from -100 to 100, indicator visible" }
                Slider { id: sl3; minimumValue: -100; maximumValue: 100; valueIndicatorVisible: true ; width:sliderWidth}
            }
            Row {
                Label { text: sl4.value.toFixed(2) ; color: "green"; width: 40 }
                Label { visible: screen.currentOrientation == Screen.Landscape; width: root.textColumnWidth; wrapMode: Text.Wrap; text: "Slider from -100 to 100, inverted, indicator visible" }
                Slider {
                    id: sl4;
                    minimumValue: -100; maximumValue: 100;
                    valueIndicatorVisible: true
                    inverted: true
                    width: sliderWidth
                }
            }
            Row {
                Label { text: sl5.value ; color: "green"; width: 40 }
                Label { visible: screen.currentOrientation == Screen.Landscape; width: root.textColumnWidth; wrapMode: Text.Wrap; text: "Slider from -100 to 100, step size 10, indicator visible" }
                Slider {
                    id: sl5;
                    minimumValue: -100; maximumValue: 100; stepSize: 30
                    valueIndicatorVisible: true
                    width: sliderWidth
                }
            }
            Row {
                Label { text: sl6.value.toFixed(2) ; color: "green"; width: 40 }
                Label { visible: screen.currentOrientation == Screen.Landscape; width: root.textColumnWidth; wrapMode: Text.Wrap; text: "Slider from -100 to 100, indicator visible, value not updated while dragging" }
                Slider {
                    id: sl6;
                    minimumValue: -100; maximumValue: 100
                    valueIndicatorVisible: true
                    valueIndicatorText: sl6.value.toFixed(0)
                    width: sliderWidth
                }
            }*/
            /*Row {
                Label { text: sl7.value.toFixed(2) ; color: "green"; width: 40 }
                Label { visible: screen.currentOrientation == Screen.Landscape; width: root.textColumnWidth; wrapMode: Text.Wrap; text: "Vertical Slider from -100 to 100, indicator visible" }
                Slider {
                    id: sl7;
                    orientationSlider: Qt.Vertical
                    minimumValue: -100; maximumValue: 100
                    valueIndicatorVisible: true
                }
            }*/
            Row {
                Label { text: progressBar.value.toFixed(2) ; color: "green"; width: 40 }
                Label { visible: screen.currentOrientation == Screen.Landscape; width: root.textColumnWidth; wrapMode: Text.Wrap; text: "Progressbar 0 to 100" }
                ProgressBar {
                    id: progressBar
                    width: 100
                    minimumValue: 0
                    maximumValue: 100
                    value: 90
                }
            }
            Row {
                Label { text: progressBar2.value.toFixed(2) ; color: "green"; width: 40 }
                Label { visible: screen.currentOrientation == Screen.Landscape; width: root.textColumnWidth; wrapMode: Text.Wrap; text: "Progressbar, indeterminate" }
                ProgressBar {
                    id: progressBar2
                    width: 100
                    indeterminate: true
                    value: 50
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: flickable
    }
}
