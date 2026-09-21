import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Home di GSOI Automotive OS (mockup): hero "Good morning" con foto reale, riga
// di 4 tile rapide, riga di 4 card informative. Layout ad ancore.
Item {
    id: root
    property var vehicle: null
    property url heroSource: ""
    signal openScreen(string screen)

    // ============================================================== HERO (62%)
    Item {
        id: heroRegion
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Math.round(parent.height * 0.62)

        HeroBackground {
            anchors.fill: parent
            source: root.heroSource != "" ? root.heroSource : Qt.resolvedUrl("images/hero.png")
        }

        Column {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 44
            anchors.topMargin: 40
            spacing: 2
            Text {
                text: "Good morning,"
                font.family: T.sans; font.pixelSize: 46; font.weight: Font.DemiBold; color: T.text
            }
            Text {
                text: "Let’s drive the next chapter."
                font.family: T.sans; font.pixelSize: 34; color: T.n800
            }
            Text {
                text: "Smarter journeys. A more human drive."
                font.family: T.sans; font.pixelSize: 18; color: T.n700; topPadding: 8
            }
        }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 44
            anchors.rightMargin: 40
            anchors.bottomMargin: 24
            spacing: 18
            Tile { Layout.fillWidth: true; Layout.preferredHeight: 92
                   icon: "nav"; title: "Navigation"; subtitle: "Munich"; onClicked: root.openScreen("nav") }
            Tile { Layout.fillWidth: true; Layout.preferredHeight: 92
                   icon: "radio"; title: "Radio"; subtitle: "87.5 MHz"; onClicked: root.openScreen("media") }
            Tile { Layout.fillWidth: true; Layout.preferredHeight: 92
                   icon: "bluetooth"; title: "Bluetooth"; subtitle: "Pixel 8 Pro"; onClicked: root.openScreen("phone") }
            Tile { Layout.fillWidth: true; Layout.preferredHeight: 92
                   icon: "ai"; title: "AI Assistant"
                   subtitle: (!root.vehicle || root.vehicle.jarvisOnline) ? "Ready" : "Offline"
                   onClicked: root.openScreen("agent") }
        }
    }

    // ======================================================= CARD INFO (resto)
    RowLayout {
        anchors.top: heroRegion.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 44
        anchors.rightMargin: 40
        anchors.topMargin: 18
        anchors.bottomMargin: 22
        spacing: 18

        // ---- Meteo (con thumbnail paesaggio) ----
        Rectangle {
            Layout.fillWidth: true; Layout.fillHeight: true
            radius: 14; color: T.glass; border.width: 1; border.color: T.glassBorder; clip: true
            Image {
                anchors.fill: parent
                source: Qt.resolvedUrl("images/hero.png")
                sourceClipRect: Qt.rect(520, 40, 900, 560)
                fillMode: Image.PreserveAspectCrop
                opacity: 0.55
            }
            Rectangle { anchors.fill: parent; color: "#99060f19" }
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 16; spacing: 6
                RowLayout {
                    Layout.fillWidth: true; spacing: 9
                    Icon { name: "pin"; size: 17 }
                    Text { Layout.fillWidth: true; text: "Munich"
                           font.family: T.sans; font.pixelSize: 15; color: T.text }
                    Icon { name: "chevron"; size: 15 }
                }
                Item { Layout.fillHeight: true }
                RowLayout {
                    spacing: 10
                    Icon { name: "sun"; size: 34; Layout.alignment: Qt.AlignVCenter }
                    Text {
                        text: (root.vehicle && root.vehicle.canOnline) ? (root.vehicle.outsideC + "°C") : "24°C"
                        font.family: T.num; font.pixelSize: 38
                        font.weight: Font.DemiBold; color: T.text; Layout.alignment: Qt.AlignVCenter
                    }
                }
                Text { text: "Clear skies"; font.family: T.sans; font.pixelSize: 15; color: T.n800 }
            }
        }

        // ---- Prossima meta ----
        Rectangle {
            Layout.fillWidth: true; Layout.fillHeight: true
            radius: 14; color: T.glass; border.width: 1; border.color: T.glassBorder
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 16; spacing: 6
                RowLayout {
                    Layout.fillWidth: true; spacing: 9
                    Icon { name: "bag"; size: 17 }
                    Text { Layout.fillWidth: true; text: "Next destination"
                           font.family: T.sans; font.pixelSize: 15; color: T.n700 }
                    Icon { name: "chevron"; size: 15 }
                }
                Item { Layout.fillHeight: true }
                RowLayout {
                    spacing: 12
                    Icon { name: "nav"; size: 26; Layout.alignment: Qt.AlignVCenter }
                    ColumnLayout {
                        spacing: 1
                        Text { text: "BMW Welt"; font.family: T.sans; font.pixelSize: 20
                               font.weight: Font.DemiBold; color: T.text }
                        Text { text: "Am Olympiapark 1, München"; font.family: T.sans
                               font.pixelSize: 13; color: T.n600 }
                    }
                }
                Text { text: "28 min · 12 km"; font.family: T.sans; font.pixelSize: 14; color: T.n700 }
            }
        }

        // ---- Agenda ----
        Rectangle {
            Layout.fillWidth: true; Layout.fillHeight: true
            radius: 14; color: T.glass; border.width: 1; border.color: T.glassBorder
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 16; spacing: 6
                RowLayout {
                    Layout.fillWidth: true; spacing: 9
                    Icon { name: "calendar"; size: 17 }
                    Text { Layout.fillWidth: true; text: "Today"
                           font.family: T.sans; font.pixelSize: 15; color: T.n700 }
                    Icon { name: "chevron"; size: 15 }
                }
                Item { Layout.fillHeight: true }
                RowLayout {
                    spacing: 12
                    Rectangle { width: 4; height: 52; radius: 2; color: T.accent; Layout.alignment: Qt.AlignVCenter }
                    ColumnLayout {
                        spacing: 1
                        Text { text: "Team Sync"; font.family: T.sans; font.pixelSize: 20
                               font.weight: Font.DemiBold; color: T.text }
                        Text { text: "11:00 – 11:30"; font.family: T.sans; font.pixelSize: 14; color: T.n700 }
                        Text { text: "Microsoft Teams"; font.family: T.sans; font.pixelSize: 13; color: T.n600 }
                    }
                }
            }
        }

        // ---- Pannello brand (onde animate) ----
        Rectangle {
            Layout.fillWidth: true; Layout.fillHeight: true
            radius: 14; clip: true
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "#0e1420" }
                GradientStop { position: 1.0; color: "#0a1622" }
            }
            border.width: 1; border.color: T.glassBorder

            Canvas {
                id: waves
                anchors.fill: parent
                property real phase: 0
                onPaint: {
                    var ctx = getContext("2d"); ctx.reset();
                    for (var j = 0; j < 34; j++) {
                        ctx.beginPath();
                        ctx.strokeStyle = "rgba(41,198,255," + (0.10 + j * 0.004) + ")";
                        ctx.lineWidth = 0.8;
                        for (var x = 0; x < width; x += 4) {
                            var y = height * 0.55 + Math.sin(x / 90 + j * 0.05 + phase) * 42 + j * 2 - x * 0.10;
                            if (x === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
                        }
                        ctx.stroke();
                    }
                }
                NumberAnimation on phase {
                    from: 0; to: Math.PI * 2; duration: 9000; loops: Animation.Infinite; running: true
                }
                onPhaseChanged: requestPaint()
            }

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
                        font.family: T.sans; font.pixelSize: 14; font.weight: Font.Medium
                        font.letterSpacing: 3.5; color: T.n800
                    }
                }
                Rectangle { Layout.alignment: Qt.AlignRight; Layout.topMargin: 6
                            width: 54; height: 2; radius: 1; color: T.accent }
            }
        }
    }
}
