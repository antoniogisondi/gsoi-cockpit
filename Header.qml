import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

Item {
    id: root
    implicitHeight: 58

    property var vehicle: null

    property string clock: Qt.formatTime(new Date(), "hh:mm")
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.clock = Qt.formatTime(new Date(), "hh:mm")
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 30
        anchors.rightMargin: 30
        spacing: 18

        Text {
            text: root.clock
            font.family: T.serif; font.pixelSize: 24; font.weight: Font.DemiBold; color: T.text
        }
        Text {
            text: Qt.formatDate(new Date(), "ddd d MMM") + " · Milano"
            font.family: T.serif; font.pixelSize: 17; color: T.n700
        }

        Item { Layout.fillWidth: true }

        // Temperatura esterna
        Icon { name: "thermometer-simple"; size: 20; color: T.n700 }
        Text { text: "18°C"; font.family: T.serif; font.pixelSize: 16; color: T.n700 }

        // Autonomia (dato live)
        Icon { name: "lightning"; size: 20; color: T.accent700 }
        Text {
            text: (root.vehicle ? root.vehicle.rangeKm : 412) + " km"
            font.family: T.serif; font.pixelSize: 16; color: T.accent700
        }

        // Connettivita'
        Icon { name: "bluetooth-connected"; size: 20; color: T.accent700 }
        Icon { name: "wifi-high"; size: 20; color: T.accent700 }

        // Stato Jarvis Mini
        Rectangle {
            width: 10; height: 10; radius: 5
            Layout.leftMargin: 4
            color: (root.vehicle && root.vehicle.mode === "connected") ? "#30a46c" : T.accent2
        }
        Text {
            text: (root.vehicle && root.vehicle.mode === "connected") ? "GSOI" : "Offline"
            font.family: T.serif; font.pixelSize: 15; color: T.n700
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: T.divider
    }
}
