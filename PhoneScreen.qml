import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

Item {
    RowLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 44

        // Recenti
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 14
            SectionLabel { text: "Recenti" }
            Repeater {
                model: [
                    ["↙", "Paolo Rizzi", "Persa · 08:52", T.accent2_700],
                    ["↗", "Studio Ventuno", "Ieri · 4 min", T.n600],
                    ["↗", "Mamma", "Dom · 22 min", T.n600]
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    spacing: 14
                    Text { text: modelData[0]; font.pixelSize: 20; color: modelData[3]; Layout.preferredWidth: 24 }
                    Text { text: modelData[1]; font.family: T.serif; font.pixelSize: 19; color: T.text; Layout.preferredWidth: 200 }
                    Text { text: modelData[2]; font.family: T.serif; font.pixelSize: 16; color: T.n600; Layout.fillWidth: true }
                    PrimaryButton { text: "Chiama"; primary: false }
                }
            }
            Item { Layout.fillHeight: true }
        }

        // In chiamata
        ColumnLayout {
            Layout.preferredWidth: 340
            Layout.fillHeight: true
            spacing: 6
            SectionLabel { text: "In chiamata"; color: T.n600 }
            Text { text: "Paolo Rizzi"; font.family: T.serif; font.pixelSize: 34; font.weight: Font.DemiBold; color: T.text }
            Text { text: "Mobile · 02:14"; font.family: T.serif; font.pixelSize: 18; color: T.n700 }
            Text { text: "Instradata sugli altoparlanti"; font.family: T.serif; font.pixelSize: 15; color: T.n600 }
            Item { Layout.fillHeight: true }
            RowLayout {
                spacing: 14
                PrimaryButton { text: "Muto"; primary: false }
                PrimaryButton { text: "Tastiera"; primary: false }
                Rectangle {
                    implicitWidth: 90; implicitHeight: 42; radius: 2; color: T.accent2
                    Text { anchors.centerIn: parent; text: "Chiudi"; font.family: T.serif; font.pixelSize: 17; font.weight: Font.DemiBold; color: "#ffffff" }
                }
            }
        }
    }
}
