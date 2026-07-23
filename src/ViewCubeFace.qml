import QtQuick
import QtQuick.Layouts

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true

    property string text: ""
    property bool isActive: false
    signal clicked()

    Rectangle {
        anchors.fill: parent
        color: isActive ? "#DDDDFF" : (mouseArea.containsMouse ? "#EEEEEE" : "#F8F8F8")
        border.color: "#AAAAAA"
        border.width: 1

        Text {
            anchors.centerIn: parent
            text: root.text
            font.pixelSize: 9
            color: "#333333"
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: root.clicked()
        }
    }
}
