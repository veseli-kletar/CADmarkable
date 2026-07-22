import QtQuick
import QtTest
import "../src" as Src
import CADmarkable_app

TestCase {
    name: "MainTest"
    when: windowShown

    Src.Main {
        id: mainWin
    }

    // Need to find the inner children since ToolbarButtons are nested deeply in Main.qml
    // Main -> ColumnLayout -> RowLayout -> Rectangle (Sidebar) -> Column -> ToolbarButtons
    function findChildByText(parentItem, text) {
        if (!parentItem || !parentItem.children) return null;
        for (var i = 0; i < parentItem.children.length; ++i) {
            var child = parentItem.children[i];
            // If it's a ToolbarButton (has text property and signal clicked)
            if (child.hasOwnProperty("text") && child.text === text && child.hasOwnProperty("isActive")) {
                return child;
            }
            var found = findChildByText(child, text);
            if (found) return found;
        }
        return null;
    }

    // A better way to find CadController by searching its children (often it is not a direct visual child of contentItem, or we can just access it by its properties via mainWin.children)
    function findCadController(parentItem) {
        if (!parentItem || !parentItem.children) return null;
        for (var i = 0; i < parentItem.children.length; ++i) {
            var child = parentItem.children[i];
            // Check for the unique properties of CadController we mocked
            if (child.hasOwnProperty("activeTool") && child.hasOwnProperty("sketchRectX")) {
                return child;
            }
            var found = findCadController(child);
            if (found) return found;
        }
        return null;
    }

    function test_window_properties() {
        verify(mainWin !== null, "Main window should be created")
        compare(mainWin.title, "reMarkable CAD", "Title should match")
        compare(mainWin.width, Screen.width, "Width should be Screen.width")
        compare(mainWin.height, Screen.height, "Height should be Screen.height")
    }

    function test_toolbar_buttons() {
        // In Main.qml, CadController is instantiated inside Window but it's not a visual item.
        // It might be in mainWin.data or mainWin.children.
        // Since CadController is non-visual, let's search mainWin.data
        var cadController = null;
        for (var i = 0; i < mainWin.data.length; ++i) {
            if (mainWin.data[i].hasOwnProperty("activeTool")) {
                cadController = mainWin.data[i];
                break;
            }
        }

        verify(cadController !== null, "CadController should be found in window data");

        // Find buttons
        var selectButton = findChildByText(mainWin.contentItem, "Select");
        verify(selectButton !== null, "Select button should exist");
        var rectButton = findChildByText(mainWin.contentItem, "Rectangle");
        verify(rectButton !== null, "Rectangle button should exist");
        var lineButton = findChildByText(mainWin.contentItem, "Line");
        verify(lineButton !== null, "Line button should exist");
        var dimButton = findChildByText(mainWin.contentItem, "Dimension");
        verify(dimButton !== null, "Dimension button should exist");
        var extrudeButton = findChildByText(mainWin.contentItem, "Extrude");
        verify(extrudeButton !== null, "Extrude button should exist");

        // Test clicks
        mouseClick(selectButton);
        compare(cadController.activeTool, "Select", "Active tool should be Select");
        verify(selectButton.isActive, "Select button should be active");

        mouseClick(rectButton);
        compare(cadController.activeTool, "Rectangle", "Active tool should be Rectangle");
        verify(rectButton.isActive, "Rectangle button should be active");

        mouseClick(lineButton);
        compare(cadController.activeTool, "Line", "Active tool should be Line");
        verify(lineButton.isActive, "Line button should be active");

        mouseClick(dimButton);
        compare(cadController.activeTool, "Dimension", "Active tool should be Dimension");
        verify(dimButton.isActive, "Dimension button should be active");

        mouseClick(extrudeButton);
        compare(cadController.activeTool, "Extrude", "Active tool should be Extrude");
        verify(extrudeButton.isActive, "Extrude button should be active");

        // Default mock extrusion is set when sketchRectWidth and sketchRectHeight are > 0
        cadController.sketchRectWidth = 10;
        cadController.sketchRectHeight = 10;
        mouseClick(extrudeButton);
        compare(cadController.extrusionDepth, 100, "Extrusion depth should be set to 100 on valid extrude click");
    }
}
