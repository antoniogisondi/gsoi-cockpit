import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

Item {
    property var vehicle: null

    RowLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 40

        // Copertina + titolo
        ColumnLayout {
            Layout.preferredWidth: 320
            spacing: 14
            Rectangle {
                Layout.preferredWidth: 300; Layout.preferredHeight: 300
                gradient: Gradient {
                    GradientStop { position: 0.0; color: T.n300 }
                    GradientStop { position: 1.0; color: T.n800 }
                }
            }
            Text { text: vehicle ? vehicle.mediaTitle : "—"; font.family: T.serif; font.pixelSize: 32; font.weight: Font.DemiBold; color: T.text }
            Text { text: (vehicle ? vehicle.mediaArtist : "") + " · Nocturnes for a City"; font.family: T.serif; font.pixelSize: 17; color: T.n700; wrapMode: Text.WordWrap; Layout.fillWidth: true }
            Item { Layout.fillHeight: true }
        }

        // Coda + controlli
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8
            SectionLabel { text: "Coda · Bluetooth, iPhone di Ana" }

            Repeater {
                model: [
                    ["♪", "Ostinato", "Marta Bellini Trio", "4:12", true],
                    ["2", "Cortile", "Marta Bellini Trio", "3:38", false],
                    ["3", "Grey Light, Bassano", "Ferro Quartet", "6:02", false],
                    ["4", "Fermata", "Ilaria Rho", "2:55", false]
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    spacing: 14
                    Text { text: modelData[0]; font.pixelSize: 18; color: modelData[4] ? T.accent700 : T.n600; Layout.preferredWidth: 26 }
                    Text { text: modelData[1]; font.family: T.serif; font.pixelSize: 18; color: T.text; Layout.preferredWidth: 240 }
                    Text { text: modelData[2]; font.family: T.serif; font.pixelSize: 18; color: T.n600; Layout.fillWidth: true }
                    Text { text: modelData[3]; font.family: T.serif; font.pixelSize: 18; color: T.n600 }
                }
            }

            Item { Layout.fillHeight: true }

            // Progresso
            Rectangle {
                Layout.fillWidth: true; height: 6; color: T.n300
                Rectangle { width: parent.width * 0.38; height: parent.height; color: T.accent }
            }
            RowLayout {
                Layout.fillWidth: true
                Text { text: "1:34"; font.pixelSize: 14; color: T.n600 }
                Item { Layout.fillWidth: true }
                Text { text: "4:12"; font.pixelSize: 14; color: T.n600 }
            }
            // Controlli
            RowLayout {
                Layout.topMargin: 8
                spacing: 18
                IconButton { icon: "skip-back"; size: 56 }
                IconButton { icon: "pause"; size: 68; round: true; primary: true }
                IconButton { icon: "skip-forward"; size: 56 }
                Item { Layout.fillWidth: true }
                Icon { name: "speaker-high"; size: 24; color: T.n700 }
            }
        }
    }
}
