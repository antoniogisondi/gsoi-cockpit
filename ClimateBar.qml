import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Barra clima persistente (in basso, tutta larghezza): temperatura sx/dx con
// −/+ e slider blu→rosso, e i comandi HVAC al centro. Stile mockup.
Rectangle {
    id: root
    property real leftTemp: 22.0
    property real rightTemp: 22.0

    color: T.bgDeep
    Rectangle { anchors.top: parent.top; width: parent.width; height: 1; color: T.hairline }

    // Icona HVAC disegnata a vettori (0..24), accendibile.
    component Hvac: Item {
        id: hv
        property string kind: ""
        property bool on: false
        width: 42; height: 42
        Canvas {
            anchors.fill: parent
            onPaint: {
                var c = getContext("2d"); c.reset();
                var u = width / 24; c.scale(u, u);
                c.strokeStyle = hv.on ? T.accent : T.n700;
                c.fillStyle = hv.on ? T.accent : T.n700;
                c.lineWidth = 1.5; c.lineCap = "round"; c.lineJoin = "round";
                switch (hv.kind) {
                case "fan":
                    c.beginPath(); c.arc(12, 12, 1.6, 0, Math.PI * 2); c.fill();
                    for (var i = 0; i < 3; i++) {
                        c.save(); c.translate(12, 12); c.rotate(i * 2 * Math.PI / 3);
                        c.beginPath(); c.moveTo(0, -1.5);
                        c.bezierCurveTo(6, -5, 8, -1, 2, 0.5);
                        c.stroke(); c.restore();
                    }
                    break;
                case "seat":
                    c.beginPath(); c.moveTo(7, 4); c.lineTo(7, 13); c.lineTo(15, 13); c.stroke();
                    c.beginPath(); c.moveTo(7, 13); c.lineTo(9, 18); c.lineTo(16, 18); c.stroke();
                    for (var s = 0; s < 3; s++) {
                        var x = 17 + s * 1.8;
                        c.beginPath(); c.moveTo(x, 4);
                        c.bezierCurveTo(x + 1.4, 5.5, x - 1.4, 7, x, 8.5); c.stroke();
                    }
                    break;
                case "defrostFront":
                    c.beginPath(); c.moveTo(4, 15); c.lineTo(6, 9); c.lineTo(18, 9); c.lineTo(20, 15);
                    c.closePath(); c.stroke();
                    for (var a = 0; a < 3; a++) {
                        var ax = 8 + a * 4;
                        c.beginPath(); c.moveTo(ax, 20); c.lineTo(ax, 16.5); c.stroke();
                        c.beginPath(); c.moveTo(ax - 1, 17.6); c.lineTo(ax, 16.5); c.lineTo(ax + 1, 17.6); c.stroke();
                    }
                    break;
                case "defrostRear":
                    c.strokeRect(5, 8, 14, 8);
                    for (var b = 0; b < 3; b++) {
                        var bx = 8 + b * 4;
                        c.beginPath(); c.moveTo(bx, 21); c.lineTo(bx, 18); c.stroke();
                        c.beginPath(); c.moveTo(bx - 1, 19); c.lineTo(bx, 18); c.lineTo(bx + 1, 19); c.stroke();
                    }
                    break;
                case "recirc":
                    c.beginPath();
                    c.moveTo(5, 14); c.lineTo(7, 9); c.lineTo(17, 9); c.lineTo(19, 14);
                    c.stroke();
                    c.beginPath(); c.arc(12, 13, 4, Math.PI * 0.2, Math.PI * 1.5); c.stroke();
                    c.beginPath(); c.moveTo(8.4, 11.2); c.lineTo(8.2, 13.4); c.lineTo(10.3, 12.9); c.stroke();
                    break;
                }
            }
        }
        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: hv.on = !hv.on }
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
            Icon { anchors.centerIn: parent; name: "minus"; size: 18; color: T.text }
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
                Rectangle {   // knob
                    width: 10; height: 10; radius: 5; color: "#ffffff"
                    y: -3
                    x: parent.width * Math.max(0, Math.min(1, (tc.value - 16) / (30 - 16))) - width / 2
                }
            }
        }
        Rectangle {
            implicitWidth: 40; implicitHeight: 40; radius: 20
            color: mp.pressed ? T.glassHi : "transparent"
            border.width: 1; border.color: T.glassBorder
            Icon { anchors.centerIn: parent; name: "plus"; size: 18; color: T.text }
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
            spacing: 26
            Layout.alignment: Qt.AlignVCenter
            Hvac { kind: "seat" }
            Hvac { kind: "fan"; on: true }
            Text { text: "AUTO"; font.family: T.sans; font.pixelSize: 16; font.weight: Font.DemiBold
                   font.letterSpacing: 1.5; color: T.accent; Layout.alignment: Qt.AlignVCenter }
            Hvac { kind: "defrostFront" }
            Hvac { kind: "defrostRear" }
            Hvac { kind: "recirc" }
            Hvac { kind: "seat" }
        }

        Item { Layout.fillWidth: true }

        TempCtl { value: root.rightTemp }
    }
}
