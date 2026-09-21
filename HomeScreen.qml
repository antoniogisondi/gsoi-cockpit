import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Home di GSOI Automotive OS (fedele al mockup): hero "Good morning" su sfondo
// atmosferico, 4 tile rapide, riga di 4 card informative.
Item {
    id: root
    property var vehicle: null
    signal openScreen(string screen)

    // Chevron riutilizzabile (nessun default-alias: sicuro).
    component Chevron: Canvas {
        width: 10; height: 15
        onPaint: {
            var c = getContext("2d"); c.reset();
            c.strokeStyle = T.n600; c.lineWidth = 1.8; c.lineCap = "round"; c.lineJoin = "round";
            c.beginPath(); c.moveTo(3, 2.5); c.lineTo(8, 7.5); c.lineTo(3, 12.5); c.stroke();
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ---------------------------------------------------------------- HERO
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            HeroBackground { anchors.fill: parent }

            Column {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 44
                anchors.topMargin: 40
                spacing: 2
                Text {
                    text: "Good morning,"
                    font.family: T.sans; font.pixelSize: 46; font.weight: Font.DemiBold
                    color: T.text
                }
                Text {
                    text: "Let’s drive the next chapter."
                    font.family: T.sans; font.pixelSize: 34; font.weight: Font.Normal
                    color: T.n800
                }
                Text {
                    text: "Smarter journeys. A more human drive."
                    font.family: T.sans; font.pixelSize: 18; color: T.n700
                    topPadding: 8
                }
            }

            // Tile rapide
            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 44
                anchors.rightMargin: 40
                anchors.bottomMargin: 26
                spacing: 18

                Tile {
                    Layout.fillWidth: true; Layout.preferredHeight: 92
                    icon: "navigation-arrow"; title: "Navigation"; subtitle: "Munich"
                    onClicked: root.openScreen("nav")
                }
                Tile {
                    Layout.fillWidth: true; Layout.preferredHeight: 92
                    icon: "speaker-high"; title: "Radio"; subtitle: "87.5 MHz"
                    onClicked: root.openScreen("media")
                }
                Tile {
                    Layout.fillWidth: true; Layout.preferredHeight: 92
                    icon: "bluetooth-connected"; title: "Bluetooth"; subtitle: "Pixel 8 Pro"
                    onClicked: root.openScreen("phone")
                }
                Tile {
                    Layout.fillWidth: true; Layout.preferredHeight: 92
                    icon: "sparkle"; title: "AI Assistant"; subtitle: "Ready"
                    onClicked: root.openScreen("agent")
                }
            }
        }

        // ---------------------------------------------------- CARD INFORMATIVE
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 168
            Layout.leftMargin: 44
            Layout.rightMargin: 40
            Layout.topMargin: 18
            Layout.bottomMargin: 20
            spacing: 18

            // Meteo / posizione
            Rectangle {
                Layout.fillWidth: true; Layout.fillHeight: true
                radius: 14; color: T.glass; border.width: 1; border.color: T.glassBorder
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 16; spacing: 10
                    RowLayout {
                        Layout.fillWidth: true; spacing: 9
                        Icon { name: "thermometer-simple"; size: 17; color: T.n600 }
                        Text { Layout.fillWidth: true; text: "Munich"
                               font.family: T.sans; font.pixelSize: 14; color: T.n700 }
                        Chevron {}
                    }
                    RowLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 12
                        Text { text: "24°"; font.family: T.num; font.pixelSize: 44
                               font.weight: Font.DemiBold; color: T.text; Layout.alignment: Qt.AlignVCenter }
                        Text { text: "Clear skies"; font.family: T.sans; font.pixelSize: 15
                               color: T.n700; Layout.alignment: Qt.AlignVCenter }
                        Item { Layout.fillWidth: true }
                    }
                }
            }

            // Prossima meta
            Rectangle {
                Layout.fillWidth: true; Layout.fillHeight: true
                radius: 14; color: T.glass; border.width: 1; border.color: T.glassBorder
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 16; spacing: 10
                    RowLayout {
                        Layout.fillWidth: true; spacing: 9
                        Icon { name: "navigation-arrow"; size: 17; color: T.n600 }
                        Text { Layout.fillWidth: true; text: "Next destination"
                               font.family: T.sans; font.pixelSize: 14; color: T.n700 }
                        Chevron {}
                    }
                    ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2
                        Item { Layout.fillHeight: true }
                        Text { text: "BMW Welt"; font.family: T.sans; font.pixelSize: 21
                               font.weight: Font.DemiBold; color: T.text }
                        Text { text: "Am Olympiapark 1, München"; font.family: T.sans
                               font.pixelSize: 14; color: T.n600; Layout.fillWidth: true; elide: Text.ElideRight }
                        Text { text: "28 min · 12 km"; font.family: T.sans; font.pixelSize: 15
                               color: T.accent; topPadding: 4 }
                        Item { Layout.fillHeight: true }
                    }
                }
            }

            // Agenda
            Rectangle {
                Layout.fillWidth: true; Layout.fillHeight: true
                radius: 14; color: T.glass; border.width: 1; border.color: T.glassBorder
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 16; spacing: 10
                    RowLayout {
                        Layout.fillWidth: true; spacing: 9
                        Text { Layout.fillWidth: true; text: "Today"
                               font.family: T.sans; font.pixelSize: 14; color: T.n700 }
                        Chevron {}
                    }
                    ColumnLayout {
                        Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2
                        Item { Layout.fillHeight: true }
                        Text { text: "Team Sync"; font.family: T.sans; font.pixelSize: 21
                               font.weight: Font.DemiBold; color: T.text }
                        Text { text: "11:00 – 11:30"; font.family: T.sans; font.pixelSize: 15; color: T.n700 }
                        Text { text: "Microsoft Teams"; font.family: T.sans; font.pixelSize: 14
                               color: T.n600; topPadding: 2 }
                        Item { Layout.fillHeight: true }
                    }
                }
            }

            // Pannello brand
            Rectangle {
                Layout.fillWidth: true; Layout.fillHeight: true
                radius: 14
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#0e1420" }
                    GradientStop { position: 1.0; color: "#0a1622" }
                }
                border.width: 1; border.color: T.glassBorder

                ColumnLayout {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 22
                    spacing: 4
                    Repeater {
                        model: ["PEOPLE", "VEHICLES", "INTELLIGENCE", "TOGETHER"]
                        delegate: Text {
                            required property var modelData
                            Layout.alignment: Qt.AlignRight
                            text: modelData
                            font.family: T.sans; font.pixelSize: 15; font.weight: Font.Medium
                            font.letterSpacing: 3.5; color: T.n800
                        }
                    }
                    Rectangle {
                        Layout.alignment: Qt.AlignRight
                        Layout.topMargin: 6
                        width: 54; height: 2; radius: 1; color: T.accent
                    }
                }
            }
        }
    }
}
