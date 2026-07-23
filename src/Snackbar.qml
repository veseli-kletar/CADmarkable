import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    width: 300
    height: contentRow.implicitHeight + 20

    property var cadController: null
    property bool isVisible: cadController && (cadController.activeTool === "Extrude" || cadController.activeTool === "Dimension")

    visible: isVisible
    opacity: isVisible ? 1.0 : 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
        border.color: "#888888"
        border.width: 1
        radius: 8

        // Basic drop shadow effect for e-ink (just a slight offset border)
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            anchors.rightMargin: -4
            anchors.bottomMargin: -4
            z: -1
            color: "#33000000"
            radius: 8
        }

        RowLayout {
            id: contentRow
            anchors.fill: parent
            anchors.margins: 10
            spacing: 15

            Text {
                text: cadController ? cadController.activeTool + " Options" : ""
                font.bold: true
                font.pixelSize: 14
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true } // spacer

            // Extrude depth property manager
            RowLayout {
                visible: cadController && cadController.activeTool === "Extrude"
                spacing: 5

                Text { text: "Depth:"; font.pixelSize: 12 }

                Rectangle {
                    width: 60
                    height: 24
                    color: "#EEEEEE"
                    border.color: "#AAAAAA"

                    Text {
                        anchors.centerIn: parent
                        text: cadController ? Math.round(cadController.extrusionDepth).toString() : "0"
                        font.pixelSize: 12
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var w = Window.window;
                            if (w && w.openNumpad) {
                                w.openNumpad("Extrude Depth", cadController.extrusionDepth, function(newVal) {
                                    cadController.extrusionDepth = newVal;
                                });
                            }
                        }
                    }
                }
            }

            // Dimension property manager
            RowLayout {
                visible: cadController && cadController.activeTool === "Dimension"
                spacing: 5

                Text { text: "Value:"; font.pixelSize: 12 }

                Rectangle {
                    width: 60
                    height: 24
                    color: "#EEEEEE"
                    border.color: "#AAAAAA"

                    Text {
                        anchors.centerIn: parent
                        // Dummy value for now
                        text: "50"
                        font.pixelSize: 12
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var w = Window.window;
                            if (w && w.openNumpad) {
                                w.openNumpad("Dimension", 50, function(newVal) {
                                    // Normally we would update selected dimension
                                    console.log("Set dimension to", newVal);
                                });
                            }
                        }
                    }
                }
            }
        }
    }
}
