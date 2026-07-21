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

        OrbitCameraController {
            anchors.fill: parent
            origin: Qt.vector3d(0, 0, 0)
            camera: camera
        }
    }
}
