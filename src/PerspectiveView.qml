import QtQuick
import QtQuick3D
import QtQuick3D.Helpers

Item {
    id: root

    property var cadController: null
    property var importScene: null

    Rectangle {
        anchors.fill: parent
        color: "#EAEAEA"
        border.color: "#DDDDDD"
        border.width: 1
    }

    View3D {
        anchors.fill: parent
        importScene: root.importScene

        environment: SceneEnvironment {
            clearColor: "#EAEAEA" // Gentle grays
            backgroundMode: SceneEnvironment.Color
        }

        PerspectiveCamera {
            id: camera
            z: 400
            y: 200
            eulerRotation.x: -20
        }

        Node {
            id: originNode
        }

        OrbitCameraController {
            anchors.fill: parent
            origin: originNode
            camera: camera
        }
    }

    // Touch Gestures for Perspective View
    PinchHandler {
        id: pinchHandler
        target: null

        property real lastScale: 1.0

        onActiveChanged: {
            if (active) {
                // Pinch started
                lastScale = 1.0;
            }
        }

        onActiveScaleChanged: {
            var delta = pinchHandler.activeScale - lastScale;
            var zoomSpeed = 500.0;

            // Zoom in/out by adjusting camera Z
            camera.z -= zoomSpeed * delta;

            // Clamp camera Z
            if (camera.z < 50) camera.z = 50;
            if (camera.z > 2000) camera.z = 2000;

            lastScale = pinchHandler.activeScale;
        }
    }

    // Short Tap to select (Mock logic)
    TapHandler {
        onTapped: {
            if (cadController && cadController.activeTool === "Select") {
                console.log("Component selected in 3D view");
                // In a full implementation we would do raycasting here:
                // var result = view3d.pick(eventPoint.position.x, eventPoint.position.y);
            }
        }
    }
}
