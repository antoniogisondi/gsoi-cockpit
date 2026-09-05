import QtQuick

Rectangle {
    id: root

    property string label: ""
    property color accent: "#00E0C6"
    property color surface: "#141A24"
    property color stroke: "#1F2A38"
    property color textMain: "#E6EDF3"

    signal activated()

    radius: 22
    color: tap.pressed ? Qt.darker(surface, 1.25) : surface
    border.color: stroke
    border.width: 1
    scale: tap.pressed ? 0.97 : 1.0
    Behavior on scale {
        NumberAnimation { duration: 90; easing.type: Easing.OutQuad }
    }

    Column {
        anchors.centerIn: parent
        spacing: 16

        // Monogramma (indipendente dai font: nessuna emoji).
        Rectangle {
            width: 64
            height: 64
            radius: 32
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            border.color: root.accent
            border.width: 2

            Text {
                anchors.centerIn: parent
                text: root.label.length > 0 ? root.label.charAt(0) : "?"
                color: root.accent
                font.pixelSize: 28
                font.bold: true
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            color: root.textMain
            font.pixelSize: 20
            font.bold: true
        }
    }

    TapHandler {
        id: tap
        onTapped: root.activated()
    }
}
