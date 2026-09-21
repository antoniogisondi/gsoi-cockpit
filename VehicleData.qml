import QtQuick

// Sorgente dati LIVE del cockpit. Legge da DUE servizi locali:
//   • jarvis-mini   127.0.0.1:8090/state    → modalità rete, media, agente
//   • gsoi-vehicled 127.0.0.1:8093/vehicle  → telemetria reale (CAN sola lettura)
// Espone tutto come proprietà bindabili. Se un servizio non risponde, i valori
// restano agli ultimi noti e i flag *Online vanno a false.
Item {
    id: root
    visible: false

    property string stateUrl:   "http://127.0.0.1:8090/state"
    property string vehicleUrl: "http://127.0.0.1:8093/vehicle"

    // --- Rete / agente (jarvis-mini) ---
    property bool jarvisOnline: false
    property bool online: false               // rete presente (mode connected)
    property string mode: "offline"
    property string mediaTitle: ""
    property string mediaArtist: ""
    property bool agentListening: false
    property string agentMessage: ""
    property var agentSuggestions: []

    // --- Assistente vocale: dialogo dal vivo (agent.conversation) ---
    // convState: idle | listening | thinking | speaking
    property string convState: "idle"
    property bool convActive: false           // c'è un dialogo in corso
    property string convUser: ""              // ultima frase dell'utente
    property string convReply: ""             // ultima risposta di Jarvis

    // --- Telemetria (gsoi-vehicled, CAN) ---
    property bool canOnline: false
    property int speedKmh: 0
    property int rpm: 0
    property int coolantC: 0
    property int fuelPct: 0
    property int outsideC: 0
    property string gear: ""

    // --- Compat (nomi storici) ---
    property int speed: 0
    property int engineTemp: 0
    property int rangeKm: 412
    property int chargePct: 84

    function _pick(v, d) { return (v === undefined || v === null) ? d : v; }

    function _get(url, cb) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE) return;
            if (xhr.status === 200) {
                try { cb(JSON.parse(xhr.responseText), true); }
                catch (e) { cb(null, false); }
            } else { cb(null, false); }
        };
        try { xhr.open("GET", url); xhr.send(); }
        catch (e) { cb(null, false); }
    }

    function refreshState() {
        _get(root.stateUrl, function (d, ok) {
            root.jarvisOnline = ok;
            if (!ok) return;
            root.mode = root._pick(d.mode, "offline");
            var c = d.connection || {};
            root.online = root._pick(c.online, root.mode === "connected");
            var m = d.media || {};
            root.mediaTitle = root._pick(m.title, root.mediaTitle);
            root.mediaArtist = root._pick(m.artist, root.mediaArtist);
            var a = d.agent || {};
            root.agentListening = root._pick(a.listening, false);
            root.agentMessage = root._pick(a.message, root.agentMessage);
            root.agentSuggestions = root._pick(a.suggestions, []);
            var cv = a.conversation || {};
            root.convState = root._pick(cv.state, "idle");
            root.convActive = root.convState !== "idle";
            root.convUser = root._pick(cv.you, "");
            root.convReply = root._pick(cv.reply, "");
            var v = d.vehicle || {};
            root.speed = root._pick(v.speed, root.speed);
            root.engineTemp = root._pick(v.engine_temp, root.engineTemp);
            root.rangeKm = root._pick(v.range_km, root.rangeKm);
            root.chargePct = root._pick(v.charge_pct, root.chargePct);
        });
    }

    function refreshVehicle() {
        _get(root.vehicleUrl, function (d, ok) {
            root.canOnline = ok && root._pick(d ? d.online : false, false);
            if (!ok || !d) return;
            root.speedKmh = root._pick(d.speed_kmh, 0);
            root.rpm = root._pick(d.rpm, 0);
            root.coolantC = root._pick(d.coolant_c, 0);
            root.fuelPct = root._pick(d.fuel_pct, 0);
            root.outsideC = root._pick(d.outside_c, root.outsideC);
            root.gear = root._pick(d.gear, "");
        });
    }

    // Invia una battuta all'assistente (ponte a testo POST /ask). È così che il
    // cockpit "parla" con Jarvis: i chip e la barra di input della schermata AI
    // chiamano questo metodo. La risposta compare in convReply al prossimo
    // refresh dello stato (qui anticipato per reattività).
    function ask(text) {
        if (!text || text.length === 0) return;
        root.convState = "thinking";
        root.convActive = true;
        root.convUser = text;
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE) return;
            if (xhr.status === 200) {
                try {
                    var r = JSON.parse(xhr.responseText);
                    if (r && r.reply) root.convReply = r.reply;
                } catch (e) {}
            }
            root.refreshState();   // allinea lo stato del dialogo dal servizio
        };
        try {
            xhr.open("POST", root.stateUrl.replace("/state", "/ask"));
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.send(JSON.stringify({ text: text }));
        } catch (e) {}
    }

    Timer { interval: 2000; running: true; repeat: true; triggeredOnStart: true; onTriggered: root.refreshState() }
    Timer { interval: 1200; running: true; repeat: true; triggeredOnStart: true; onTriggered: root.refreshVehicle() }
}
