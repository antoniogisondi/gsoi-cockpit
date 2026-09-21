import QtQuick
import "Theme.js" as T

// Una singola spia del quadro (telltale), disegnata a vettori in un riquadro
// normalizzato 24x24. Colori standard automotive per tipo (verde/blu/ambra/
// rosso). Usata da TelltaleBar solo quando accesa.
Item {
    id: root
    property string kind: ""     // vedi lo switch in onPaint
    property real size: 34
    width: size
    height: size

    // Colore standard per tipo di spia.
    readonly property color _green: "#37b24d"
    readonly property color _blue:  "#1971c2"
    readonly property color _amber: "#e29500"
    readonly property color _red:   "#e5322d"
    readonly property color col: {
        switch (kind) {
        case "turnLeft": case "turnRight": return _green;
        case "highBeam": return _blue;
        case "glow": case "lowFuel": case "engine": case "abs": return _amber;
        default: return _red;  // coolant, battery, oil, brake, airbag, seatbelt
        }
    }

    onKindChanged: c.requestPaint()
    onColChanged: c.requestPaint()

    Canvas {
        id: c
        anchors.fill: parent
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            var u = root.size / 24;           // unità: coordinate in [0,24]
            ctx.scale(u, u);
            ctx.strokeStyle = root.col;
            ctx.fillStyle = root.col;
            ctx.lineWidth = 1.7;
            ctx.lineJoin = "round";
            ctx.lineCap = "round";

            function arrow(dir) {              // dir = +1 destra, -1 sinistra
                var x = 12 - dir * 2;
                ctx.beginPath();
                ctx.moveTo(x, 4);
                ctx.lineTo(x + dir * 8, 12);
                ctx.lineTo(x, 20);
                ctx.lineTo(x, 15);
                ctx.lineTo(x - dir * 6, 15);
                ctx.lineTo(x - dir * 6, 9);
                ctx.lineTo(x, 9);
                ctx.closePath();
                ctx.fill();
            }

            switch (root.kind) {
            case "turnLeft":  arrow(-1); break;
            case "turnRight": arrow(1); break;

            case "highBeam":
                // semicerchio (fanale) + raggi orizzontali
                ctx.beginPath();
                ctx.arc(15, 12, 6, Math.PI / 2, -Math.PI / 2, false);
                ctx.lineTo(15, 6);
                ctx.stroke();
                for (var i = 0; i < 5; i++) {
                    var y = 7 + i * 2.2;
                    ctx.beginPath();
                    ctx.moveTo(11, y);
                    ctx.lineTo(3, y);
                    ctx.stroke();
                }
                break;

            case "glow":
                // preriscaldo candelette (dCi): due spire tipo "omega"
                ctx.beginPath();
                ctx.moveTo(3, 15);
                ctx.arc(7, 12, 3, Math.PI * 0.75, Math.PI * 2.25, false);
                ctx.arc(14, 12, 3, Math.PI * 0.75, Math.PI * 2.25, false);
                ctx.lineTo(21, 15);
                ctx.stroke();
                break;

            case "lowFuel":
                // pompa carburante
                ctx.strokeRect(6, 5, 8, 15);
                ctx.beginPath(); ctx.moveTo(6, 20); ctx.lineTo(14, 20); ctx.stroke();
                ctx.fillRect(7, 7, 6, 4);            // finestrella livello
                // manichetta/ugello
                ctx.beginPath();
                ctx.moveTo(14, 9); ctx.lineTo(17, 9);
                ctx.lineTo(17, 15); ctx.lineTo(19, 15);
                ctx.moveTo(17, 9); ctx.lineTo(17, 7);
                ctx.stroke();
                break;

            case "coolant":
                // termometro immerso in onde
                ctx.beginPath();
                ctx.moveTo(12, 4); ctx.lineTo(12, 13); ctx.stroke();
                ctx.beginPath(); ctx.arc(12, 15, 2.4, 0, Math.PI * 2, false); ctx.fill();
                for (var w = 0; w < 2; w++) {
                    var yy = 18 + w * 2.6;
                    ctx.beginPath();
                    ctx.moveTo(4, yy);
                    ctx.bezierCurveTo(6, yy - 1.6, 8, yy + 1.6, 10, yy);
                    ctx.bezierCurveTo(12, yy - 1.6, 14, yy + 1.6, 20, yy);
                    ctx.stroke();
                }
                break;

            case "battery":
                ctx.strokeRect(4, 8, 16, 10);
                ctx.fillRect(7, 6, 3, 2);            // polo +
                ctx.fillRect(14, 6, 3, 2);           // polo -
                // segni + e -
                ctx.beginPath();
                ctx.moveTo(8.5, 11); ctx.lineTo(8.5, 15);
                ctx.moveTo(6.5, 13); ctx.lineTo(10.5, 13);
                ctx.moveTo(13.5, 13); ctx.lineTo(17.5, 13);
                ctx.stroke();
                break;

            case "oil":
                // oliatore con goccia
                ctx.beginPath();
                ctx.moveTo(4, 15); ctx.lineTo(13, 15);
                ctx.lineTo(13, 11); ctx.lineTo(4, 11); ctx.closePath();
                ctx.stroke();
                ctx.beginPath();
                ctx.moveTo(13, 12); ctx.lineTo(20, 9); ctx.stroke();   // beccuccio
                ctx.beginPath();
                ctx.moveTo(6, 11); ctx.lineTo(6, 8); ctx.lineTo(9, 8); ctx.stroke();
                // goccia
                ctx.beginPath();
                ctx.moveTo(17, 15);
                ctx.bezierCurveTo(19.5, 18, 19.5, 20, 17, 20);
                ctx.bezierCurveTo(14.5, 20, 14.5, 18, 17, 15);
                ctx.closePath(); ctx.fill();
                break;

            case "engine":
                // blocco motore stilizzato (avaria motore / MIL)
                ctx.beginPath();
                ctx.moveTo(4, 10); ctx.lineTo(6, 10); ctx.lineTo(6, 8);
                ctx.lineTo(10, 8); ctx.lineTo(10, 10); ctx.lineTo(13, 10);
                ctx.lineTo(14, 7); ctx.lineTo(17, 7); ctx.lineTo(17, 10);
                ctx.lineTo(19, 10); ctx.lineTo(19, 14); ctx.lineTo(17, 14);
                ctx.lineTo(17, 17); ctx.lineTo(8, 17); ctx.lineTo(8, 14);
                ctx.lineTo(4, 14); ctx.closePath();
                ctx.stroke();
                ctx.beginPath();               // "bulloni"
                ctx.moveTo(2.5, 11); ctx.lineTo(4, 11);
                ctx.moveTo(2.5, 13); ctx.lineTo(4, 13);
                ctx.stroke();
                break;

            case "brake":
                // cerchio con parentesi e "!" (freno)
                ctx.beginPath(); ctx.arc(12, 12, 6, 0, Math.PI * 2, false); ctx.stroke();
                ctx.beginPath();
                ctx.arc(12, 12, 9, -Math.PI * 0.35, Math.PI * 0.35, false); ctx.stroke();
                ctx.beginPath();
                ctx.arc(12, 12, 9, Math.PI * 0.65, Math.PI * 1.35, false); ctx.stroke();
                ctx.lineWidth = 2;
                ctx.beginPath(); ctx.moveTo(12, 8.5); ctx.lineTo(12, 13); ctx.stroke();
                ctx.beginPath(); ctx.arc(12, 15.4, 0.7, 0, Math.PI * 2, false); ctx.fill();
                break;

            case "abs":
                ctx.beginPath(); ctx.arc(12, 12, 8, 0, Math.PI * 2, false); ctx.stroke();
                ctx.setLineDash([2.2, 2.2]);
                ctx.beginPath(); ctx.arc(12, 12, 10.5, 0, Math.PI * 2, false); ctx.stroke();
                ctx.setLineDash([]);
                ctx.fillStyle = root.col;
                ctx.font = "700 8px '" + T.serif + "'";
                ctx.textAlign = "center"; ctx.textBaseline = "middle";
                ctx.fillText("ABS", 12, 12.5);
                break;

            case "airbag":
                // persona seduta + pallone (airbag)
                ctx.beginPath(); ctx.arc(8, 8, 2.4, 0, Math.PI * 2, false); ctx.stroke();
                ctx.beginPath();
                ctx.moveTo(8, 10.5); ctx.lineTo(8, 16); ctx.lineTo(12, 16); ctx.stroke();
                ctx.beginPath(); ctx.arc(16, 14, 3.4, 0, Math.PI * 2, false); ctx.stroke();
                ctx.beginPath(); ctx.moveTo(12, 16); ctx.lineTo(12.6, 16); ctx.stroke();
                break;

            case "seatbelt":
                // persona con cintura diagonale
                ctx.beginPath(); ctx.arc(12, 7, 2.6, 0, Math.PI * 2, false); ctx.stroke();
                ctx.beginPath();
                ctx.moveTo(9, 11); ctx.lineTo(9, 19); ctx.lineTo(15, 19);
                ctx.lineTo(15, 11); ctx.closePath(); ctx.stroke();
                ctx.beginPath(); ctx.moveTo(9, 11); ctx.lineTo(15, 19); ctx.stroke();
                break;
            }
        }
    }
}
