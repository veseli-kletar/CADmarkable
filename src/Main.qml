import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick.Controls
import CADmarkable_app

Window {
    width: Screen.width
    height: Screen.height
    visible: true
    title: "CADmarkable"
    color: "#FFFFFF"

    CadController {
        id: cadController
    }

    function updateStatusCoords(x, y) {
        statusCoords.text = "X: " + Math.round(x) + "  Y: " + Math.round(y)
    }

    function openNumpad(title, initialValue, callback) {
        numpad.open(title, initialValue, callback);
    }

    property string activeView: "Perspective"

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
                Layout.preferredWidth: 180
                Layout.fillHeight: true
                color: "#F0F0F0"
                border.color: "#CCCCCC"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        Column {
                            width: parent.width
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

                            Item { height: 10; width: 1 } // spacer

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

                            Item { height: 10; width: 1 } // spacer

                            Text { text: "Feature Tree"; font.bold: true; font.pixelSize: 12 }

                            // Mock Feature Tree
                            Rectangle {
                                width: parent.width
                                height: 24
                                color: "#E0E0E0"
                                border.color: "#CCCCCC"
                                Text { anchors.centerIn: parent; text: "Top Plane"; font.pixelSize: 11 }
                            }
                            Rectangle {
                                width: parent.width
                                height: 24
                                color: "#E0E0E0"
                                border.color: "#CCCCCC"
                                Text { anchors.centerIn: parent; text: "Front Plane"; font.pixelSize: 11 }
                            }
                            Rectangle {
                                width: parent.width
                                height: 24
                                color: "#E0E0E0"
                                border.color: "#CCCCCC"
                                Text { anchors.centerIn: parent; text: "Right Plane"; font.pixelSize: 11 }
                            }

                            Rectangle {
                                width: parent.width
                                height: 24
                                color: cadController.sketchRectWidth > 0 ? "#DDEEFF" : "transparent"
                                border.color: "#CCCCCC"
                                visible: cadController.sketchRectWidth > 0 || cadController.sketchLineStartX !== cadController.sketchLineEndX
                                Text { anchors.centerIn: parent; text: "Sketch 1"; font.pixelSize: 11 }
                            }

                            Rectangle {
                                width: parent.width
                                height: 24
                                color: cadController.extrusionDepth > 0 ? "#DDEEFF" : "transparent"
                                border.color: "#CCCCCC"
                                visible: cadController.extrusionDepth > 0
                                Text { anchors.centerIn: parent; text: "Extrude 1"; font.pixelSize: 11 }
                            }
                        }
                    }
                }
            }

            // Single Active Viewport
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // Overlay ViewCube
                ViewCube {
                    id: viewCube
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 10
                    z: 100 // ensure it floats above views
                    currentView: activeView
                    onViewSelected: function(viewName) {
                        activeView = viewName;
                    }
                }

                PerspectiveView {
                    anchors.fill: parent
                    visible: activeView === "Perspective"
                    cadController: cadController
                    importScene: sharedScene
                }
                OrthographicView {
                    anchors.fill: parent
                    visible: activeView === "Top"
                    viewName: "Top"
                    cadController: cadController
                    importScene: sharedScene
                }
                OrthographicView {
                    anchors.fill: parent
                    visible: activeView === "Front"
                    viewName: "Front"
                    cadController: cadController
                    importScene: sharedScene
                }
                OrthographicView {
                    anchors.fill: parent
                    visible: activeView === "Right"
                    viewName: "Right"
                    cadController: cadController
                    importScene: sharedScene
                }
                OrthographicView {
                    anchors.fill: parent
                    visible: activeView === "Bottom"
                    viewName: "Bottom"
                    cadController: cadController
                    importScene: sharedScene
                }
                OrthographicView {
                    anchors.fill: parent
                    visible: activeView === "Back"
                    viewName: "Back"
                    cadController: cadController
                    importScene: sharedScene
                }
                OrthographicView {
                    anchors.fill: parent
                    visible: activeView === "Left"
                    viewName: "Left"
                    cadController: cadController
                    importScene: sharedScene
                }

                // Floating Snackbar Context Menu
                Snackbar {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    cadController: cadController
                    z: 90
                }

                // Floating Numpad
                Numpad {
                    id: numpad
                    anchors.centerIn: parent
                    z: 200
                }
            }
        }

        // Status Bar
        Rectangle {
            Layout.fillWidth: true
            height: 24
            color: "#F0F0F0"
            border.color: "#CCCCCC"
            border.width: 1

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 20

                Text {
                    text: "Tool: " + cadController.activeTool
                    font.pixelSize: 12
                    color: "#333333"
                }
                Text {
                    id: statusCoords
                    text: "X: 0  Y: 0"
                    font.pixelSize: 12
                    color: "#666666"
                }
                Text {
                    visible: cadController.sketchRectWidth > 0 || cadController.sketchRectHeight > 0
                    text: "Rect: " + Math.round(cadController.sketchRectWidth) + " × " + Math.round(cadController.sketchRectHeight)
                    font.pixelSize: 12
                    color: "#666666"
                }
                Text {
                    visible: cadController.extrusionDepth > 0
                    text: "Depth: " + Math.round(cadController.extrusionDepth)
                    font.pixelSize: 12
                    color: "#666666"
                }
            }
        }
    }
}
