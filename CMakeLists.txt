cmake_minimum_required(VERSION 3.16)
project(CADmarkable VERSION 0.1 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt6 REQUIRED COMPONENTS Quick Quick3D QuickShapesPrivate Test)
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

enable_testing()

qt_add_executable(test_main
    tests/test_main.cpp
    src/CadController.h
    src/CadController.cpp
)
target_include_directories(test_main PRIVATE src)

# Re-use exact same URI CADmarkable_app to prevent qrc path mismatch
qt_add_qml_module(test_main
    URI CADmarkable_app
    OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/test_main_qml
    VERSION 1.0
    QML_FILES
        src/Main.qml
        src/OrthographicView.qml
        src/PerspectiveView.qml
        src/ToolbarButton.qml)

target_link_libraries(test_main PRIVATE
    Qt6::Quick
    Qt6::Quick3D
    Qt6::QuickShapesPrivate
    Qt6::Test
)

add_test(NAME test_main COMMAND test_main)

# Ensure qmltestrunner is found if Qt6::qmltestrunner isn't natively exposed.
# Qt6 Test is standard but qmltestrunner might just be an executable.
find_program(QMLTESTRUNNER_EXECUTABLE NAMES qmltestrunner PATHS /usr/lib/qt6/bin /usr/bin)

add_test(NAME qml_tests
    COMMAND env QT_QPA_PLATFORM=offscreen ${QMLTESTRUNNER_EXECUTABLE} -import ${CMAKE_SOURCE_DIR}/tests/mock -input ${CMAKE_SOURCE_DIR}/tests/tst_Main.qml
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

# Keep the custom target for convenience
add_custom_target(run_qml_tests
    COMMAND env QT_QPA_PLATFORM=offscreen ${QMLTESTRUNNER_EXECUTABLE} -import ${CMAKE_SOURCE_DIR}/tests/mock -input ${CMAKE_SOURCE_DIR}/tests/tst_Main.qml
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)

qt_add_executable(test_main
    tests/test_main.cpp
    src/CadController.h
    src/CadController.cpp
)
target_include_directories(test_main PRIVATE src)

# Re-use exact same URI CADmarkable_app to prevent qrc path mismatch
qt_add_qml_module(test_main
    URI CADmarkable_app
    OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/test_main_qml
    VERSION 1.0
    QML_FILES
        src/Main.qml
        src/OrthographicView.qml
        src/PerspectiveView.qml
        src/ToolbarButton.qml)

target_link_libraries(test_main PRIVATE
    Qt6::Quick
    Qt6::Quick3D
    Qt6::QuickShapesPrivate
    Qt6::Test
)

add_test(NAME test_main COMMAND test_main)
