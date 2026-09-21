import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Settings (mockup): elenco Vehicle / Connectivity / System / Sound / Display /
// About a sinistra, pannello scenografico a destra.
Item {
    id: root

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
                    ["car",      "Vehicle",      "Displays, driving modes, assistance systems"],
                    ["wifi",     "Connectivity", "Wi-Fi, Bluetooth, mobile network"],
                    ["settings", "System",       "Updates, language, time, units"],
                    ["speaker",  "Sound",        "Audio settings, balance, immersive sound"],
                    ["display",  "Display",      "Brightness, theme, cockpit layout"],
                    ["info",     "About",        "GSOI Automotive OS — Version 1.0.0"]
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
                            Icon { anchors.centerIn: parent; name: modelData[0]; size: 22 }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1
                            Text { text: modelData[1]; font.family: T.sans; font.pixelSize: 18
                                   font.weight: Font.DemiBold; color: T.text }
                            Text { text: modelData[2]; font.family: T.sans; font.pixelSize: 14
                                   color: T.n600; Layout.fillWidth: true; elide: Text.ElideRight }
                        }
                        Icon { name: "chevron"; size: 16 }
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
