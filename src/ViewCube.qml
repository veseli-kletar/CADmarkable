import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    width: 120
    height: 120

    property string currentView: "Perspective"
    signal viewSelected(string viewName)

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        // Background / Border
        Rectangle {
            anchors.centerIn: parent
            width: 100
            height: 100
            color: "#FFFFFF"
            border.color: "#888888"
            border.width: 1
            radius: 8

            GridLayout {
                anchors.fill: parent
                anchors.margins: 5
                columns: 3
                rows: 3
                columnSpacing: 2
                rowSpacing: 2

                // Top row
                Item { Layout.fillWidth: true; Layout.fillHeight: true }
                ViewCubeFace {
                    text: "Top"
                    onClicked: root.viewSelected("Top")
                    isActive: root.currentView === "Top"
                }
                Item { Layout.fillWidth: true; Layout.fillHeight: true }

                // Middle row
                ViewCubeFace {
                    text: "Left"
                    onClicked: root.viewSelected("Left")
                    isActive: root.currentView === "Left"
                }
                ViewCubeFace {
                    text: "Front"
                    onClicked: root.viewSelected("Front")
                    isActive: root.currentView === "Front"
                }
                ViewCubeFace {
                    text: "Right"
                    onClicked: root.viewSelected("Right")
                    isActive: root.currentView === "Right"
                }

                // Bottom row
                ViewCubeFace {
                    text: "Bottom" // or Home/Persp
                    onClicked: root.viewSelected("Perspective") // Use this for perspective shortcut
                    isActive: root.currentView === "Perspective"
                }
                ViewCubeFace {
                    text: "Back"
                    onClicked: root.viewSelected("Back")
                    isActive: root.currentView === "Back"
                }
                ViewCubeFace {
                    text: "Bot" // Real bottom
                    onClicked: root.viewSelected("Bottom")
                    isActive: root.currentView === "Bottom"
                }
            }
        }
    }
}
