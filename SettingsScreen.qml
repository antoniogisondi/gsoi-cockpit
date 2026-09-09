import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

Item {
    RowLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 48

        // Veicolo
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            SectionLabel { text: "Veicolo" }
            Repeater {
                model: [
                    ["Modalità di guida", "Comfort", false],
                    ["Frenata rigenerativa", "Standard", false],
                    ["Limite di carica", "85%", false],
                    ["Blocco all'allontanamento", "Attivo", true]
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Text { text: modelData[0]; font.family: T.serif; font.pixelSize: 19; color: T.text; Layout.fillWidth: true }
                    Text { text: modelData[1]; font.family: T.serif; font.pixelSize: 18; color: modelData[2] ? T.accent700 : T.n600 }
                }
            }
            Item { Layout.fillHeight: true }
        }

        // Agent e privacy
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            SectionLabel { text: "Agent e privacy" }
            Repeater {
                model: [
                    ["Wake word «Hey GSOI»", "Attivo", true],
                    ["Suggerimenti proattivi", "Attivi", true],
                    ["Elabora voce a bordo", "Sempre", true],
                    ["Condividi dati di viaggio", "Off", false]
                ]
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    Text { text: modelData[0]; font.family: T.serif; font.pixelSize: 19; color: T.text; Layout.fillWidth: true }
                    Text { text: modelData[1]; font.family: T.serif; font.pixelSize: 18; color: modelData[2] ? T.accent700 : T.n600 }
                }
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: T.divider; Layout.topMargin: 8 }
            Text { text: "Genesis 0.1 · GSOI Automotive OS\nProssimo aggiornamento via Wi-Fi a casa"; font.family: T.serif; font.pixelSize: 16; color: T.n700; Layout.topMargin: 8; lineHeight: 1.5 }
            Item { Layout.fillHeight: true }
        }
    }
}
