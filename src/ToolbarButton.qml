import QtQuick

Rectangle {
    id: root
    width: 80
    height: 40
    property string text: ""
    property bool isActive: false
    property bool isDisabled: false
    signal clicked()

    color: isActive ? "#FFF9C4" : (isDisabled ? "#E0E0E0" : "#FAFAFA") // pale yellow when active
    border.color: "#AAAAAA"
    border.width: 1

    Text {
        anchors.centerIn: parent
        text: root.text
        color: isDisabled ? "#888888" : "#000000"
        font.pixelSize: 14
    }

    MouseArea {
        anchors.fill: parent
        enabled: !isDisabled
        onClicked: root.clicked()
    }
}
