import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

Item {
    id: root
    implicitHeight: 58

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
        spacing: 20

        Text {
            text: root.clock
            font.family: T.serif
            font.pixelSize: 24
            font.weight: Font.DemiBold
            color: T.text
        }
        Text {
            text: Qt.formatDate(new Date(), "ddd d MMM") + " · Milano"
            font.family: T.serif
            font.pixelSize: 17
            color: T.n700
        }

        Item { Layout.fillWidth: true }

        Text { text: "18°C"; font.pixelSize: 16; color: T.n700 }
        Text { text: "412 km"; font.pixelSize: 16; color: T.accent700 }
        Text { text: "BT · Wi-Fi · 4G"; font.pixelSize: 15; color: T.accent700 }
    }

    // Divisore inferiore.
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: T.divider
    }
}
