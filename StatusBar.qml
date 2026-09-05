import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    property color accent: "#00E0C6"
    property color textMain: "#E6EDF3"
    property color textMuted: "#8A97A6"

    // Stato di connessione (in futuro alimentato da Jarvis Mini).
    property bool connected: false

    spacing: 14

    Text {
        text: "GSOI"
        color: root.accent
        font.pixelSize: 30
        font.bold: true
        font.letterSpacing: 3
        Layout.alignment: Qt.AlignVCenter
    }

    Text {
        text: "Automotive OS"
        color: root.textMuted
        font.pixelSize: 18
        Layout.alignment: Qt.AlignVCenter
    }

    Item { Layout.fillWidth: true }

    Row {
        spacing: 8
        Layout.alignment: Qt.AlignVCenter

        Rectangle {
            width: 12
            height: 12
            radius: 6
            anchors.verticalCenter: parent.verticalCenter
            color: root.connected ? "#30D158" : "#E5484D"
        }

        Text {
            text: root.connected ? "Connesso a GSOI" : "Offline"
            color: root.textMuted
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Text {
        id: clock
        color: root.textMain
        font.pixelSize: 26
        font.bold: true
        Layout.leftMargin: 8
        Layout.alignment: Qt.AlignVCenter
        text: Qt.formatTime(new Date(), "hh:mm")

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.text = Qt.formatTime(new Date(), "hh:mm")
        }
    }
}
