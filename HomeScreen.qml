import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

Item {
    property var vehicle: null

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 30
        anchors.rightMargin: 30
        anchors.topMargin: 16
        anchors.bottomMargin: 22
        spacing: 0

        Text {
            text: "Buongiorno, Ana."
            font.family: T.serif
            font.pixelSize: 46
            font.weight: Font.DemiBold
            color: T.text
        }
        Text {
            Layout.fillWidth: true
            Layout.maximumWidth: 780
            Layout.topMargin: 4
            Layout.bottomMargin: 22
            text: "Carica all'84% durante la notte. Traffico scorrevole sulla A4 — arrivi in studio con nove minuti d'anticipo."
            wrapMode: Text.WordWrap
            font.family: T.serif
            font.pixelSize: 18
            color: T.n700
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 44

            // --- Prossima meta ---
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 6
                SectionLabel { text: "Prossima meta" }
                Text {
                    text: "Studio Ventuno"
                    font.family: T.serif; font.pixelSize: 30; font.weight: Font.DemiBold; color: T.text
                }
                Text {
                    text: "Via Tortona 21 · 14 min · 9.4 km"
                    font.family: T.serif; font.pixelSize: 17; color: T.n700
                }
                PrimaryButton { text: "Avvia percorso"; Layout.topMargin: 10 }
                Item { Layout.fillHeight: true }
            }

            // --- In riproduzione ---
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 6
                SectionLabel { text: "In riproduzione" }
                RowLayout {
                    spacing: 14
                    Rectangle {
                        width: 84; height: 84
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: T.n400 }
                            GradientStop { position: 1.0; color: T.n700 }
                        }
                    }
                    ColumnLayout {
                        spacing: 2
                        Text { text: vehicle ? vehicle.mediaTitle : "—"; font.family: T.serif; font.pixelSize: 24; font.weight: Font.DemiBold; color: T.text }
                        Text { text: vehicle ? vehicle.mediaArtist : ""; font.family: T.serif; font.pixelSize: 16; color: T.n700 }
                        Text { text: "Bluetooth · iPhone di Ana"; font.family: T.serif; font.pixelSize: 14; color: T.n600; Layout.topMargin: 6 }
                    }
                }
                Item { Layout.fillHeight: true }
            }

            // --- Veicolo ---
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 6
                SectionLabel { text: "Veicolo" }
                RowLayout {
                    spacing: 8
                    Text { text: (vehicle ? vehicle.chargePct : 84) + "%"; font.family: T.serif; font.pixelSize: 40; font.weight: Font.DemiBold; color: T.text }
                    Text { text: (vehicle ? vehicle.rangeKm : 412) + " km"; font.family: T.serif; font.pixelSize: 17; color: T.n700; Layout.alignment: Qt.AlignBottom; Layout.bottomMargin: 8 }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 240
                    height: 8
                    color: T.n300
                    Layout.topMargin: 8
                    Rectangle { width: parent.width * (vehicle ? vehicle.chargePct / 100 : 0.84); height: parent.height; color: T.accent }
                }
                Text {
                    text: "Gomme ok · Abitacolo 21°\nSoftware aggiornato"
                    font.family: T.serif; font.pixelSize: 16; color: T.n700; Layout.topMargin: 12; lineHeight: 1.4
                }
                Item { Layout.fillHeight: true }
            }
        }

        // --- Striscia Agent ---
        Rectangle { Layout.fillWidth: true; height: 1; color: T.divider; Layout.topMargin: 8 }
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 14
            spacing: 14
            Icon { name: "sparkle"; size: 24; color: T.accent2_700 }
            Text {
                Layout.fillWidth: true
                text: "Agent — Il tuo appuntamento delle 10:30 è stato spostato alle 10:00. Parti fra sei minuti?"
                font.family: T.serif; font.pixelSize: 18; color: T.text; wrapMode: Text.WordWrap
            }
            PrimaryButton { text: "Apri"; primary: false }
        }
    }
}
