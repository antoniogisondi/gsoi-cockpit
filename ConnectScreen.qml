import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

Item {
    RowLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 48

        // Bluetooth
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            SectionLabel { text: "Bluetooth" }
            Repeater {
                model: [
                    ["iPhone di Ana", "Telefono · Audio", "72%", true],
                    ["Marco — Pixel 9", "Accoppiato", "—", false],
                    ["Sennheiser HD 250", "Audio posteriore", "41%", false]
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Text { text: modelData[0]; font.family: T.serif; font.pixelSize: 18; color: modelData[3] ? T.accent700 : T.text; Layout.preferredWidth: 220 }
                    Text { text: modelData[1]; font.family: T.serif; font.pixelSize: 16; color: T.n600; Layout.fillWidth: true }
                    Text { text: modelData[2]; font.family: T.serif; font.pixelSize: 16; color: T.n700 }
                }
            }
            PrimaryButton { text: "Accoppia dispositivo"; primary: false; Layout.topMargin: 8 }
            Item { Layout.fillHeight: true }
        }

        // Wi-Fi
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            SectionLabel { text: "Wi-Fi e dati" }
            Repeater {
                model: [
                    ["Studio Ventuno", "Connesso"],
                    ["Tortona Guest", "Aperta"],
                    ["FASTWEB-4A21", "Salvata"]
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Text { text: modelData[0]; font.family: T.serif; font.pixelSize: 18; color: T.text; Layout.fillWidth: true }
                    Text { text: modelData[1]; font.family: T.serif; font.pixelSize: 16; color: T.n600 }
                }
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: T.divider; Layout.topMargin: 8 }
            Text {
                text: "Dati veicolo · 4.2 GB di 20 GB questo mese\nAggiornamenti solo via Wi-Fi"
                font.family: T.serif; font.pixelSize: 16; color: T.n700; Layout.topMargin: 8; lineHeight: 1.5
            }
            Item { Layout.fillHeight: true }
        }
    }
}
