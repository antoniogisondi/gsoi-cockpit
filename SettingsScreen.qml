import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Settings (fedele al mockup): elenco Vehicle / Connectivity / System / Sound /
// Display / About a sinistra, pannello scenografico a destra.
Item {
    id: root

    // Icone a linea per i glifi non presenti in Phosphor.
    component LineIcon: Canvas {
        property string kind: ""
        property color color: T.accent
        width: 22; height: 22
        onColorChanged: requestPaint()
        onPaint: {
            var c = getContext("2d"); c.reset();
            var u = width / 24; c.scale(u, u);
            c.strokeStyle = color; c.fillStyle = color;
            c.lineWidth = 1.7; c.lineCap = "round"; c.lineJoin = "round";
            switch (kind) {
            case "display":
                c.strokeRect(3, 5, 18, 12);
                c.beginPath(); c.moveTo(9, 20); c.lineTo(15, 20); c.stroke();
                c.beginPath(); c.moveTo(12, 17); c.lineTo(12, 20); c.stroke();
                break;
            case "about":
                c.beginPath(); c.arc(12, 12, 8.5, 0, Math.PI * 2); c.stroke();
                c.beginPath(); c.arc(12, 8, 0.9, 0, Math.PI * 2); c.fill();
                c.beginPath(); c.moveTo(12, 11); c.lineTo(12, 16.5); c.stroke();
                break;
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 40
        anchors.rightMargin: 34
        anchors.topMargin: 28
        anchors.bottomMargin: 26
        spacing: 30

        // ------------------------------------------------------------- LISTA
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            Repeater {
                model: [
                    ["car",          "",        "Vehicle",      "Displays, driving modes, assistance systems"],
                    ["wifi-high",    "",        "Connectivity", "Wi-Fi, Bluetooth, mobile network"],
                    ["gear",         "",        "System",       "Updates, language, time, units"],
                    ["speaker-high", "",        "Sound",        "Audio settings, balance, immersive sound"],
                    ["",             "display", "Display",      "Brightness, theme, cockpit layout"],
                    ["",             "about",   "About",        "GSOI Automotive OS — Version 1.0.0"]
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: 66
                    radius: 12
                    color: ma.pressed ? T.glassHi : (ma.containsMouse ? T.glass : "transparent")
                    border.width: 1
                    border.color: ma.containsMouse ? T.glassBorder : "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12; anchors.rightMargin: 16
                        spacing: 14
                        Rectangle {
                            width: 42; height: 42; radius: 21; color: T.glassHi
                            Icon { visible: modelData[0] !== ""; anchors.centerIn: parent
                                   name: modelData[0]; size: 21; color: T.accent }
                            LineIcon { visible: modelData[1] !== ""; anchors.centerIn: parent
                                       kind: modelData[1]; color: T.accent }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1
                            Text { text: modelData[2]; font.family: T.sans; font.pixelSize: 18
                                   font.weight: Font.DemiBold; color: T.text }
                            Text { text: modelData[3]; font.family: T.sans; font.pixelSize: 14
                                   color: T.n600; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
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

        // ---------------------------------------------------------- PANNELLO
        Rectangle {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            radius: 16
            color: T.surface
            clip: true
            border.width: 1; border.color: T.glassBorder

            HeroBackground { anchors.fill: parent }

            ColumnLayout {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 22
                spacing: 2
                Repeater {
                    model: [["BUILT", false], ["FOR A", false],
                            ["MORE INTELLIGENT", false], ["ROAD AHEAD", true]]
                    delegate: Text {
                        required property var modelData
                        Layout.alignment: Qt.AlignRight
                        text: modelData[0]
                        font.family: T.sans; font.pixelSize: 17; font.weight: Font.DemiBold
                        font.letterSpacing: 2.5; color: modelData[1] ? T.accent : T.text
                    }
                }
            }
        }
    }
}
