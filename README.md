# CADmarkable

Brief description: A 3D Computer-Aided Design (CAD) application for the reMarkable Paper Pro, built with Qt6 Quick 3D.

## Features (Current State)
- 4-viewport layout (Perspective + Top/Front/Right orthographic views)
- Toolbar with sketch tools (Select, Rectangle, Line, Dimension)
- Feature tools (Extrude) with disabled placeholders (Revolve, Sweep, Circle, Arc)
- Interactive rectangle and line sketching in Top orthographic view
- Basic extrusion from 2D sketch to 3D model
- Keyboard shortcuts for quick tool switching
- Status bar showing current tool and cursor coordinates
- Orbit camera control in perspective view

## Prerequisites

### Arch Linux / CachyOS
```bash
sudo pacman -S cmake qt6-base qt6-declarative qt6-quick3d qt6-shadertools qt6-tools
```

### Ubuntu / Debian (22.04+)
```bash
sudo apt install cmake qt6-base-dev qt6-declarative-dev qt6-quick3d-dev qt6-shader-baker qml6-module-qttest qml6-module-qtquick3d-helpers
```

### Fedora
```bash
sudo dnf install cmake qt6-qtbase-devel qt6-qtdeclarative-devel qt6-qtquick3d-devel qt6-qtshadertools-devel qt6-qttools
```

## Building for Desktop (Development)

### Debug Build
```bash
cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build -j$(nproc)
```

### Release Build
```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j$(nproc)
```

## Running

### Desktop (Linux with display server)
```bash
./build/CADmarkable
```

### Simulated reMarkable Screen Size
Run the app in a fixed window matching the reMarkable Paper Pro display dimensions (1620×2160):
```bash
# Set fixed window size via environment (Qt respects this)
QT_QUICK_CONTROLS_CONF=qtquickcontrols2.conf ./build/CADmarkable
```
Or simply resize the window manually — the UI adapts via layouts.

### Headless / CI (Offscreen rendering)
```bash
QT_QPA_PLATFORM=offscreen ./build/CADmarkable
```

## Running Tests

### All Tests
```bash
cd build && ctest --output-on-failure
```

### C++ Unit Tests Only
```bash
./build/test_main
```

### QML Tests Only
```bash
QT_QPA_PLATFORM=offscreen qmltestrunner -import tests/mock -input tests/tst_Main.qml
```

## Keyboard Shortcuts
| Shortcut | Action |
|----------|--------|
| S | Select tool |
| R | Rectangle tool |
| L | Line tool |
| D | Dimension tool |
| E | Extrude |
| Ctrl+Z | Undo (planned) |
| Ctrl+Y | Redo (planned) |

## Cross-Compiling for reMarkable Paper Pro

### Setting Up the SDK

The reMarkable uses a Yocto-based SDK for cross-compilation. You need to obtain the SDK for the Paper Pro ("ferrari") model.

1. **Download the SDK** from the reMarkable developer portal or build it from the Yocto BSP layer.
2. **Install the SDK** (typically a self-extracting shell script):
   ```bash
   chmod +x remarkable-sdk-*.sh
   ./remarkable-sdk-*.sh  # Installs to ~/codex-sdk/ by default
   ```
3. **Source the environment** before cross-compiling:
   ```bash
   source ~/codex-sdk/rm2/VERSION/environment-setup-aarch64-remarkable-linux
   ```

### Cross-Compilation Build
```bash
# Source the SDK environment first!
source ~/codex-sdk/rm2/VERSION/environment-setup-aarch64-remarkable-linux

# Configure and build
cmake -B build-remarkable
cmake --build build-remarkable -j$(nproc)
```

### Deploying to Device

1. **Connect to the device** via USB. The reMarkable is accessible at `10.11.99.1` over USB networking.
2. **Stop the main UI** on the device:
   ```bash
   ssh root@10.11.99.1 'systemctl stop xochitl'
   ```
3. **Copy the binary**:
   ```bash
   scp build-remarkable/CADmarkable root@10.11.99.1:/home/root/
   ```
4. **Run the application**:
   ```bash
   ssh root@10.11.99.1 'QT_QUICK_BACKEND=epaper ./CADmarkable -platform epaper'
   ```
5. **Restart the main UI** when done:
   ```bash
   ssh root@10.11.99.1 'systemctl start xochitl'
   ```

### Debugging on Device

For remote debugging with GDB:
```bash
# On the device, start gdbserver:
ssh root@10.11.99.1 'gdbserver :2345 ./CADmarkable -platform epaper'

# On the host, connect with the cross-compiled GDB:
aarch64-remarkable-linux-gdb ./build-remarkable/CADmarkable
(gdb) target remote 10.11.99.1:2345
```

For printf-style debugging, use `qDebug()` statements — output appears in the SSH terminal.

## Project Structure

```
CADmarkable/
├── CMakeLists.txt          # Build configuration
├── README.md               # This file
├── AGENTS.md               # AI agent guidelines
├── PLAN.md                 # Development roadmap
├── src/
│   ├── main.cpp            # Application entry point
│   ├── CadController.h     # C++ backend controller (header)
│   ├── CadController.cpp   # C++ backend controller (implementation)
│   ├── Main.qml            # Root window with 4-viewport layout
│   ├── OrthographicView.qml # Orthographic camera view with 2D sketch overlay
│   ├── PerspectiveView.qml # Perspective camera view with orbit control
│   └── ToolbarButton.qml   # Reusable toolbar button component
└── tests/
    ├── test_main.cpp       # C++ unit tests
    ├── tst_Main.qml        # QML UI tests
    └── mock/
        └── CADmarkable_app/
            ├── CadController.qml  # QML mock of CadController
            └── qmldir              # Module definition
```

## Development Workflow

1. **Edit source** — Modify QML/C++ files in `src/`
2. **Build** — `cmake --build build -j$(nproc)`
3. **Test** — `cd build && ctest --output-on-failure`
4. **Run** — `./build/CADmarkable`
5. **Deploy** — Cross-compile and `scp` to device for device testing

## Troubleshooting

### "Could not find Qt6Quick3D"
Install the Qt Quick 3D module:
```bash
# Arch/CachyOS
sudo pacman -S qt6-quick3d
# Ubuntu/Debian
sudo apt install qt6-quick3d-dev
```

### "QML module not found: CADmarkable_app"
Ensure you're running from the build directory or that the QML module output directory is in your import path:
```bash
export QML2_IMPORT_PATH=./build
```

### Black/blank window on launch
Check if your GPU supports OpenGL 3.0+ (required by Qt Quick 3D):
```bash
glxinfo | grep "OpenGL version"
```
For software rendering fallback:
```bash
QSG_RHI_BACKEND=opengl QT_QUICK3D_DISABLE_MULTIVIEW=1 ./build/CADmarkable
```

### Tests fail with "cannot find qmltestrunner"
Install Qt6 tools:
```bash
# Arch/CachyOS
sudo pacman -S qt6-tools
# Ubuntu/Debian
sudo apt install qt6-tools-dev-tools
```

## License

TBD
