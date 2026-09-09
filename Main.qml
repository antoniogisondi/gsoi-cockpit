import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import "Theme.js" as T

Window {
    id: win
    visible: true
    visibility: Window.FullScreen
    width: 1280
    height: 720
    color: T.bg
    title: "GSOI Automotive OS"

    property string screen: "home"
    readonly property var order: ["home", "nav", "media", "agent", "conn",
                                   "climate", "cluster", "phone", "settings"]

    // Dati live da Jarvis Mini (server HTTP locale).
    VehicleData { id: vehicle }

    // --- Responsive: tutto disegnato a 1280x720 e scalato uniformemente. ---
    Item {
        id: canvas
        width: 1280
        height: 720
        anchors.centerIn: parent
        scale: Math.min(win.width / width, win.height / height)
        transformOrigin: Item.Center

        RowLayout {
            anchors.fill: parent
            spacing: 0

            NavRail {
                Layout.preferredWidth: 200
                Layout.fillHeight: true
                current: win.screen
                onSelect: (s) => win.screen = s
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                Header { Layout.fillWidth: true; vehicle: vehicle }

                StackLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: Math.max(0, win.order.indexOf(win.screen))

                    HomeScreen { vehicle: vehicle }
                    NavScreen {}
                    MediaScreen { vehicle: vehicle }
                    AgentScreen { vehicle: vehicle }
                    ConnectScreen { vehicle: vehicle }
                    ClimateScreen {}
                    ClusterScreen { vehicle: vehicle }
                    PhoneScreen {}
                    SettingsScreen {}
                }
            }
        }
    }

    Shortcut { sequence: "Esc"; onActivated: Qt.quit() }
}
