# Development Plan: 3D CAD Application for reMarkable Paper Pro

## Overview
This document outlines the stages for developing a 3D CAD application tailored for the reMarkable Paper Pro ("ferrari"). The application is built using Qt6 and Qt Quick UI to leverage the e-ink display and touch/stylus inputs.

## Stages of Development

### Stage 1: Initial Setup and Prototyping
- [x] Set up project directory structure.
- [x] Create initial `CMakeLists.txt` for cross-compilation and local testing.
- [x] Write basic `main.cpp` and `Main.qml` to display a "Hello World" Qt Quick app.
- [ ] Configure local x86-64 Linux environment for building and running Qt Quick apps.
- [ ] Verify successful deployment and execution on the reMarkable Paper Pro using the SDK.

### Stage 2: Basic UI and Interactions
- [ ] Design the main workspace UI suitable for an e-ink display (high contrast, clear icons, minimal animations).
- [ ] Implement touch and stylus event handling using Qt Quick `MouseArea` and specific stylus events.
- [ ] Create basic UI components: toolbars, menus, and drawing canvas area.
- [ ] Test UI responsiveness and rendering performance on the device.

### Stage 3: 3D Engine Integration
- [ ] Integrate a lightweight 3D rendering engine compatible with Qt Quick (e.g., Qt Quick 3D or a custom OpenGL ES 2.0/3.0 backend, depending on SDK support).
- [ ] Implement basic 3D scene setup (camera, lighting, basic geometry).
- [ ] Render a simple 3D object (e.g., a cube) and allow basic camera manipulation (pan, zoom, rotate).
- [ ] Optimize 3D rendering for e-ink (e.g., wireframe mode, flat shading, limiting refresh rates during manipulation).

### Stage 4: Modeling Tools and Core Functionality
- [ ] Implement 2D sketching tools (lines, circles, rectangles) on a 3D plane.
- [ ] Implement basic 3D operations (extrude, revolve) based on 2D sketches.
- [ ] Develop a scene graph or data structure to manage 3D objects and their relationships.
- [ ] Implement selection, moving, and scaling of 3D objects.

### Stage 5: E-ink Optimization and Refinement
- [ ] Implement partial screen updates to minimize full-screen flashing during 3D manipulation or drawing.
- [ ] Fine-tune UI elements and interactions to minimize latency.
- [ ] Optimize memory usage and power consumption for the tablet environment.
- [ ] Implement undo/redo functionality.

### Stage 6: Advanced Features and Polish
- [ ] Implement saving and loading of CAD models (e.g., standard formats like STL or a custom format).
- [ ] Add more complex modeling tools (fillet, chamfer, boolean operations) if feasible within performance constraints.
- [ ] Comprehensive testing on the reMarkable Paper Pro device.
- [ ] Finalize documentation and user guide.
