import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Phone (fedele al mockup): al centro il dispositivo connesso (Pixel 8 Pro) con
// azioni rapide, a destra l'elenco Call history / Contacts / Dial / Messages /
// Bluetooth settings.
Item {
    id: root

    // Icona a linea disegnata (per i glifi non presenti in Phosphor).
    component LineIcon: Canvas {
        property string kind: ""
        property color color: T.text
        width: 22; height: 22
        onColorChanged: requestPaint()
        onPaint: {
            var c = getContext("2d"); c.reset();
            var u = width / 24; c.scale(u, u);
            c.strokeStyle = color; c.fillStyle = color;
            c.lineWidth = 1.7; c.lineCap = "round"; c.lineJoin = "round";
            switch (kind) {
            case "phone":
                c.beginPath();
                c.moveTo(7, 4); c.lineTo(10, 4); c.lineTo(12, 9); c.lineTo(10, 11);
                c.bezierCurveTo(11, 14, 13, 16, 16, 17); c.lineTo(18, 15); c.lineTo(22, 17);
                c.lineTo(22, 20); c.bezierCurveTo(13, 21, 5, 13, 7, 4); c.closePath(); c.stroke();
                break;
            case "history":
                c.beginPath(); c.arc(12, 13, 7.5, 0, Math.PI * 2); c.stroke();
                c.beginPath(); c.moveTo(12, 9); c.lineTo(12, 13); c.lineTo(15, 15); c.stroke();
                c.beginPath(); c.moveTo(5, 6); c.lineTo(5, 9.5); c.lineTo(8.5, 9.5); c.stroke();
                break;
            case "contacts":
                c.beginPath(); c.arc(12, 8, 3.2, 0, Math.PI * 2); c.stroke();
                c.beginPath(); c.arc(12, 20, 6.5, Math.PI * 1.15, Math.PI * 1.85); c.stroke();
                break;
            case "dial":
                for (var r = 0; r < 3; r++)
                    for (var col = 0; col < 3; col++) {
                        c.beginPath(); c.arc(7 + col * 5, 6 + r * 5, 1.3, 0, Math.PI * 2); c.fill();
                    }
                break;
            case "messages":
                c.beginPath();
                c.moveTo(5, 6); c.lineTo(19, 6); c.quadraticCurveTo(21, 6, 21, 8);
                c.lineTo(21, 15); c.quadraticCurveTo(21, 17, 19, 17);
                c.lineTo(10, 17); c.lineTo(6, 20); c.lineTo(6, 17); c.lineTo(5, 17);
                c.quadraticCurveTo(3, 17, 3, 15); c.lineTo(3, 8);
                c.quadraticCurveTo(3, 6, 5, 6); c.closePath(); c.stroke();
                break;
            case "bluetooth":
                c.beginPath();
                c.moveTo(8, 8); c.lineTo(16, 16); c.lineTo(12, 20); c.lineTo(12, 4);
                c.lineTo(16, 8); c.lineTo(8, 16); c.stroke();
                break;
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 40
        anchors.rightMargin: 34
        anchors.topMargin: 30
        anchors.bottomMargin: 28
        spacing: 40

        // ---------------------------------------------------- DISPOSITIVO
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 18

            Item { Layout.fillHeight: true }

            // "telefono"
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 150; height: 300; radius: 28
                color: "#0b1017"; border.width: 1; border.color: T.glassBorder
                Rectangle {
                    anchors.fill: parent; anchors.margins: 8; radius: 22
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#12263f" }
                        GradientStop { position: 1.0; color: "#0a1420" }
                    }
                }
                Rectangle {   // notch
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 18; width: 46; height: 6; radius: 3; color: "#060a10"
                }
            }

            Text { Layout.alignment: Qt.AlignHCenter; text: "Pixel 8 Pro"
                   font.family: T.sans; font.pixelSize: 22; font.weight: Font.DemiBold; color: T.text }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 8
                Rectangle { width: 9; height: 9; radius: 4.5; color: T.green
                            Layout.alignment: Qt.AlignVCenter }
                Text { text: "Connected"; font.family: T.sans; font.pixelSize: 15; color: T.n700 }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter; spacing: 18
                Layout.topMargin: 4
                Repeater {
                    model: [["phone", T.green], ["messages", T.accent], ["contacts", T.n700]]
                    delegate: Rectangle {
                        required property var modelData
                        width: 52; height: 52; radius: 26
                        color: mm.pressed ? T.glassHi : T.glass
                        border.width: 1; border.color: T.glassBorder
                        LineIcon { anchors.centerIn: parent; kind: modelData[0]; color: modelData[1]; width: 24; height: 24 }
                        MouseArea { id: mm; anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }

        // --------------------------------------------------------- AZIONI
        ColumnLayout {
            Layout.preferredWidth: 320
            Layout.fillHeight: true
            spacing: 12

            Item { Layout.fillHeight: true }
            Repeater {
                model: [
                    ["history",   "Call history"],
                    ["contacts",  "Contacts"],
                    ["dial",      "Dial number"],
                    ["messages",  "Messages"],
                    ["bluetooth", "Bluetooth settings"]
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: 64
                    radius: 12
                    color: ma.pressed ? T.glassHi : T.glass
                    border.width: 1; border.color: ma.containsMouse ? T.accent : T.glassBorder
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14; anchors.rightMargin: 16
                        spacing: 14
                        Rectangle {
                            width: 40; height: 40; radius: 20; color: T.glassHi
                            LineIcon { anchors.centerIn: parent; kind: modelData[0]; color: T.accent; width: 21; height: 21 }
                        }
                        Text { Layout.fillWidth: true; text: modelData[1]
                               font.family: T.sans; font.pixelSize: 18; color: T.text }
                        Canvas {
                            width: 10; height: 15
                            onPaint: {
                                var c = getContext("2d"); c.reset();
                                c.strokeStyle = T.n600; c.lineWidth = 1.8; c.lineCap = "round"; c.lineJoin = "round";
                                c.beginPath(); c.moveTo(3, 2.5); c.lineTo(8, 7.5); c.lineTo(3, 12.5); c.stroke();
                            }
                        }
                    }
                    MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor }
                }
            }
            Item { Layout.fillHeight: true }
        }
    }
}
