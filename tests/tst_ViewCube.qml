import QtQuick
import QtTest
import "../src" as Src

TestCase {
    name: "ViewCubeTest"
    when: windowShown
    width: 200
    height: 200

    Src.ViewCube {
        id: viewCube
    }

    function findViewCubeFace(parentItem, text) {
        if (!parentItem || !parentItem.children) return null;
        for (var i = 0; i < parentItem.children.length; ++i) {
            var child = parentItem.children[i];
            if (child.hasOwnProperty("text") && child.text === text && child.hasOwnProperty("isActive")) {
                return child;
            }
            var found = findViewCubeFace(child, text);
            if (found) return found;
        }
        return null;
    }

    function test_view_cube_selection() {
        var topFace = findViewCubeFace(viewCube, "Top");
        verify(topFace !== null, "Top face should exist");

        var frontFace = findViewCubeFace(viewCube, "Front");
        verify(frontFace !== null, "Front face should exist");

        // Setup listener
        var emittedView = "";
        viewCube.onViewSelected.connect(function(viewName) {
            emittedView = viewName;
            viewCube.currentView = viewName; // ViewCube itself doesn't update the property, Main.qml does, so we mock it
        });

        // Initial state
        compare(viewCube.currentView, "Perspective", "Initial view should be Perspective");

        // We need to wait for layout, but when windowShown is true, it should be ready.
        // Let's call the clicked signal explicitly first since mouseClick can be flaky if the mouse area isn't explicitly found
        topFace.clicked();
        compare(emittedView, "Top", "Emitted view should be Top");
        compare(viewCube.currentView, "Top", "View should change to Top");
        verify(topFace.isActive, "Top face should be active");

        // Click Front
        frontFace.clicked();
        compare(emittedView, "Front", "Emitted view should be Front");
        compare(viewCube.currentView, "Front", "View should change to Front");
        verify(frontFace.isActive, "Front face should be active");
        verify(!topFace.isActive, "Top face should not be active anymore");
    }
}
