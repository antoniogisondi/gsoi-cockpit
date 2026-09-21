cmake_minimum_required(VERSION 3.21)

project(gsoi-cockpit VERSION 0.4 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Gui)

qt_standard_project_setup(REQUIRES 6.5)

# ---------------------------------------------------------------------------
# Cockpit / infotainment (schermo centrale, app_id org.gsoi.cockpit)
# ---------------------------------------------------------------------------
qt_add_executable(gsoi-cockpit
    src/main.cpp
)

qt_add_qml_module(gsoi-cockpit
    URI GsoiCockpit
    VERSION 1.0
    QML_FILES
        Theme.js
        Icons.js
        Main.qml
        Icon.qml
        IconButton.qml
        VehicleData.qml
        ReverseData.qml
        CameraView.qml
        ParkingSensors.qml
        RearViewScreen.qml
        Sidebar.qml
        StatusBar.qml
        ClimateBar.qml
        Tile.qml
        HeroBackground.qml
        NavRail.qml
        Header.qml
        SectionLabel.qml
        PrimaryButton.qml
        HomeScreen.qml
        NavScreen.qml
        MediaScreen.qml
        AgentScreen.qml
        ConnectScreen.qml
        ClimateScreen.qml
        ClusterScreen.qml
        PhoneScreen.qml
        SettingsScreen.qml
    RESOURCES
        Phosphor.ttf
        fonts/Barlow-Regular.ttf
        fonts/Barlow-Medium.ttf
        fonts/Barlow-SemiBold.ttf
        fonts/SairaCondensed-SemiBold.ttf
        images/hero.png
        images/gsoi-logo.png
        images/navigation-map.png
        images/icons/ai.svg
        images/icons/bag.svg
        images/icons/bluetooth.svg
        images/icons/calendar.svg
        images/icons/car.svg
        images/icons/chevron.svg
        images/icons/clock.svg
        images/icons/cloud.svg
        images/icons/defrost.svg
        images/icons/dial.svg
        images/icons/display.svg
        images/icons/fan.svg
        images/icons/home.svg
        images/icons/info.svg
        images/icons/media.svg
        images/icons/message.svg
        images/icons/nav.svg
        images/icons/news.svg
        images/icons/next.svg
        images/icons/pause.svg
        images/icons/person.svg
        images/icons/phone.svg
        images/icons/pin.svg
        images/icons/play.svg
        images/icons/previous.svg
        images/icons/radio.svg
        images/icons/rear.svg
        images/icons/route.svg
        images/icons/search.svg
        images/icons/seat.svg
        images/icons/settings.svg
        images/icons/signal.svg
        images/icons/speaker.svg
        images/icons/sun.svg
        images/icons/wifi.svg
)

target_link_libraries(gsoi-cockpit PRIVATE Qt6::Quick Qt6::Gui)

# ---------------------------------------------------------------------------
# Quadro strumenti digitale (2a uscita HDMI, app_id org.gsoi.cluster)
# Processo separato: strumentazione di guida, indipendente dall'infotainment
# e dall'AI. Legge i dati dal servizio gsoi-vehicled (CAN in sola lettura).
# ---------------------------------------------------------------------------
qt_add_executable(gsoi-cluster
    src/cluster_main.cpp
)

qt_add_qml_module(gsoi-cluster
    URI GsoiCluster
    VERSION 1.0
    QML_FILES
        ClusterTheme.js
        ClusterData.qml
        Wing.qml
        MiniBar.qml
        Telltale.qml
        TelltaleBar.qml
        TurnSignal.qml
        ClusterMain.qml
    RESOURCES
        fonts/SairaCondensed-SemiBold.ttf
        fonts/Barlow-Medium.ttf
)

target_link_libraries(gsoi-cluster PRIVATE Qt6::Quick Qt6::Gui)

include(GNUInstallDirs)
install(TARGETS gsoi-cockpit gsoi-cluster
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
