import QtQuick
import "ClusterTheme.js" as C

// Barra verticale (carburante / temperatura) con icona sotto. Il riempimento
// cresce dal basso e si anima. width/height li dà il chiamante.
Item {
    id: root
    property real frac: 0                 // 0..1
    property color fillColor: C.teal
    property string iconKind: ""          // kind di Telltale (es. "lowFuel")
    property color iconColor: C.muted

    Rectangle {
        id: track
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: icon.top
        anchors.bottomMargin: parent.width * 0.5
        radius: width / 2
        color: C.track
        clip: true

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.height * Math.max(0, Math.min(1, root.frac))
            radius: parent.radius
            color: root.fillColor
            Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
            Behavior on color  { ColorAnimation { duration: 250 } }
        }
    }

    Telltale {
        id: icon
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        kind: root.iconKind
        colorOverride: root.iconColor
        size: parent.width * 1.4
    }
}
