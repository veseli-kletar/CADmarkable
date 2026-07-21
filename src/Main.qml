import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick3D
import QtQuick3D.Helpers
import CADmarkable_app

Window {
    width: 1200
    height: 800
    visible: true
    title: "CADmarkable"
    color: "#FFFFFF"

    CadController {
        id: cadController
    }

    // Shared 3D Scene Node
    Node {
        id: sharedScene

        DirectionalLight {
            eulerRotation.x: -45
            eulerRotation.y: -45
        }

        // Axes faintly rendered
        Model {
            source: "#Cube"
            materials: [ PrincipledMaterial { baseColor: "#FF8888" } ]
            scale: Qt.vector3d(5, 0.05, 0.05)
            position: Qt.vector3d(250, 0, 0)
        }
        Model {
            source: "#Cube"
            materials: [ PrincipledMaterial { baseColor: "#88FF88" } ]
            scale: Qt.vector3d(0.05, 5, 0.05)
            position: Qt.vector3d(0, 250, 0)
        }
        Model {
            source: "#Cube"
            materials: [ PrincipledMaterial { baseColor: "#8888FF" } ]
            scale: Qt.vector3d(0.05, 0.05, 5)
            position: Qt.vector3d(0, 0, 250)
        }

        // Extruded Model
        Model {
            id: extrudedModel
            source: "#Cube"
            materials: [ DefaultMaterial { diffuseColor: "#333333" } ]

            visible: cadController && cadController.extrusionDepth > 0 && cadController.sketchRectWidth > 0 && cadController.sketchRectHeight > 0

            scale: Qt.vector3d(
                cadController ? cadController.sketchRectWidth / 100.0 : 0,
                cadController ? cadController.extrusionDepth / 100.0 : 0,
                cadController ? cadController.sketchRectHeight / 100.0 : 0
            )

            position: Qt.vector3d(
                cadController ? (cadController.sketchRectX - 100 + cadController.sketchRectWidth / 2) : 0,
                cadController ? cadController.extrusionDepth / 2 : 0,
                cadController ? (cadController.sketchRectY - 100 + cadController.sketchRectHeight / 2) : 0
            )
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Top Menu Bar
        Rectangle {
            Layout.fillWidth: true
            height: 30
            color: "#FFFFFF"
            border.color: "#CCCCCC"
            border.width: 1

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 20
                Text { text: "File"; font.pixelSize: 14; color: "#000" }
                Text { text: "Edit"; font.pixelSize: 14; color: "#000" }
                Text { text: "View"; font.pixelSize: 14; color: "#000" }
                Text { text: "Help"; font.pixelSize: 14; color: "#000" }
                Text { text: "Settings"; font.pixelSize: 14; color: "#000" }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Left Sidebar Toolbar
            Rectangle {
                Layout.preferredWidth: 100
                Layout.fillHeight: true
                color: "#F0F0F0"
                border.color: "#CCCCCC"
                border.width: 1

                Column {
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                    Text { text: "Sketch"; font.bold: true; font.pixelSize: 12 }
                    ToolbarButton {
                        text: "Select"
                        isActive: cadController.activeTool === "Select"
                        onClicked: cadController.activeTool = "Select"
                    }
                    ToolbarButton {
                        text: "Rectangle"
                        isActive: cadController.activeTool === "Rectangle"
                        onClicked: cadController.activeTool = "Rectangle"
                    }
                    ToolbarButton {
                        text: "Line"
                        isActive: cadController.activeTool === "Line"
                        onClicked: cadController.activeTool = "Line"
                    }
                    ToolbarButton {
                        text: "Dimension"
                        isActive: cadController.activeTool === "Dimension"
                        onClicked: cadController.activeTool = "Dimension"
                    }
                    ToolbarButton { text: "Circle"; isDisabled: true }
                    ToolbarButton { text: "Arc"; isDisabled: true }

                    Item { height: 20; width: 1 } // spacer

                    Text { text: "Features"; font.bold: true; font.pixelSize: 12 }
                    ToolbarButton {
                        text: "Extrude"
                        isActive: cadController.activeTool === "Extrude"
                        onClicked: {
                            cadController.activeTool = "Extrude"
                            if (cadController.sketchRectWidth > 0 && cadController.sketchRectHeight > 0) {
                                cadController.extrusionDepth = 100 // default mock extrusion
                            }
                        }
                    }
                    ToolbarButton { text: "Revolve"; isDisabled: true }
                    ToolbarButton { text: "Sweep"; isDisabled: true }
                }
            }

            // 4-Panel Grid
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                rows: 2
                columnSpacing: 2
                rowSpacing: 2

                PerspectiveView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    cadController: cadController
                    importScene: sharedScene
                }
                OrthographicView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    viewName: "Top"
                    cadController: cadController
                    importScene: sharedScene
                }
                OrthographicView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    viewName: "Front"
                    cadController: cadController
                    importScene: sharedScene
                }
                OrthographicView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    viewName: "Right"
                    cadController: cadController
                    importScene: sharedScene
                }
            }
        }
    }
}
