import QtQuick

// Stato della retromarcia + sensori di parcheggio (PDC).
//
// INDIPENDENTE dall'AI. La sorgente reale è il servizio `gsoi-reverse`
// (systemd) che legge il filo luce-retromarcia (GPIO) e i sensori (CAN/kit) ed
// espone lo stato in JSON su http://127.0.0.1:8092/reverse. Il cockpit lo
// legge come `VehicleData` fa con Jarvis Mini — ma è tutt'altro processo,
// niente AI.
//
// Fallback per lo sviluppo/test: se il servizio non risponde (o anche mentre
// c'è, per un test rapido in QEMU) il tasto **R** simula la retromarcia con un
// ostacolo che si avvicina.
Item {
    id: root
    visible: false

    property string endpoint: "http://127.0.0.1:8092/reverse"
    property int pollMs: 150

    readonly property int maxRange: 150
    readonly property int warnCm: 100    // sotto = giallo
    readonly property int dangerCm: 40   // sotto = rosso (allarme)

    // --- Sorgenti -----------------------------------------------------------
    property bool httpReverse: false     // dal servizio gsoi-reverse (GPIO reale)
    property var httpZones: []
    property bool keyReverse: false      // mock da tastiera (impostato da Main, tasto R)
    property var mockZones: [maxRange, maxRange, maxRange, maxRange]

    // Stato effettivo: retromarcia se la segnala il GPIO (via servizio) OPPURE
    // il tasto R (test). Così in auto comanda il GPIO, in QEMU comanda R.
    readonly property bool reverse: httpReverse || keyReverse
    readonly property var zones: (httpReverse && httpZones.length === 4)
                                 ? httpZones
                                 : (keyReverse ? mockZones
                                               : [maxRange, maxRange, maxRange, maxRange])
    readonly property int nearest: Math.min(zones[0], zones[1], zones[2], zones[3])

    // Colore/riempimento di una zona in base alla distanza.
    function zoneColor(cm) {
        if (cm <= dangerCm) return "#e5322d";
        if (cm <= warnCm)   return "#edbb00";
        return "#37b24d";
    }
    function zoneFill(cm) {
        var f = 1.0 - (cm / maxRange);
        return f < 0 ? 0 : (f > 1 ? 1 : f);
    }

    // --- MOCK (tasto R): un ostacolo che si avvicina ------------------------
    property int _t: 0
    Timer {
        interval: 120
        running: root.keyReverse && !root.httpReverse
        repeat: true
        onTriggered: {
            root._t += 1;
            var d = root.maxRange - (root._t % (root.maxRange + 10));
            if (d < 15) d = 15;
            root.mockZones = [ Math.min(root.maxRange, d + 55),
                               Math.min(root.maxRange, d + 12),
                               d,
                               Math.min(root.maxRange, d + 40) ];
        }
    }
    onKeyReverseChanged: {
        if (!keyReverse) { _t = 0; mockZones = [maxRange, maxRange, maxRange, maxRange]; }
    }

    // --- Poll del servizio gsoi-reverse -------------------------------------
    function _refresh() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;
            if (xhr.status === 200) {
                try {
                    var d = JSON.parse(xhr.responseText);
                    root.httpReverse = (d.reverse === true);
                    root.httpZones = Array.isArray(d.zones) ? d.zones : [];
                } catch (e) {
                    root.httpReverse = false; root.httpZones = [];
                }
            } else {
                root.httpReverse = false; root.httpZones = [];
            }
        };
        try {
            xhr.open("GET", root.endpoint);
            xhr.send();
        } catch (e) {
            root.httpReverse = false; root.httpZones = [];
        }
    }
    Timer {
        interval: root.pollMs
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root._refresh()
    }
}
