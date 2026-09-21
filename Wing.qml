import QtQuick
import "ClusterTheme.js" as C

// "Ala": strumento curvo che abbraccia un bordo (sinistro o destro) del quadro,
// stile cockpit digitale premium. Traccia + riempimento luminoso + tacche
// numerate + punta scorrevole. Disegnato con Canvas, occupa l'intera area (il
// centro dell'arco è fuori schermo, così si vede solo la grande curva laterale).
Canvas {
    id: root
    antialiasing: true

    property string side: "left"       // "left" | "right"
    property real value: 0
    property real from: 0
    property real to: 100
    property real redline: -1          // valore d'inizio zona rossa; -1 = nessuna
    property int  majors: 6            // tacche numerate
    property int  minorPerMajor: 3

    onValueChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    function _f(v) {
        if (to === from) return 0;
        var x = (v - from) / (to - from);
        return x < 0 ? 0 : (x > 1 ? 1 : x);
    }

    onPaint: {
        var ctx = getContext("2d");
        ctx.reset();
        var W = width, H = height;
        var left = (side === "left");
        var cx = left ? -0.12 * W : 1.12 * W;
        var cy = 0.52 * H;
        var r = 0.70 * H;
        var lw = 0.055 * H;
        var spread = 62 * Math.PI / 180;
        var a0, a1, anti;
        if (left) { a0 = spread; a1 = -spread; anti = true; }        // basso -> alto
        else      { a0 = Math.PI - spread; a1 = Math.PI + spread; anti = false; }
        var frac = _f(value);
        var av = a0 + (a1 - a0) * frac;
        var redFrac = (redline >= from && redline < to) ? _f(redline) : -1;

        ctx.lineCap = "round";

        // --- Traccia -------------------------------------------------------
        ctx.lineWidth = lw;
        ctx.strokeStyle = C.track;
        ctx.beginPath(); ctx.arc(cx, cy, r, a0, a1, anti); ctx.stroke();

        // --- Zona rossa ----------------------------------------------------
        if (redFrac >= 0) {
            var ar = a0 + (a1 - a0) * redFrac;
            ctx.globalAlpha = 0.5;
            ctx.strokeStyle = C.red;
            ctx.beginPath(); ctx.arc(cx, cy, r, ar, a1, anti); ctx.stroke();
            ctx.globalAlpha = 1;
        }

        // --- Riempimento con alone -----------------------------------------
        var over = (redFrac >= 0 && frac >= redFrac);
        var col = over ? C.red : C.teal;
        ctx.save();
        ctx.strokeStyle = col;
        ctx.shadowColor = col;
        ctx.shadowBlur = 18;
        ctx.beginPath(); ctx.arc(cx, cy, r, a0, av, anti); ctx.stroke();
        ctx.restore();

        // --- Punta luminosa ------------------------------------------------
        ctx.save();
        ctx.shadowColor = col; ctx.shadowBlur = 16;
        ctx.fillStyle = "#ffffff";
        ctx.beginPath();
        ctx.arc(cx + Math.cos(av) * r, cy + Math.sin(av) * r, lw * 0.42, 0, Math.PI * 2);
        ctx.fill();
        ctx.restore();

        // --- Tacche + numeri ----------------------------------------------
        ctx.textAlign = "center";
        ctx.textBaseline = "middle";
        ctx.font = "600 " + (0.05 * H) + "px '" + C.display + "'";
        for (var i = 0; i <= majors; i++) {
            var f = i / majors;
            var a = a0 + (a1 - a0) * f;
            var cos = Math.cos(a), sin = Math.sin(a);
            var red = (redFrac >= 0 && f >= redFrac - 1e-6);
            ctx.strokeStyle = red ? C.red : "#5a6675";
            ctx.lineWidth = 0.015 * H;
            ctx.beginPath();
            ctx.moveTo(cx + cos * (r - lw * 0.7), cy + sin * (r - lw * 0.7));
            ctx.lineTo(cx + cos * (r + lw * 0.6), cy + sin * (r + lw * 0.6));
            ctx.stroke();
            // numero (lato interno)
            var val = Math.round(from + f * (to - from));
            ctx.fillStyle = red ? C.red : "#77828f";
            var tr = r - lw * 1.8;
            ctx.fillText(val.toString(), cx + cos * tr, cy + sin * tr);
            // tacche minori
            if (i < majors) {
                for (var m = 1; m <= minorPerMajor; m++) {
                    var fm = (i + m / (minorPerMajor + 1)) / majors;
                    var am = a0 + (a1 - a0) * fm;
                    var mc = Math.cos(am), ms = Math.sin(am);
                    ctx.strokeStyle = "#39434f";
                    ctx.lineWidth = 0.007 * H;
                    ctx.beginPath();
                    ctx.moveTo(cx + mc * (r - lw * 0.35), cy + ms * (r - lw * 0.35));
                    ctx.lineTo(cx + mc * (r + lw * 0.3), cy + ms * (r + lw * 0.3));
                    ctx.stroke();
                }
            }
        }
    }
}
