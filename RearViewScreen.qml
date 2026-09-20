import QtQuick
import "Theme.js" as T

// Schermata RETROCAMERA a tutto schermo (1280x720, poi scalata da Main).
// Appare appena si innesta la retromarcia e mostra video + sensori, come la
// Media Nav di serie. Indipendente dall'AI.
Item {
    id: root
    width: 1280
    height: 720

    property var reverseData     // ReverseData
    readonly property int nearest: reverseData ? reverseData.nearest : 999
    readonly property color nearColor: reverseData ? reverseData.zoneColor(nearest) : "#37b24d"

    Rectangle { anchors.fill: parent; color: "#000000" }

    // --- Video retrocamera + linee guida (fondo, tutto schermo) -------------
    CameraView { anchors.fill: parent }

    // --- Badge retromarcia (in alto a sinistra) -----------------------------
    Row {
        x: 28; y: 24
        spacing: 14
        Rectangle {
            width: 46; height: 46; radius: 23
            color: "#e5322d"
            Text {
                anchors.centerIn: parent
                text: "R"; color: "white"
                font.pixelSize: 26; font.bold: true
            }
        }
        Column {
            spacing: 0
            Text {
                text: "RETROMARCIA"; color: "white"
                font.family: T.serif; font.pixelSize: 22; font.letterSpacing: 2
            }
            Text {
                text: "Telecamera posteriore"; color: "#c9c9c9"
                font.pixelSize: 14
            }
        }
    }

    // --- Indicatore "live" (in alto a destra) -------------------------------
    Row {
        anchors.right: parent.right; anchors.rightMargin: 28
        y: 30; spacing: 8
        Rectangle {
            width: 12; height: 12; radius: 6; anchors.verticalCenter: parent.verticalCenter
            color: "#e5322d"
            SequentialAnimation on opacity {
                running: true; loops: Animation.Infinite
                NumberAnimation { to: 0.25; duration: 700 }
                NumberAnimation { to: 1.0; duration: 700 }
            }
        }
        Text { text: "LIVE"; color: "white"; font.pixelSize: 15; font.letterSpacing: 2 }
    }

    // --- Pannello sensori di parcheggio (a destra, sovrapposto) -------------
    Rectangle {
        id: pdcPanel
        width: 320; height: 470
        anchors.right: parent.right; anchors.rightMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        radius: 18
        color: "#000000"; opacity: 0.55
    }
    Column {
        width: pdcPanel.width
        anchors.horizontalCenter: pdcPanel.horizontalCenter
        anchors.verticalCenter: pdcPanel.verticalCenter
        spacing: 6

        ParkingSensors {
            width: pdcPanel.width; height: 300
            anchors.horizontalCenter: parent.horizontalCenter
            rd: root.reverseData
        }

        // Distanza più vicina, grande e colorata.
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            Rectangle {
                width: 16; height: 16; radius: 8
                anchors.verticalCenter: parent.verticalCenter
                color: root.nearColor
                // Beep visivo: pulsa più in fretta se vicino (rosso).
                SequentialAnimation on opacity {
                    running: root.nearest <= (root.reverseData ? root.reverseData.warnCm : 100)
                    loops: Animation.Infinite
                    NumberAnimation {
                        to: 0.15
                        duration: root.nearest <= (root.reverseData ? root.reverseData.dangerCm : 40) ? 140 : 420
                    }
                    NumberAnimation {
                        to: 1.0
                        duration: root.nearest <= (root.reverseData ? root.reverseData.dangerCm : 40) ? 140 : 420
                    }
                }
            }
            Text {
                text: (root.reverseData && root.nearest < root.reverseData.maxRange)
                      ? (root.nearest + " cm") : "—"
                color: "white"; font.pixelSize: 40; font.bold: true
            }
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "distanza ostacolo più vicino"
            color: "#c9c9c9"; font.pixelSize: 13
        }
    }

    // Nota: il beep sonoro reale (SoundEffect/QtMultimedia + altoparlanti)
    // si aggiunge quando l'audio è cablato; qui è rappresentato visivamente.
}
