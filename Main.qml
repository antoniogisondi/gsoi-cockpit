import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Window {
    id: win
    visible: true
    visibility: Window.FullScreen
    width: 1280
    height: 720
    title: "GSOI Automotive OS"
    color: "#0A0E14"

    // Palette del cockpit (tema scuro automotive).
    readonly property color accent: "#00E0C6"
    readonly property color surface: "#141A24"
    readonly property color stroke: "#1F2A38"
    readonly property color textMain: "#E6EDF3"
    readonly property color textMuted: "#8A97A6"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 22

        StatusBar {
            Layout.fillWidth: true
            accent: win.accent
            textMain: win.textMain
            textMuted: win.textMuted
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 22

            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 4
                rowSpacing: 18
                columnSpacing: 18

                Repeater {
                    model: [
                        { label: "Jarvis" },
                        { label: "Auto" },
                        { label: "Mappa" },
                        { label: "Musica" },
                        { label: "Telefono" },
                        { label: "Casa" },
                        { label: "Bluetooth" },
                        { label: "Impostazioni" }
                    ]
                    delegate: Tile {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        label: modelData.label
                        accent: win.accent
                        surface: win.surface
                        stroke: win.stroke
                        textMain: win.textMain
                        onActivated: console.log("Tile attivato:", label)
                    }
                }
            }

            VehiclePanel {
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                accent: win.accent
                surface: win.surface
                stroke: win.stroke
                textMain: win.textMain
                textMuted: win.textMuted
            }
        }
    }
}
