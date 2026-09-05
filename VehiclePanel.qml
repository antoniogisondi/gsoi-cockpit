import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property color accent: "#00E0C6"
    property color surface: "#141A24"
    property color stroke: "#1F2A38"
    property color textMain: "#E6EDF3"
    property color textMuted: "#8A97A6"

    // Valori mock: in futuro alimentati da Jarvis Mini / OBD (sola lettura).
    property int rpm: 850
    property int engineTemp: 89
    property real battery: 12.6

    radius: 22
    color: surface
    border.color: stroke
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 18

        Text {
            text: "VEICOLO"
            color: root.textMuted
            font.pixelSize: 14
            font.bold: true
            font.letterSpacing: 2
        }

        Readout {
            Layout.fillWidth: true
            caption: "Giri motore"
            value: root.rpm
            unit: "rpm"
            textMain: root.textMain
            textMuted: root.textMuted
        }

        Readout {
            Layout.fillWidth: true
            caption: "Temp. motore"
            value: root.engineTemp
            unit: "°C"
            textMain: root.textMain
            textMuted: root.textMuted
        }

        Readout {
            Layout.fillWidth: true
            caption: "Batteria"
            value: root.battery
            unit: "V"
            textMain: root.textMain
            textMuted: root.textMuted
        }

        Item { Layout.fillHeight: true }
    }

    // Simula piccole variazioni finche' non c'e' il dato reale.
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            root.rpm = 800 + Math.floor(Math.random() * 1600)
            root.engineTemp = 86 + Math.floor(Math.random() * 8)
            root.battery = Math.round((12.2 + Math.random() * 2.0) * 10) / 10
        }
    }
}
