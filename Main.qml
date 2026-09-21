import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import "Theme.js" as T

// GSOI Automotive OS — shell del cockpit (schermo centrale).
// Sidebar + status + barra clima persistenti; al centro le schermate.
// Layout fluido: si adatta al pannello reale (baseline ~1280x720).
Window {
    id: win
    visible: true
    visibility: Window.FullScreen
    width: 1280
    height: 720
    color: T.bg
    title: "GSOI Automotive OS"

    property string screen: "home"
    readonly property var order: ["home", "nav", "media", "phone", "agent", "settings"]

    // Dati live da Jarvis Mini (server HTTP locale).
    VehicleData { id: vehicle }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Sidebar {
                Layout.preferredWidth: 210
                Layout.fillHeight: true
                current: win.screen
                onSelect: (s) => win.screen = s
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                StackLayout {
                    anchors.fill: parent
                    currentIndex: Math.max(0, win.order.indexOf(win.screen))

                    HomeScreen { vehicle: vehicle; onOpenScreen: (s) => win.screen = s }
                    NavScreen {}
                    MediaScreen { vehicle: vehicle }
                    PhoneScreen {}
                    AgentScreen { vehicle: vehicle }
                    SettingsScreen {}
                }

                // Status cluster sempre in alto a destra.
                StatusBar {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 30
                    anchors.topMargin: 22
                    z: 10
                    vehicle: vehicle
                }
            }
        }

        ClimateBar {
            Layout.fillWidth: true
            Layout.preferredHeight: 92
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
    Shortcut { sequence: "R"; onActivated: reverse.keyReverse = !reverse.keyReverse }
    Shortcut { sequence: "Esc"; onActivated: Qt.quit() }
}
