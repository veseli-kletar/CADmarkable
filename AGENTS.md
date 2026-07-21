# AI Agent Guidelines for 3D CAD Application

## Purpose of Application
This application is a 3D Computer-Aided Design (CAD) tool, conceptually similar to OnShape, designed specifically for the reMarkable Paper Pro (product code: "ferrari"). It leverages the e-ink display and precise stylus input to provide a unique distraction-free modeling experience.

## Target Platform
- **Device:** reMarkable Paper Pro ("ferrari")
- **OS:** reMarkable OS (Linux-based)
- **Framework:** Qt6 Quick UI (pure QML for UI, no Qt Widgets)
- **Architecture:** ARM64 (aarch64) - Target, x86-64 - Host/Development

## Coding Standards
1. **C++ (Backend Logic):**
   - Use Modern C++ (C++17/C++20).
   - Follow standard Qt naming conventions and patterns (e.g., camelCase for variables/methods, PascalCase for classes).
   - Keep the C++ backend lightweight, focusing on data models, 3D logic, and bridging system APIs.
   - Ensure proper memory management and avoid memory leaks, as resources are constrained.
2. **QML (User Interface):**
   - Design for an e-ink display: favor high contrast, standard CAD E-ink colors/grayscale (or the specific color capabilities of the Paper Pro), and avoid continuous animations to prevent ghosting and reduce latency.
   - Group related UI components into reusable QML files.
   - Handle touch and stylus input gracefully.
3. **CMake (Build System):**
   - Use standard CMake features compatible with the reMarkable Yocto SDK.
   - Use `qt_standard_project_setup` and `qt_add_qml_module` for defining Qt6 targets.

## Libraries and Frameworks
- **Qt6 Core & Qt6 Quick:** Fundamental building blocks for the application.
- **Qt6 Quick 3D (or equivalent lightweight 3D renderer):** To be evaluated for e-ink compatibility and performance for rendering CAD models.

## reMarkable SDK Instructions
- **SDK Setup:** The reMarkable SDK (Yocto-based) must be sourced before cross-compiling. The environment setup script defines necessary cross-compiler variables (`$CC`, etc.) and paths to the sysroot containing Qt6.
- **Building:**
  ```bash
  source ~/codex-sdk/rm2/VERSION/environment-setup-aarch64-remarkable-linux # Example path, adjust for ferrari SDK
  cmake -B build
  cmake --build build
  ```
- **Running on Device:**
  1. Stop the main UI: `systemctl stop xochitl`
  2. Copy the binary via `scp`.
  3. Execute via `ssh` with necessary Qt environment variables:
     ```bash
     QT_QUICK_BACKEND=epaper ./hello_remarkable -platform epaper
     ```
  4. Restart main UI when done: `systemctl start xochitl`

## Important Considerations
- **Performance:** 3D rendering on e-ink requires optimization. Focus on wireframe or flat-shaded rendering during active interaction, updating to higher quality only when the view is static.
- **Input:** Differentiate between finger touch (panning, zooming) and stylus input (drawing, precise selection) if possible through Qt input events.
