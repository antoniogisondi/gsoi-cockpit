import QtQuick

// Pannello sensori di parcheggio (PDC), stile Media Nav: auto vista dall'alto
// con archi posteriori che si accendono/colorano man mano che ci si avvicina
// a un ostacolo. Puramente deterministico: legge le distanze da ReverseData.
Item {
    id: root
    property var rd            // ReverseData
    property var zones: rd ? rd.zones : [999, 999, 999, 999]

    onZonesChanged: canvas.requestPaint()

    // Numero di archi accesi (0..3) per una distanza.
    function litArcs(cm) {
        if (rd === null) return 0;
        if (cm <= rd.dangerCm) return 3;
        if (cm <= rd.warnCm)   return 2;
        if (cm <= rd.maxRange) return 1;
        return 0;
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            var w = width, h = height;

            // Silhouette auto (vista dall'alto), muso in alto, coda in basso.
            var carW = w * 0.34, carH = h * 0.44;
            var carX = (w - carW) / 2, carY = h * 0.06;
            ctx.fillStyle = "rgba(255,255,255,0.90)";
            _roundRect(ctx, carX, carY, carW, carH, w * 0.05);
            ctx.fill();
            // Lunotto posteriore (per capire l'orientamento).
            ctx.fillStyle = "rgba(0,0,0,0.25)";
            _roundRect(ctx, carX + carW * 0.16, carY + carH * 0.62,
                       carW * 0.68, carH * 0.22, w * 0.02);
            ctx.fill();

            // 4 zone posteriori, da sinistra a destra.
            var rearY = carY + carH + h * 0.02;
            var zoneCx = [ carX + carW * 0.12, carX + carW * 0.38,
                           carX + carW * 0.62, carX + carW * 0.88 ];
            var arcGap = h * 0.10;
            var baseR = h * 0.02;

            for (var z = 0; z < 4; z++) {
                var cm = root.zones[z];
                var lit = root.litArcs(cm);
                var col = rd ? rd.zoneColor(cm) : "#37b24d";
                for (var a = 0; a < 3; a++) {
                    var r = baseR + arcGap * (a + 1);
                    ctx.beginPath();
                    ctx.arc(zoneCx[z], rearY, r, Math.PI * 0.15, Math.PI * 0.85, false);
                    ctx.lineWidth = h * 0.045;
                    ctx.lineCap = "round";
                    ctx.strokeStyle = (a < lit) ? col : "rgba(255,255,255,0.10)";
                    ctx.stroke();
                }
            }
        }
        function _roundRect(ctx, x, y, w, h, r) {
            ctx.beginPath();
            ctx.moveTo(x + r, y);
            ctx.arcTo(x + w, y, x + w, y + h, r);
            ctx.arcTo(x + w, y + h, x, y + h, r);
            ctx.arcTo(x, y + h, x, y, r);
            ctx.arcTo(x, y, x + w, y, r);
            ctx.closePath();
        }
        Component.onCompleted: requestPaint()
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }
}
