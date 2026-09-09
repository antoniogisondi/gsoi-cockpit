import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

Item {
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 16

        RowLayout {
            spacing: 14
            SectionLabel { text: "Car Agent"; color: T.accent2_700 }
            Rectangle {
                radius: 2; color: Qt.rgba(0.84, 0, 0.42, 0.12)
                implicitWidth: tag.implicitWidth + 18; implicitHeight: tag.implicitHeight + 10
                Text { id: tag; anchors.centerIn: parent; text: "In ascolto"; font.family: T.serif; font.pixelSize: 14; color: T.accent2_700 }
            }
            Item { Layout.fillWidth: true }
            Text { text: "A bordo · funziona offline"; font.family: T.serif; font.pixelSize: 15; color: T.n600 }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 40

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 18
                Text { text: "Tu — «Trova un caricatore vicino allo studio e sposta le 10:30.»"; font.family: T.serif; font.pixelSize: 18; color: T.n700; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                Text {
                    text: "Due colonnine da 150 kW su Via Tortona, entrambe libere. Ho tenuto la più vicina per venti minuti e chiesto a Paolo di spostare la chiamata alle undici."
                    font.family: T.serif; font.pixelSize: 26; color: T.text; wrapMode: Text.WordWrap; Layout.fillWidth: true; lineHeight: 1.25
                }
                RowLayout {
                    spacing: 12
                    PrimaryButton { text: "Naviga e prenota" }
                    PrimaryButton { text: "Altra colonnina"; primary: false }
                }
                Item { Layout.fillHeight: true }
                Rectangle { Layout.fillWidth: true; height: 1; color: T.divider }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 8
                    spacing: 14
                    Text { text: "🎙"; font.pixelSize: 26; color: T.accent2_700 }
                    // finta waveform
                    Row {
                        spacing: 4
                        Repeater {
                            model: 28
                            delegate: Rectangle {
                                required property int index
                                width: 3
                                height: 6 + Math.abs(Math.sin(index * 0.7)) * 26
                                anchors.verticalCenter: parent.verticalCenter
                                color: T.accent2
                            }
                        }
                    }
                    Item { Layout.fillWidth: true }
                    Text { text: "oppure scrivi"; font.family: T.serif; font.pixelSize: 15; color: T.n600 }
                }
            }

            // Cronologia
            ColumnLayout {
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                spacing: 14
                SectionLabel { text: "In precedenza"; color: T.n600 }
                Text { text: "Abitacolo pre-riscaldato a 21° alle 08:40."; font.family: T.serif; font.pixelSize: 16; color: T.n700; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                Text { text: "Pioggia prevista alle 17:00 — ricordato il box da tetto."; font.family: T.serif; font.pixelSize: 16; color: T.n700; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                Text { text: "Pressione gomme registrata, anteriore sinistra -0.2 bar."; font.family: T.serif; font.pixelSize: 16; color: T.n700; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                Item { Layout.fillHeight: true }
            }
        }
    }
}
