import QtQuick
import QtQuick3D
import QtQuick.Shapes

Item {
    id: root

    property var cadController: null
    property string viewName: "Top"
    property var importScene: null

    Rectangle {
        anchors.fill: parent
        color: "#FAFAFA"
        border.color: "#DDDDDD"
        border.width: 1
    }

    View3D {
        anchors.fill: parent
        importScene: root.importScene

        environment: SceneEnvironment {
            clearColor: "#FAFAFA"
            backgroundMode: SceneEnvironment.Color
        }

        OrthographicCamera {
            id: orthoCamera
            // Configure based on viewName
            z: viewName === "Top" || viewName === "Front" ? 500 : 0
            x: viewName === "Right" ? 500 : 0
            y: viewName === "Top" ? 500 : 0

            eulerRotation.x: viewName === "Top" ? -90 : 0
            eulerRotation.y: viewName === "Right" ? 90 : 0
        }
    }

    Text {
        text: root.viewName
        font.pixelSize: 14
        color: "#333333"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 8
    }

    // Coordinate display
    Text {
        visible: viewName === "Top" && (cadController && (cadController.activeTool === "Rectangle" || cadController.activeTool === "Line"))
        text: Math.round(cursorX) + ", " + Math.round(cursorY)
        font.pixelSize: 11
        color: "#0000FF"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 8
    }

    // Crosshair cursor for sketch mode
    Item {
        id: crosshair
        visible: viewName === "Top" && cadController && (cadController.activeTool === "Rectangle" || cadController.activeTool === "Line")
        x: cursorX - 10
        y: cursorY - 10
        width: 20
        height: 20

        Rectangle {
            x: 9
            y: 0
            width: 2
            height: 20
            color: "#0000FF"
            opacity: 0.5
        }
        Rectangle {
            x: 0
            y: 9
            width: 20
            height: 2
            color: "#0000FF"
            opacity: 0.5
        }
    }

    // Interactive 2D Overlay for sketching
    Item {
        anchors.fill: parent
        visible: viewName === "Top" // Only render the interactive sketches on the Top plane overlay for MVP

        Rectangle {
            id: sketchRect
            visible: cadController && cadController.sketchRectWidth > 0 && cadController.sketchRectHeight > 0
            x: cadController ? cadController.sketchRectX : 0
            y: cadController ? cadController.sketchRectY : 0
            width: cadController ? cadController.sketchRectWidth : 0
            height: cadController ? cadController.sketchRectHeight : 0
            color: "transparent"
            border.color: "#0000FF"
            border.width: 3
        }

        Shape {
            id: sketchLine
            visible: cadController && (cadController.sketchLineStartX !== cadController.sketchLineEndX || cadController.sketchLineStartY !== cadController.sketchLineEndY)
            anchors.fill: parent
            ShapePath {
                strokeWidth: 3
                strokeColor: "#0000FF" // Bold blue ink
                fillColor: "transparent"
                startX: cadController ? cadController.sketchLineStartX : 0
                startY: cadController ? cadController.sketchLineStartY : 0
                PathLine {
                    x: cadController ? cadController.sketchLineEndX : 0
                    y: cadController ? cadController.sketchLineEndY : 0
                }
            }
        }
    }

    property real startX: 0
    property real startY: 0
    property bool isDrawing: false
    property real cursorX: 0
    property real cursorY: 0

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPressed: (mouse) => {
            if (!cadController || viewName !== "Top") return; // Only allow sketching on Top plane for MVP
            if (cadController.activeTool === "Rectangle") {
                startX = mouse.x;
                startY = mouse.y;
                isDrawing = true;
                cadController.sketchRectX = startX;
                cadController.sketchRectY = startY;
                cadController.sketchRectWidth = 0;
                cadController.sketchRectHeight = 0;
            } else if (cadController.activeTool === "Line") {
                startX = mouse.x;
                startY = mouse.y;
                isDrawing = true;
                cadController.sketchLineStartX = startX;
                cadController.sketchLineStartY = startY;
                cadController.sketchLineEndX = startX;
                cadController.sketchLineEndY = startY;
            } else if (cadController.activeTool === "Dimension") {
                if (cadController.sketchRectWidth > 0 && cadController.sketchRectHeight > 0) {
                    cadController.sketchRectWidth += 50;
                    cadController.sketchRectHeight += 50;
                }
            }
        }
        onPositionChanged: (mouse) => {
            cursorX = mouse.x;
            cursorY = mouse.y;
            if (root.Window.window && root.Window.window.updateStatusCoords) {
                root.Window.window.updateStatusCoords(mouse.x, mouse.y);
            }
            if (!cadController || !isDrawing || viewName !== "Top") return;
            if (cadController.activeTool === "Rectangle") {
                var curX = mouse.x;
                var curY = mouse.y;
                cadController.sketchRectX = Math.min(startX, curX);
                cadController.sketchRectY = Math.min(startY, curY);
                cadController.sketchRectWidth = Math.abs(curX - startX);
                cadController.sketchRectHeight = Math.abs(curY - startY);
            } else if (cadController.activeTool === "Line") {
                cadController.sketchLineEndX = mouse.x;
                cadController.sketchLineEndY = mouse.y;
            }
        }
        onReleased: (mouse) => {
            if (isDrawing) {
                isDrawing = false;
            }
        }
    }
}
