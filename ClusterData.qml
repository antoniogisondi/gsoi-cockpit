import QtQuick

// Dati del QUADRO STRUMENTI, letti dal servizio gsoi-vehicled (CAN in sola
// lettura) su http://127.0.0.1:8093/vehicle. INDIPENDENTE dall'AI: non passa
// da Jarvis Mini né dal modello LLM. È una funzione di sicurezza/strumentazione.
//
// In QEMU (nessun CAN) il servizio gira in mock e anima valori dimostrativi,
// così il quadro si può vedere e rifinire anche senza hardware.
Item {
    id: root
    visible: false

    property string endpoint: "http://127.0.0.1:8093/vehicle"
    property int pollMs: 150            // reattivo: è la strumentazione di guida

    // true quando il servizio risponde (CAN presente o mock attivo).
    property bool online: false

    // Strumenti principali.
    property int speedKmh: 0
    property int rpm: 0
    property int coolantC: 0            // temperatura liquido refrigerante
    property int fuelPct: 0             // livello carburante 0..100
    property real tripKm: 0
    property int odometerKm: 0
    property int outsideC: 0            // temperatura esterna
    property string gear: ""           // "" se cambio manuale / non disponibile

    // Indicatori di direzione (lampeggianti).
    property bool turnLeft: false
    property bool turnRight: false

    // Spie (telltale). true = accesa. Tutte le più comuni + specifiche diesel.
    property bool tHighBeam: false     // abbaglianti (blu)
    property bool tGlow: false         // preriscaldo candelette dCi (ambra)
    property bool tLowFuel: false      // riserva carburante (ambra)
    property bool tCoolant: false      // temperatura motore (rosso)
    property bool tBattery: false      // ricarica/batteria (rosso)
    property bool tOil: false          // pressione olio (rosso)
    property bool tEngine: false       // avaria motore / MIL (ambra)
    property bool tBrake: false        // freno di stazionamento / liquido (rosso)
    property bool tAbs: false          // ABS (ambra)
    property bool tAirbag: false       // airbag / SRS (rosso)
    property bool tSeatbelt: false     // cintura non allacciata (rosso)

    function _pick(v, d) { return (v === undefined || v === null) ? d : v; }

    function refresh() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;
            if (xhr.status !== 200) {
                root.online = false;
                return;
            }
            try {
                var d = JSON.parse(xhr.responseText);
                root.online = root._pick(d.online, true);
                root.speedKmh = root._pick(d.speed_kmh, 0);
                root.rpm = root._pick(d.rpm, 0);
                root.coolantC = root._pick(d.coolant_c, 0);
                root.fuelPct = root._pick(d.fuel_pct, 0);
                root.tripKm = root._pick(d.trip_km, 0);
                root.odometerKm = root._pick(d.odometer_km, 0);
                root.outsideC = root._pick(d.outside_c, 0);
                root.gear = root._pick(d.gear, "");
                root.turnLeft = root._pick(d.turn_left, false);
                root.turnRight = root._pick(d.turn_right, false);
                var t = d.telltales || {};
                root.tHighBeam = root._pick(t.high_beam, false);
                root.tGlow = root._pick(t.glow, false);
                root.tLowFuel = root._pick(t.low_fuel, false);
                root.tCoolant = root._pick(t.coolant, false);
                root.tBattery = root._pick(t.battery, false);
                root.tOil = root._pick(t.oil, false);
                root.tEngine = root._pick(t.engine, false);
                root.tBrake = root._pick(t.brake, false);
                root.tAbs = root._pick(t.abs, false);
                root.tAirbag = root._pick(t.airbag, false);
                root.tSeatbelt = root._pick(t.seatbelt, false);
            } catch (e) {
                root.online = false;
            }
        };
        try {
            xhr.open("GET", root.endpoint);
            xhr.send();
        } catch (e) {
            root.online = false;
        }
    }

    Timer {
        interval: root.pollMs
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
