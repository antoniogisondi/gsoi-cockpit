import QtQuick

// Area video della retrocamera con linee guida di parcheggio sovrapposte.
//
// MOCK-FIRST: qui il "video" è un segnaposto (scena prospettica disegnata) così
// la funzione è testabile in QEMU senza hardware. In auto, al posto del
// segnaposto va il flusso reale della telecamera (dongle USB di acquisizione,
// device V4L2). Per collegarlo:
//   1) aggiungi Qt6 Multimedia all'immagine (qtmultimedia) e a CMakeLists;
//   2) importa QtMultimedia e sostituisci il segnaposto con, ad es.:
//        MediaPlayer { id: mp; source: "gst-pipeline: v4l2src device=/dev/video0 ! ..."; videoOutput: vout }
//        VideoOutput { id: vout; anchors.fill: parent; fillMode: VideoOutput.PreserveAspectCrop }
//   Le linee guida qui sotto restano identiche, sovrapposte al video.
Item {
    id: root

    // Colori funzionali PDC (indipendenti dal tema editoriale).
    readonly property color cNear: "#e5322d"   // rosso
    readonly property color cMid:  "#edbb00"    // giallo
    readonly property color cFar:  "#37b24d"    // verde

    // --- Segnaposto "video": asfalto + griglia prospettica ------------------
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#20262b" }
            GradientStop { position: 0.55; color: "#12161a" }
            GradientStop { position: 1.0; color: "#080a0c" }
        }
    }

    Canvas {
        id: scene
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            var w = width, h = height;

            // Linee prospettiche del "terreno" (danno l'idea del video camera).
            ctx.strokeStyle = "rgba(255,255,255,0.06)";
            ctx.lineWidth = Math.max(1, h * 0.002);
            var vpX = w * 0.5, vpY = h * 0.42;      // punto di fuga
            for (var i = -6; i <= 6; i++) {
                ctx.beginPath();
                ctx.moveTo(w * 0.5 + i * (w * 0.13), h);
                ctx.lineTo(vpX, vpY);
                ctx.stroke();
            }
            for (var t = 0.5; t <= 1.0; t += 0.12) {
                var y = vpY + (h - vpY) * t;
                ctx.beginPath();
                ctx.moveTo(0, y);
                ctx.lineTo(w, y);
                ctx.stroke();
            }
        }
        Component.onCompleted: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }

    // Slot per il VIDEO REALE (vuoto in mock). Sull'hardware si imposta
    // cameraLoader.sourceComponent a un VideoOutput legato alla telecamera.
    Loader { id: cameraLoader; anchors.fill: parent }

    // --- Linee guida di parcheggio (dinamiche stile OEM) --------------------
    Canvas {
        id: guides
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            var w = width, h = height;
            var yb = h * 0.98, yt = h * 0.46;               // base (vicino) .. top (lontano)
            var xblL = w * 0.30, xblR = w * 0.70;           // larghezza in basso
            var xtlL = w * 0.42, xtlR = w * 0.58;           // larghezza in alto
            function lerp(a, b, t) { return a + (b - a) * t; }
            function lx(t) { return lerp(xblL, xtlL, t); }
            function rx(t) { return lerp(xblR, xtlR, t); }
            function yy(t) { return lerp(yb, yt, t); }

            ctx.lineWidth = Math.max(2, h * 0.007);
            ctx.lineCap = "round";

            // Linee laterali del percorso.
            ctx.strokeStyle = "rgba(255,255,255,0.85)";
            ctx.beginPath(); ctx.moveTo(lx(0), yy(0)); ctx.lineTo(lx(1), yy(1)); ctx.stroke();
            ctx.beginPath(); ctx.moveTo(rx(0), yy(0)); ctx.lineTo(rx(1), yy(1)); ctx.stroke();

            // Bande di distanza: rosso (vicino), giallo (medio), verde (lontano).
            var bands = [ { t: 0.12, c: root.cNear }, { t: 0.5, c: root.cMid }, { t: 0.85, c: root.cFar } ];
            for (var i = 0; i < bands.length; i++) {
                var t = bands[i].t;
                ctx.strokeStyle = bands[i].c;
                ctx.beginPath();
                ctx.moveTo(lx(t), yy(t));
                ctx.lineTo(rx(t), yy(t));
                ctx.stroke();
            }
        }
        Component.onCompleted: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }
}
