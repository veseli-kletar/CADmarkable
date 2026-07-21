cmake_minimum_required(VERSION 3.16)
project(CADmarkable VERSION 0.1 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 REQUIRED COMPONENTS Quick Quick3D QuickShapesPrivate)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(CADmarkable
    src/main.cpp
    src/CadController.h
    src/CadController.cpp
)

target_include_directories(CADmarkable PRIVATE src)

qt_add_qml_module(CADmarkable
    URI CADmarkable_app
    VERSION 1.0
    QML_FILES
        src/Main.qml
        src/OrthographicView.qml
        src/PerspectiveView.qml
        src/ToolbarButton.qml)

target_link_libraries(CADmarkable PRIVATE
    Qt6::Quick
    Qt6::Quick3D
    Qt6::QuickShapesPrivate
)
