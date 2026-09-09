import QtQuick
import "Theme.js" as T

// Pulsante circolare/quadrato con sola icona Phosphor.
Rectangle {
    id: b
    property string icon: ""
    property real size: 56
    property bool primary: false
    property bool round: false
    property color accent: T.accent
    signal clicked()

    implicitWidth: size
    implicitHeight: size
    radius: round ? size / 2 : 2
    color: b.primary
           ? (ma.pressed ? T.accent700 : b.accent)
           : (ma.pressed ? T.n300 : T.surface)
    border.width: b.primary ? 0 : 1
    border.color: T.divider

    Icon {
        anchors.centerIn: parent
        name: b.icon
        size: b.size * 0.42
        color: b.primary ? "#ffffff" : T.text
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: b.clicked()
    }
}
