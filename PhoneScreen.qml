import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Phone (mockup): dispositivo connesso (Pixel 8 Pro) con azioni rapide, a
// destra l'elenco Call history / Contacts / Dial / Messages / Bluetooth.
Item {
    id: root

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
                Rectangle {
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
                    model: ["phone", "message", "person"]
                    delegate: Rectangle {
                        required property var modelData
                        width: 52; height: 52; radius: 26
                        color: mm.pressed ? T.glassHi : T.glass
                        border.width: 1; border.color: T.glassBorder
                        Icon { anchors.centerIn: parent; name: modelData; size: 24 }
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
                    ["clock",     "Call history"],
                    ["person",    "Contacts"],
                    ["dial",      "Dial number"],
                    ["message",   "Messages"],
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
                            Icon { anchors.centerIn: parent; name: modelData[0]; size: 22 }
                        }
                        Text { Layout.fillWidth: true; text: modelData[1]
                               font.family: T.sans; font.pixelSize: 18; color: T.text }
                        Icon { name: "chevron"; size: 16 }
                    }
                    MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor }
                }
            }
            Item { Layout.fillHeight: true }
        }
    }
}
