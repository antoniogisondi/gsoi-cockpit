import QtQuick

// Freccia direzione, grande, lampeggiante quando attiva.
Item {
    id: root
    property bool active: false
    property string dir: "turnLeft"   // "turnLeft" | "turnRight"
    property real size: 56
    width: size
    height: size

    property bool _on: false
    visible: active
    opacity: _on ? 1 : 0.12

    Telltale {
        anchors.centerIn: parent
        kind: root.dir
        size: root.size
    }

    Timer {
        interval: 420
        running: root.active
        repeat: true
        onTriggered: root._on = !root._on
    }
    onActiveChanged: if (active) _on = true; else _on = false
}
