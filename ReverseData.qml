import QtQuick

// Stato della retromarcia + sensori di parcheggio (PDC).
//
// INDIPENDENTE dall'AI: niente Jarvis Mini, niente LLM, niente /state. È una
// funzione di sicurezza deterministica. In auto:
//   * `reverse` arriva dal filo luce-retromarcia (+12V) portato a un GPIO del
//     Raspberry tramite optoisolatore;
//   * `zones` sono le distanze dei sensori PDC (dal CAN in sola lettura, o da
//     un kit sensori dedicato).
// Qui, mock-first, sono simulati per sviluppo e test in QEMU. Sull'hardware si
// aggancia una sorgente reale dedicata (es. servizio gsoi-reverse locale o
// file /run/gsoi/reverse), sempre fuori dallo stack AI.
Item {
    id: root
    visible: false

    // Retromarcia innestata: mostra retrocamera + sensori a tutto schermo.
    property bool reverse: false

    // Distanze (cm) delle 4 zone posteriori: sinistra, centro-sx, centro-dx,
    // destra. maxRange = nessun ostacolo entro portata.
    readonly property int maxRange: 150
    readonly property int warnCm: 100    // sotto = giallo
    readonly property int dangerCm: 40   // sotto = rosso (allarme)
    property var zones: [maxRange, maxRange, maxRange, maxRange]

    // Distanza minima tra le zone (per il beep / numero grande).
    readonly property int nearest: Math.min(zones[0], zones[1], zones[2], zones[3])

    // --- MOCK: un ostacolo che si avvicina, per vedere i sensori "lavorare" --
    property bool mock: true
    property int _t: 0
    Timer {
        interval: 120
        running: root.mock && root.reverse
        repeat: true
        onTriggered: {
            root._t += 1;
            var d = root.maxRange - (root._t % (root.maxRange + 10)); // 150 -> ~0
            if (d < 15) d = 15;
            root.zones = [ Math.min(root.maxRange, d + 55),  // sinistra (piu' lontana)
                           Math.min(root.maxRange, d + 12),  // centro-sx
                           d,                                // centro-dx (piu' vicina)
                           Math.min(root.maxRange, d + 40) ] // destra
        }
    }
    onReverseChanged: {
        if (!reverse) { _t = 0; zones = [maxRange, maxRange, maxRange, maxRange]; }
    }

    // Colore di una zona in base alla distanza (verde/giallo/rosso).
    function zoneColor(cm) {
        if (cm <= dangerCm) return "#e5322d";      // rosso
        if (cm <= warnCm)   return "#edbb00";      // giallo
        return "#37b24d";                          // verde
    }
    // Quanto è "piena" una zona (0 lontano .. 1 vicinissimo).
    function zoneFill(cm) {
        var f = 1.0 - (cm / maxRange);
        return f < 0 ? 0 : (f > 1 ? 1 : f);
    }
}
