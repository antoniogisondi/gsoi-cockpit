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

    // --- RETROCAMERA + SENSORI DI PARCHEGGIO --------------------------------
    // Funzione di sicurezza INDIPENDENTE dall'AI (niente Jarvis Mini/LLM).
    // Appena si innesta la retromarcia compare a tutto schermo, sopra al
    // cockpit, come la Media Nav di serie. In auto il segnale arriva dal filo
    // luce-retromarcia (GPIO); qui, mock, si commuta col tasto 'R' per il test.
    ReverseData { id: reverse }

    Loader {
        anchors.fill: parent
        z: 1000
        active: reverse.reverse
        visible: active
        sourceComponent: Component {
            Item {
                anchors.fill: parent
                Rectangle { anchors.fill: parent; color: "#000000" }
                RearViewScreen {
                    width: 1280
                    height: 720
                    anchors.centerIn: parent
                    scale: Math.min(parent.width / 1280, parent.height / 720)
                    transformOrigin: Item.Center
                    reverseData: reverse
                }
            }
        }
    }

    // Trigger di TEST (mock, in QEMU): 'R' innesta/toglie la retromarcia.
    // In auto comanda il GPIO (via servizio gsoi-reverse); qui è solo il mock.
    Shortcut { sequence: "R"; onActivated: reverse.keyReverse = !reverse.keyReverse }

    Shortcut { sequence: "Esc"; onActivated: Qt.quit() }
}
