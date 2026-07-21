cmake_minimum_required(VERSION 3.16)
project(remarkable_cad VERSION 0.1 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 REQUIRED COMPONENTS Quick)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(remarkable_cad src/main.cpp)
qt_add_qml_module(remarkable_cad
    URI remarkable_cad_app
    VERSION 1.0
    QML_FILES src/Main.qml)

target_link_libraries(remarkable_cad PRIVATE Qt6::Quick)
