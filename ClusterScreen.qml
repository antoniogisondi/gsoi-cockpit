import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

Item {
    RowLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 36

        // Velocita' (effetto "lastre" CMYK approssimato)
        ColumnLayout {
            Layout.preferredWidth: 420
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            Item {
                Layout.preferredWidth: 360
                Layout.preferredHeight: 180
                // frange di colore (mis-registro di stampa)
                Text { anchors.centerIn: parent; anchors.horizontalCenterOffset: 3; anchors.verticalCenterOffset: 2
                    text: "58"; font.family: T.serif; font.pixelSize: 190; font.weight: Font.DemiBold; color: T.accent2 }
                Text { anchors.centerIn: parent; anchors.horizontalCenterOffset: -3; anchors.verticalCenterOffset: -2
                    text: "58"; font.family: T.serif; font.pixelSize: 190; font.weight: Font.DemiBold; color: T.accent }
                Text { anchors.centerIn: parent
                    text: "58"; font.family: T.serif; font.pixelSize: 190; font.weight: Font.DemiBold; color: T.text }
            }
            Text { text: "km/h"; font.family: T.serif; font.pixelSize: 26; color: T.n700; Layout.leftMargin: 8 }
            RowLayout {
                spacing: 22
                Layout.leftMargin: 8
                Layout.topMargin: 10
                Text { text: "D · Drive"; font.family: T.serif; font.pixelSize: 18; color: T.text }
                Text { text: "Limite 50"; font.family: T.serif; font.pixelSize: 18; color: T.n700 }
                Text { text: "Tragitto 12.8 km"; font.family: T.serif; font.pixelSize: 18; color: T.n700 }
            }
        }

        Item { Layout.fillWidth: true }

        // ADAS
        ColumnLayout {
            Layout.preferredWidth: 300
            Layout.alignment: Qt.AlignVCenter
            spacing: 16
            Rectangle { width: 1; height: 0 } // spacer
            Text { text: "Assistente di corsia attivo"; font.family: T.serif; font.pixelSize: 20; color: T.accent700 }
            Text { text: "Distanza · 2 barre"; font.family: T.serif; font.pixelSize: 20; color: T.accent700 }
            Text { text: "Cruise impostato a 50"; font.family: T.serif; font.pixelSize: 20; color: T.n700 }
            Text { text: "⚠ Gomma ant. sinistra bassa"; font.family: T.serif; font.pixelSize: 20; color: T.accent2_700 }
        }
    }
}
