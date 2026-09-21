import QtQuick
import "Theme.js" as T

// Strumento ad arco (tachimetro / contagiri) con lancetta, arco di
// riempimento, tacche numerate e numero digitale al centro. Disegnato con
// Canvas e scalabile (dimensione = `size`).
Item {
    id: root
    property real size: 360
    width: size
    height: size

    property real value: 0             // valore corrente (clampato in [from,to])
    property real from: 0
    property real to: 240
    property real redline: -1          // inizio zona rossa; -1 = nessuna
    property real majorStep: 20        // passo delle tacche numerate
    property int  minorPerMajor: 2     // tacche minori tra due maggiori
    property string unit: "km/h"
    property string caption: ""
    property string bigText: ""        // se valorizzato sostituisce il numero auto

    // Geometria dell'arco: parte in basso a sinistra e spazza in senso orario.
    property real startDeg: 135
    property real sweepDeg: 270

    property color arcColor: T.accent
    property color dangerColor: "#e5322d"

    onValueChanged: face.requestPaint()
    onRedlineChanged: face.requestPaint()

    function _clamp(v) { return v < from ? from : (v > to ? to : v); }
    function _frac(v) { return (to === from) ? 0 : (_clamp(v) - from) / (to - from); }

    Canvas {
        id: face
        anchors.fill: parent
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            var s = root.size;
            var cx = s / 2, cy = s / 2;
            var r = s / 2 - s * 0.06;
            var lw = s * 0.055;
            var d2r = Math.PI / 180;
            var a0 = root.startDeg * d2r;
            var a1 = (root.startDeg + root.sweepDeg) * d2r;

            // --- Traccia di fondo -------------------------------------------
            ctx.lineWidth = lw;
            ctx.lineCap = "round";
            ctx.strokeStyle = T.n300;
            ctx.beginPath();
            ctx.arc(cx, cy, r, a0, a1, false);
            ctx.stroke();

            // --- Zona rossa (redline) ---------------------------------------
            if (root.redline >= root.from && root.redline < root.to) {
                var ar = (root.startDeg + root.sweepDeg * root._frac(root.redline)) * d2r;
                ctx.strokeStyle = root.dangerColor;
                ctx.beginPath();
                ctx.arc(cx, cy, r, ar, a1, false);
                ctx.stroke();
            }

            // --- Riempimento fino al valore ---------------------------------
            var f = root._frac(root.value);
            var av = (root.startDeg + root.sweepDeg * f) * d2r;
            var overRed = (root.redline >= 0 && root.value >= root.redline);
            ctx.strokeStyle = overRed ? root.dangerColor : root.arcColor;
            ctx.beginPath();
            ctx.arc(cx, cy, r, a0, av, false);
            ctx.stroke();

            // --- Tacche + numeri --------------------------------------------
            var steps = Math.round((root.to - root.from) / root.majorStep);
            ctx.fillStyle = T.n700;
            ctx.font = "600 " + (s * 0.052) + "px '" + T.serif + "'";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            for (var i = 0; i <= steps; i++) {
                var vv = root.from + i * root.majorStep;
                var frac = root._frac(vv);
                var ang = (root.startDeg + root.sweepDeg * frac) * d2r;
                var cos = Math.cos(ang), sin = Math.sin(ang);
                var inR = r - lw * 0.7, outR = r + lw * 0.65;
                var red = (root.redline >= 0 && vv >= root.redline);
                ctx.strokeStyle = red ? root.dangerColor : T.n600;
                ctx.lineWidth = s * 0.012;
                ctx.beginPath();
                ctx.moveTo(cx + cos * inR, cy + sin * inR);
                ctx.lineTo(cx + cos * outR, cy + sin * outR);
                ctx.stroke();
                // numero
                var tR = r - lw * 1.9;
                ctx.fillStyle = red ? root.dangerColor : T.n700;
                ctx.fillText(vv.toString(), cx + cos * tR, cy + sin * tR);
                // tacche minori
                if (i < steps) {
                    for (var m = 1; m <= root.minorPerMajor; m++) {
                        var fv = root.from + (i + m / (root.minorPerMajor + 1)) * root.majorStep;
                        var fa = (root.startDeg + root.sweepDeg * root._frac(fv)) * d2r;
                        var fc = Math.cos(fa), fsi = Math.sin(fa);
                        ctx.strokeStyle = T.n400;
                        ctx.lineWidth = s * 0.006;
                        ctx.beginPath();
                        ctx.moveTo(cx + fc * (r - lw * 0.4), cy + fsi * (r - lw * 0.4));
                        ctx.lineTo(cx + fc * (r + lw * 0.35), cy + fsi * (r + lw * 0.35));
                        ctx.stroke();
                    }
                }
            }

            // --- Lancetta ----------------------------------------------------
            var needR = r - lw * 0.4;
            var nc = Math.cos(av), ns = Math.sin(av);
            ctx.strokeStyle = overRed ? root.dangerColor : T.text;
            ctx.lineWidth = s * 0.02;
            ctx.lineCap = "round";
            ctx.beginPath();
            ctx.moveTo(cx - nc * (s * 0.06), cy - ns * (s * 0.06));
            ctx.lineTo(cx + nc * needR, cy + ns * needR);
            ctx.stroke();
            // mozzo
            ctx.fillStyle = T.text;
            ctx.beginPath();
            ctx.arc(cx, cy, s * 0.028, 0, Math.PI * 2, false);
            ctx.fill();
        }
    }

    // --- Numero digitale + unità al centro (font nitido, non Canvas) --------
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.size * 0.44
        spacing: 0
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.bigText !== "" ? root.bigText
                                      : Math.round(root._clamp(root.value)).toString()
            font.family: T.serif
            font.pixelSize: root.size * 0.20
            font.weight: Font.DemiBold
            color: (root.redline >= 0 && root.value >= root.redline) ? root.dangerColor : T.text
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.unit
            font.family: T.serif
            font.pixelSize: root.size * 0.06
            color: T.n700
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.caption !== ""
            text: root.caption
            font.family: T.serif
            font.pixelSize: root.size * 0.05
            color: T.n600
        }
    }
}
