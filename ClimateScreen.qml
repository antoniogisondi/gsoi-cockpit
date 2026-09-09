import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

Item {
    RowLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 44

        // Guidatore
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            SectionLabel { text: "Guidatore" }
            RowLayout {
                spacing: 6
                Text { text: "21"; font.family: T.serif; font.pixelSize: 88; font.weight: Font.DemiBold; color: T.text }
                Text { text: "°C"; font.family: T.serif; font.pixelSize: 30; color: T.n600; Layout.alignment: Qt.AlignTop; Layout.topMargin: 16 }
            }
            RowLayout {
                spacing: 12
                PrimaryButton { text: "−"; primary: false }
                PrimaryButton { text: "+"; primary: false }
            }
            Text { text: "Sedile riscaldato · liv. 2\nVolante · acceso"; font.family: T.serif; font.pixelSize: 16; color: T.n700; Layout.topMargin: 18; lineHeight: 1.5 }
            Item { Layout.fillHeight: true }
        }

        // Passeggero
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            SectionLabel { text: "Passeggero" }
            RowLayout {
                spacing: 6
                Text { text: "19"; font.family: T.serif; font.pixelSize: 88; font.weight: Font.DemiBold; color: T.n600 }
                Text { text: "°C"; font.family: T.serif; font.pixelSize: 30; color: T.n600; Layout.alignment: Qt.AlignTop; Layout.topMargin: 16 }
            }
            RowLayout {
                spacing: 12
                PrimaryButton { text: "−"; primary: false }
                PrimaryButton { text: "+"; primary: false }
            }
            Text { text: "Sedile riscaldato · off\nSincronizzato · no"; font.family: T.serif; font.pixelSize: 16; color: T.n700; Layout.topMargin: 18; lineHeight: 1.5 }
            Item { Layout.fillHeight: true }
        }

        // Ventola
        ColumnLayout {
            Layout.preferredWidth: 220
            spacing: 12
            SectionLabel { text: "Ventola"; color: T.n600 }
            RowLayout {
                spacing: 6
                Repeater {
                    model: [24, 36, 48, 60, 64]
                    delegate: Rectangle {
                        required property var modelData
                        required property int index
                        width: 24; height: modelData
                        Layout.alignment: Qt.AlignBottom
                        color: index < 3 ? T.accent : T.n300
                    }
                }
            }
            Text { text: "Ricircolo off · Sbrinamento off\nFiltro abitacolo pulito"; font.family: T.serif; font.pixelSize: 16; color: T.n700; Layout.topMargin: 20; lineHeight: 1.5 }
            Item { Layout.fillHeight: true }
        }
    }
}
