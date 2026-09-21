import QtQuick
import QtQuick.Window
import "ClusterTheme.js" as C

// QUADRO STRUMENTI DIGITALE GSOI — app a sé, sul 2° schermo (dietro al volante).
// Stile ispirato ai cockpit digitali premium: fondo scuro, due "ali" laterali
// (contagiri a sinistra, velocità a destra), velocità digitale al centro.
// INDIPENDENTE dall'AI: legge i dati da gsoi-vehicled (CAN in sola lettura) via
// ClusterData. Disegnato a 1280x480 e scalato uniformemente a qualunque pannello.
Window {
    id: win
    visible: true
    visibility: Window.FullScreen
    width: 1280
    height: 480
    color: C.bg
    title: "GSOI Cluster"

    ClusterData { id: cd }

    // Valori "morbidi": animano tra un aggiornamento e l'altro → lancette fluide.
    property real dispSpeed: cd.speedKmh
    property real dispRpm: cd.rpm
    Behavior on dispSpeed { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
    Behavior on dispRpm   { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

    // Orologio.
    property string clock: "--:--"
    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            var d = new Date();
            win.clock = ("0" + d.getHours()).slice(-2) + ":" + ("0" + d.getMinutes()).slice(-2);
        }
    }

    // Sfondo (alone in alto → profondità), riempie tutta la finestra.
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: C.stage2 }
            GradientStop { position: 0.55; color: C.stage }
            GradientStop { position: 1.0; color: C.bg }
        }
    }

    Item {
        id: canvas
        width: 1280
        height: 480
        anchors.centerIn: parent
        scale: Math.min(win.width / width, win.height / height)
        transformOrigin: Item.Center

        // --- Ali: contagiri (sinistra) e velocità (destra) -----------------
        Wing {
            anchors.fill: parent
            side: "left"
            value: win.dispRpm / 1000.0
            from: 0; to: 6; majors: 6; minorPerMajor: 3
            redline: 4.6                       // dCi: zona rossa ~4600 giri
        }
        Wing {
            anchors.fill: parent
            side: "right"
            value: win.dispSpeed
            from: 0; to: 200; majors: 5; minorPerMajor: 3
        }

        // etichette lato interno.
        Text {
            x: 78; y: 402; text: "giri ×1000"
            font.family: C.label; font.pixelSize: 15
            color: C.dim; font.letterSpacing: 2
        }
        Text {
            x: 1202 - width; y: 402; text: "km/h"
            font.family: C.label; font.pixelSize: 15
            color: C.dim; font.letterSpacing: 2
        }

        // --- Barra spie (in alto, centrata) --------------------------------
        TelltaleBar {
            cd: cd
            cell: 26
            anchors.horizontalCenter: parent.horizontalCenter
            y: 24
        }

        // --- Frecce direzione (angoli) -------------------------------------
        TurnSignal { x: 40;   y: 18; size: 36; dir: "turnLeft";  active: cd.turnLeft }
        TurnSignal { x: 1204; y: 18; size: 36; dir: "turnRight"; active: cd.turnRight }

        // --- Velocità digitale al centro -----------------------------------
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 92
            spacing: 2
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Math.round(win.dispSpeed).toString()
                font.family: C.display; font.pixelSize: 150; font.weight: Font.DemiBold
                color: C.ink
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "km/h"
                font.family: C.label; font.pixelSize: 20; font.letterSpacing: 6
                color: C.muted
            }
            Text {
                visible: cd.gear !== ""
                anchors.horizontalCenter: parent.horizontalCenter
                topPadding: 8
                text: cd.gear
                font.family: C.display; font.pixelSize: 30; font.weight: Font.DemiBold
                color: C.teal
            }
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 322
            text: cd.rpm + " giri/min"
            font.family: C.display; font.pixelSize: 22
            color: C.muted
        }

        // --- Barre carburante (sx) e temperatura motore (dx) ---------------
        MiniBar {
            x: 66; y: 250; width: 18; height: 138
            frac: cd.fuelPct / 100.0
            fillColor: cd.tLowFuel ? C.amber : C.teal
            iconKind: "lowFuel"
            iconColor: cd.tLowFuel ? C.amber : C.muted
        }
        MiniBar {
            x: 1196; y: 250; width: 18; height: 138
            frac: Math.max(0, Math.min(1, (cd.coolantC - 40) / (120 - 40)))
            fillColor: cd.tCoolant ? C.red : (cd.coolantC < 55 ? C.blue : C.teal)
            iconKind: "coolant"
            iconColor: cd.tCoolant ? C.red : C.muted
        }

        // --- Riga inferiore: contakm, tragitto, esterna, ora ---------------
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 430
            spacing: 66
            Repeater {
                model: [
                    { k: "TOTALE",   v: cd.odometerKm.toLocaleString(Qt.locale("it_IT"), "f", 0) + " km" },
                    { k: "TRAGITTO", v: cd.tripKm.toFixed(1) + " km" },
                    { k: "ESTERNA",  v: cd.outsideC + " °C" },
                    { k: "ORA",      v: win.clock }
                ]
                delegate: Column {
                    required property var modelData
                    spacing: 1
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.k
                        font.family: C.label; font.pixelSize: 12; font.letterSpacing: 2
                        color: C.dim
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.v
                        font.family: C.display; font.pixelSize: 21
                        color: C.ink
                    }
                }
            }
        }

        // --- Marchio + stato sorgente dati ---------------------------------
        Text {
            x: 24; y: 440; text: "GSOI"
            font.family: C.display; font.pixelSize: 20; font.weight: Font.DemiBold
            font.letterSpacing: 3; color: C.muted
        }
        Row {
            x: 1256 - width; y: 444; spacing: 7
            Rectangle {
                width: 8; height: 8; radius: 4
                anchors.verticalCenter: parent.verticalCenter
                color: cd.online ? C.green : C.red
            }
            Text {
                text: cd.online ? "CAN" : "no CAN"
                font.family: C.label; font.pixelSize: 13; font.letterSpacing: 1
                color: C.muted
            }
        }
    }

    Shortcut { sequence: "Esc"; onActivated: Qt.quit() }
}
