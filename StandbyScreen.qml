import QtQuick
import "Theme.js" as T

// Schermata di STANDBY: fondo nero con orologio (come la nav di serie a quadro
// in ACC / sportello aperto). Toccando lo schermo o col pulsante power il
// cockpit si accende. Volutamente essenziale e a bassa luminosità (notte in
// auto): solo ora, data e un discreto marchio GSOI.
Item {
    id: root
    signal wakeRequested()

    property string clock: Qt.formatTime(new Date(), "hh:mm")
    property string dateStr: Qt.formatDate(new Date(), "dddd d MMMM").toUpperCase()
    Timer {
        interval: 1000; running: root.visible; repeat: true; triggeredOnStart: true
        onTriggered: {
            root.clock = Qt.formatTime(new Date(), "hh:mm");
            root.dateStr = Qt.formatDate(new Date(), "dddd d MMMM").toUpperCase();
        }
    }

    Rectangle { anchors.fill: parent; color: "#000000" }

    Column {
        anchors.centerIn: parent
        spacing: 10

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.clock
            font.family: T.num; font.pixelSize: 168; font.weight: Font.Light
            color: "#e8eef6"
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.dateStr
            font.family: T.sans; font.pixelSize: 20; font.letterSpacing: 4
            color: "#5c6b7d"
        }
    }

    // Marchio discreto in basso.
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 46
        text: "GSOI"
        font.family: T.sans; font.pixelSize: 15; font.weight: Font.DemiBold
        font.letterSpacing: 6; color: "#33414f"
    }

    // Suggerimento discreto (pulsazione lenta).
    Text {
        id: hint
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 78
        text: "Tocca lo schermo o premi power"
        font.family: T.sans; font.pixelSize: 13; color: "#2b3844"
        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { from: 0.35; to: 0.9; duration: 1800; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.9; to: 0.35; duration: 1800; easing.type: Easing.InOutSine }
        }
    }

    // Tutto lo schermo è "premi per accendere".
    MouseArea { anchors.fill: parent; onClicked: root.wakeRequested() }
}
