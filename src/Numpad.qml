import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    width: 250
    height: 350
    visible: false

    property string title: "Input"
    property real initialValue: 0
    property string currentValue: "0"

    // Callback function passed when opening
    property var acceptCallback: null

    function open(titleText, initialVal, callback) {
        root.title = titleText;
        root.initialValue = initialVal;
        root.currentValue = initialVal.toString();
        root.acceptCallback = callback;
        root.visible = true;
    }

    function close() {
        root.visible = false;
        root.acceptCallback = null;
    }

    function append(charStr) {
        if (currentValue === "0" && charStr !== ".") {
            currentValue = charStr;
        } else if (charStr === "." && currentValue.indexOf(".") !== -1) {
            return; // Prevent multiple dots
        } else {
            currentValue += charStr;
        }
    }

    function backspace() {
        if (currentValue.length > 1) {
            currentValue = currentValue.substring(0, currentValue.length - 1);
        } else {
            currentValue = "0";
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#F8F8F8"
        border.color: "#888888"
        border.width: 1
        radius: 8

        // Drop shadow
        Rectangle {
            anchors.fill: parent
            anchors.margins: -4
            anchors.rightMargin: -8
            anchors.bottomMargin: -8
            z: -1
            color: "#33000000"
            radius: 8
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Header
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: root.title
                    font.bold: true
                    font.pixelSize: 14
                    Layout.fillWidth: true
                }
                Button {
                    text: "X"
                    implicitWidth: 30
                    onClicked: root.close()
                }
            }

            // Display
            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: "#FFFFFF"
                border.color: "#CCCCCC"

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.currentValue
                    font.pixelSize: 18
                }
            }

            // Buttons
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 3
                rowSpacing: 5
                columnSpacing: 5

                Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "7"; onClicked: root.append("7") }
                Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "8"; onClicked: root.append("8") }
                Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "9"; onClicked: root.append("9") }

                Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "4"; onClicked: root.append("4") }
                Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "5"; onClicked: root.append("5") }
                Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "6"; onClicked: root.append("6") }

                Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "1"; onClicked: root.append("1") }
                Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "2"; onClicked: root.append("2") }
                Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "3"; onClicked: root.append("3") }

                Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "."; onClicked: root.append(".") }
                Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "0"; onClicked: root.append("0") }
                Button { Layout.fillWidth: true; Layout.fillHeight: true; text: "⌫"; onClicked: root.backspace() }
            }

            // Action Buttons
            RowLayout {
                Layout.fillWidth: true
                Button {
                    Layout.fillWidth: true
                    text: "Cancel"
                    onClicked: root.close()
                }
                Button {
                    Layout.fillWidth: true
                    text: "Accept"
                    onClicked: {
                        if (root.acceptCallback) {
                            root.acceptCallback(parseFloat(root.currentValue));
                        }
                        root.close();
                    }
                }
            }
        }
    }
}
