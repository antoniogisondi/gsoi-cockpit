import QtQuick
import QtQuick.Window
import "Theme.js" as T

// QUADRO STRUMENTI DIGITALE GSOI — app a sé, sul 2° schermo (dietro al volante).
// INDIPENDENTE dall'AI: legge i dati dal servizio gsoi-vehicled (CAN in sola
// lettura) via ClusterData. Disegnato a 1280x720 e scalato a qualunque pannello.
Window {
    id: win
    visible: true
    visibility: Window.FullScreen
    width: 1280
    height: 720
    color: T.bg
    title: "GSOI Cluster"

    ClusterData { id: cd }

    // Orologio.
    property string clock: "--:--"
    function _tick() {
        var d = new Date();
        var hh = ("0" + d.getHours()).slice(-2);
        var mm = ("0" + d.getMinutes()).slice(-2);
        win.clock = hh + ":" + mm;
    }
    Timer { interval: 1000; running: true; repeat: true; triggeredOnStart: true; onTriggered: win._tick() }

    Item {
        id: canvas
        width: 1280
        height: 720
        anchors.centerIn: parent
        scale: Math.min(win.width / width, win.height / height)
        transformOrigin: Item.Center

        // --- Frecce direzione (angoli alti) --------------------------------
        TurnSignal { x: 150; y: 26; size: 56; dir: "turnLeft";  active: cd.turnLeft }
        TurnSignal { x: 1074; y: 26; size: 56; dir: "turnRight"; active: cd.turnRight }

        // --- Barra spie (in alto, centrata) --------------------------------
        TelltaleBar {
            id: bar
            cd: cd
            cell: 36
            anchors.horizontalCenter: parent.horizontalCenter
            y: 34
        }

        // --- Contagiri (sinistra) ------------------------------------------
        Gauge {
            x: 132; y: 190
            size: 300
            value: cd.rpm / 1000.0
            from: 0; to: 6; majorStep: 1; minorPerMajor: 4
            redline: 4.6                     // dCi: zona rossa ~4600 giri
            unit: "giri/min"                 // scala ad anello 0–6 = ×1000
            bigText: cd.rpm.toString()
            arcColor: T.accent
        }

        // --- Tachimetro (centro, il più grande) ----------------------------
        Gauge {
            id: speedo
            x: 440; y: 150
            size: 400
            value: cd.speedKmh
            from: 0; to: 220; majorStep: 20; minorPerMajor: 1
            unit: "km/h"
            arcColor: T.accent
        }
        // Marcia (se disponibile dal cambio) sotto al tachimetro.
        Text {
            visible: cd.gear !== ""
            text: cd.gear
            anchors.horizontalCenter: speedo.horizontalCenter
            y: speedo.y + 300
            font.family: T.serif; font.pixelSize: 40; font.weight: Font.DemiBold
            color: T.accent700
        }

        // --- Carburante + temperatura motore (destra) ----------------------
        Gauge {
            x: 900; y: 168
            size: 185
            value: cd.fuelPct
            from: 0; to: 100; majorStep: 50; minorPerMajor: 4
            unit: ""; caption: "carburante"
            bigText: cd.fuelPct + "%"
            arcColor: cd.tLowFuel ? "#e29500" : T.accent
        }
        Gauge {
            x: 900; y: 372
            size: 185
            value: cd.coolantC
            from: 40; to: 130; majorStep: 30; minorPerMajor: 2
            redline: 115
            unit: ""; caption: "motore"
            bigText: cd.coolantC + "°"
            arcColor: T.accent
        }

        // --- Riga inferiore: contachilometri, tragitto, esterna, ora -------
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 648
            spacing: 54

            Column {
                Text { text: "TOTALE"; font.family: T.serif; font.pixelSize: 13; color: T.n600 }
                Text { text: cd.odometerKm.toLocaleString(Qt.locale("it_IT"), "f", 0) + " km"
                       font.family: T.serif; font.pixelSize: 22; color: T.text }
            }
            Column {
                Text { text: "TRAGITTO"; font.family: T.serif; font.pixelSize: 13; color: T.n600 }
                Text { text: cd.tripKm.toFixed(1) + " km"
                       font.family: T.serif; font.pixelSize: 22; color: T.text }
            }
            Column {
                Text { text: "ESTERNA"; font.family: T.serif; font.pixelSize: 13; color: T.n600 }
                Text { text: cd.outsideC + " °C"
                       font.family: T.serif; font.pixelSize: 22; color: T.text }
            }
            Column {
                Text { text: "ORA"; font.family: T.serif; font.pixelSize: 13; color: T.n600 }
                Text { text: win.clock
                       font.family: T.serif; font.pixelSize: 22; color: T.text }
            }
        }

        // --- Marchio + stato sorgente dati ---------------------------------
        Text {
            x: 24; y: 678
            text: "GSOI"
            font.family: T.serif; font.pixelSize: 20; font.weight: Font.DemiBold
            color: T.n600
        }
        Row {
            x: 1140; y: 682; spacing: 8
            Rectangle {
                width: 9; height: 9; radius: 4.5
                anchors.verticalCenter: parent.verticalCenter
                color: cd.online ? "#37b24d" : "#e5322d"
            }
            Text {
                text: cd.online ? "CAN" : "no CAN"
                font.family: T.serif; font.pixelSize: 14; color: T.n600
            }
        }
    }

    Shortcut { sequence: "Esc"; onActivated: Qt.quit() }
}
