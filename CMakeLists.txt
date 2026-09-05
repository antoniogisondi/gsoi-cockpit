cmake_minimum_required(VERSION 3.21)

project(gsoi-cockpit VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Gui)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(gsoi-cockpit
    src/main.cpp
)

qt_add_qml_module(gsoi-cockpit
    URI GsoiCockpit
    VERSION 1.0
    QML_FILES
        Main.qml
        Tile.qml
        StatusBar.qml
        VehiclePanel.qml
        Readout.qml
)

target_link_libraries(gsoi-cockpit PRIVATE Qt6::Quick Qt6::Gui)

include(GNUInstallDirs)
install(TARGETS gsoi-cockpit
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
