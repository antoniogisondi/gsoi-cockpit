import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Barra laterale di navigazione (GSOI Automotive OS). Wordmark in alto + voci;
// la voce attiva ha il riempimento sfumato ciano, la barretta accento a sinistra
// e il testo chiaro. Stile fedele ai mockup.
Rectangle {
    id: root
    property string current: "home"
    signal select(string screen)

    color: T.bgDeep

    // hairline destra
    Rectangle {
        anchors.right: parent.right; width: 1; height: parent.height
        color: T.hairline
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 22
        anchors.bottomMargin: 18
        anchors.leftMargin: 22
        anchors.rightMargin: 16
        spacing: 0

        // --- Wordmark ---
        RowLayout {
            spacing: 8
            Text {
                text: "GSOI"
                font.family: T.num; font.pixelSize: 30; font.weight: Font.DemiBold
                font.letterSpacing: 1; color: T.text
            }
        }
        Text {
            text: "Automotive OS"
            font.family: T.sans; font.pixelSize: 14; color: T.n700
            Layout.topMargin: 1
        }
        Text {
            text: "DRIVEN BY INTELLIGENCE"
            font.family: T.sans; font.pixelSize: 9; font.letterSpacing: 2.2
            color: T.accent; Layout.topMargin: 4; Layout.bottomMargin: 26
        }

        // --- Voci ---
        Repeater {
            model: [
                ["home",     "Home",       "house"],
                ["nav",      "Navigation", "navigation-arrow"],
                ["media",    "Media",      "music-notes"],
                ["phone",    "Phone",      "phone"],
                ["agent",    "AI",         "sparkle"],
                ["settings", "Settings",   "gear"]
            ]
            delegate: Item {
                id: item
                required property var modelData
                readonly property bool active: root.current === modelData[0]
                Layout.fillWidth: true
                implicitHeight: 54

                // riempimento sfumato (attivo) / hover
                Rectangle {
                    anchors.fill: parent
                    anchors.rightMargin: 2
                    radius: 10
                    visible: item.active || ma.containsMouse
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: item.active ? "#3833b7e8" : "#12ffffff" }
                        GradientStop { position: 1.0; color: "#0033b7e8" }
                    }
                }
                // barretta accento a sinistra (attivo)
                Rectangle {
                    visible: item.active
                    anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                    width: 3; height: 26; radius: 2; color: T.accent
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    spacing: 14
                    Icon {
                        name: item.modelData[2]
                        size: 23
                        color: item.active ? T.accent700 : T.n700
                    }
                    Text {
                        Layout.fillWidth: true
                        text: item.modelData[1]
                        font.family: T.sans; font.pixelSize: 17
                        font.weight: item.active ? Font.DemiBold : Font.Medium
                        color: item.active ? T.text : T.n700
                    }
                }

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.select(item.modelData[0])
                }
            }
        }

        Item { Layout.fillHeight: true }

        Text {
            text: "v1.0.0"
            font.family: T.sans; font.pixelSize: 12; color: T.n500
        }
    }
}
