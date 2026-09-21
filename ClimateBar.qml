import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Barra clima persistente (in basso): temperatura sx/dx con −/+ e slider
// blu→rosso, e i comandi HVAC al centro con icone SVG (stato = sfondo acceso).
Rectangle {
    id: root
    property real leftTemp: 22.0
    property real rightTemp: 22.0

    color: T.bgDeep
    Rectangle { anchors.top: parent.top; width: parent.width; height: 1; color: T.hairline }

    // Pulsante HVAC: icona SVG + evidenziazione quando attivo.
    component HvacBtn: Rectangle {
        id: hv
        property string icon: ""
        property bool on: false
        implicitWidth: 54; implicitHeight: 46; radius: 11
        color: on ? "#163c54" : (ma.containsMouse ? "#132433" : "transparent")
        Icon { anchors.centerIn: parent; name: hv.icon; size: 27 }
        MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true
            cursorShape: Qt.PointingHandCursor; onClicked: hv.on = !hv.on }
    }

    // Controllo temperatura (−  valore+slider  +)
    component TempCtl: RowLayout {
        id: tc
        property real value: 22.0
        spacing: 16
        Rectangle {
            implicitWidth: 40; implicitHeight: 40; radius: 20
            color: mm.pressed ? T.glassHi : "transparent"
            border.width: 1; border.color: T.glassBorder
            Text { anchors.centerIn: parent; text: "−"; font.family: T.sans
                   font.pixelSize: 22; color: T.text }
            MouseArea { id: mm; anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                onClicked: tc.value = Math.max(16, tc.value - 0.5) }
        }
        ColumnLayout {
            spacing: 6
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: tc.value.toFixed(1) + "°"
                font.family: T.num; font.pixelSize: 30; font.weight: Font.DemiBold; color: T.text
            }
            Rectangle {
                Layout.preferredWidth: 150; Layout.preferredHeight: 4; radius: 2
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#2f7dff" }
                    GradientStop { position: 0.5; color: "#8a93a0" }
                    GradientStop { position: 1.0; color: "#ff4d3d" }
                }
                Rectangle {
                    width: 10; height: 10; radius: 5; color: "#ffffff"; y: -3
                    x: parent.width * Math.max(0, Math.min(1, (tc.value - 16) / (30 - 16))) - width / 2
                }
            }
        }
        Rectangle {
            implicitWidth: 40; implicitHeight: 40; radius: 20
            color: mp.pressed ? T.glassHi : "transparent"
            border.width: 1; border.color: T.glassBorder
            Text { anchors.centerIn: parent; text: "+"; font.family: T.sans
                   font.pixelSize: 22; color: T.text }
            MouseArea { id: mp; anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                onClicked: tc.value = Math.min(30, tc.value + 0.5) }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 40
        anchors.rightMargin: 40
        spacing: 24

        TempCtl { value: root.leftTemp }
        Item { Layout.fillWidth: true }

        RowLayout {
            spacing: 20
            Layout.alignment: Qt.AlignVCenter
            HvacBtn { icon: "seat" }
            HvacBtn { icon: "fan"; on: true }
            Text { text: "AUTO"; font.family: T.sans; font.pixelSize: 16; font.weight: Font.DemiBold
                   font.letterSpacing: 1.5; color: T.accent; Layout.alignment: Qt.AlignVCenter }
            HvacBtn { icon: "defrost" }
            HvacBtn { icon: "rear" }
            HvacBtn { icon: "car" }
            HvacBtn { icon: "seat" }
        }

        Item { Layout.fillWidth: true }
        TempCtl { value: root.rightTemp }
    }
}
