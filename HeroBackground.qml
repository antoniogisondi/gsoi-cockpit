import QtQuick
import "Theme.js" as T

// Sfondo atmosferico della Home (cielo notturno + bagliore d'alba + profili di
// montagna), fedele al mood dei mockup. Se si imposta `source` con una foto,
// quella sostituisce la scena disegnata. A sinistra una velatura scura rende
// leggibili i titoli.
Item {
    id: root
    property url source: ""
    clip: true

    // Foto reale opzionale (drop-in). Altrimenti scena disegnata.
    Image {
        anchors.fill: parent
        source: root.source
        visible: root.source != ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }

    Canvas {
        anchors.fill: parent
        visible: root.source == ""
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            var W = width, H = height;

            // Cielo
            var sky = ctx.createLinearGradient(0, 0, 0, H);
            sky.addColorStop(0.0, "#070c14");
            sky.addColorStop(0.55, "#0a1420");
            sky.addColorStop(1.0, "#0c1826");
            ctx.fillStyle = sky;
            ctx.fillRect(0, 0, W, H);

            // Bagliore d'alba (radiale, in basso a destra)
            var gx = W * 0.80, gy = H * 0.46;
            var glow = ctx.createRadialGradient(gx, gy, 0, gx, gy, H * 0.95);
            glow.addColorStop(0.0, "rgba(255,168,96,0.22)");
            glow.addColorStop(0.35, "rgba(210,120,80,0.10)");
            glow.addColorStop(1.0, "rgba(0,0,0,0)");
            ctx.fillStyle = glow;
            ctx.fillRect(0, 0, W, H);

            var horizon = H * 0.62;

            // Montagne lontane (più chiare)
            ctx.fillStyle = "#0e1a28";
            ctx.beginPath();
            ctx.moveTo(0, horizon);
            ctx.lineTo(W * 0.16, horizon - H * 0.18);
            ctx.lineTo(W * 0.30, horizon - H * 0.05);
            ctx.lineTo(W * 0.46, horizon - H * 0.22);
            ctx.lineTo(W * 0.62, horizon - H * 0.06);
            ctx.lineTo(W * 0.78, horizon - H * 0.20);
            ctx.lineTo(W, horizon - H * 0.10);
            ctx.lineTo(W, horizon);
            ctx.closePath();
            ctx.fill();

            // Montagne vicine (più scure)
            ctx.fillStyle = "#081019";
            ctx.beginPath();
            ctx.moveTo(0, horizon + H * 0.02);
            ctx.lineTo(W * 0.22, horizon - H * 0.10);
            ctx.lineTo(W * 0.40, horizon + H * 0.04);
            ctx.lineTo(W * 0.58, horizon - H * 0.12);
            ctx.lineTo(W * 0.80, horizon + H * 0.02);
            ctx.lineTo(W, horizon - H * 0.06);
            ctx.lineTo(W, H);
            ctx.lineTo(0, H);
            ctx.closePath();
            ctx.fill();

            // Foschia sull'orizzonte
            var haze = ctx.createLinearGradient(0, horizon - H * 0.12, 0, horizon + H * 0.06);
            haze.addColorStop(0.0, "rgba(120,150,190,0.0)");
            haze.addColorStop(1.0, "rgba(120,150,190,0.10)");
            ctx.fillStyle = haze;
            ctx.fillRect(0, horizon - H * 0.12, W, H * 0.18);
        }
    }

    // Velatura scura a sinistra: leggibilità dei titoli.
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#f2070b12" }
            GradientStop { position: 0.34; color: "#d9070b12" }
            GradientStop { position: 0.60; color: "#73070b12" }
            GradientStop { position: 1.0; color: "#00070b12" }
        }
    }
    // Velatura in basso (verso le card)
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00070b12" }
            GradientStop { position: 0.72; color: "#00070b12" }
            GradientStop { position: 1.0; color: "#cc070b12" }
        }
    }
}
