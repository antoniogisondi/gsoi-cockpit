import QtQuick

// Legge lo stato da Jarvis Mini (server HTTP locale) e lo espone come
// proprieta' bindabili. Se Jarvis Mini non e' raggiungibile, `online`
// resta false e i valori mantengono gli ultimi noti / default.
Item {
    id: root
    visible: false

    property string endpoint: "http://127.0.0.1:8090/state"
    property int pollMs: 2000

    property bool online: false
    property string mode: "offline"          // "offline" | "connected"

    // Telemetria (EV + ICE generici).
    property int speed: 0
    property int rpm: 0
    property int engineTemp: 0
    property real battery: 0
    property int chargePct: 84
    property int rangeKm: 412

    property string mediaTitle: "—"
    property string mediaArtist: ""

    // Agent (proattività + voce).
    property bool agentListening: false
    property string agentMessage: ""

    function _pick(v, d) { return (v === undefined || v === null) ? d : v; }

    function refresh() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;
            if (xhr.status === 200) {
                try {
                    var d = JSON.parse(xhr.responseText);
                    root.online = true;
                    root.mode = root._pick(d.mode, "offline");
                    var v = d.vehicle || {};
                    root.speed = root._pick(v.speed, root.speed);
                    root.rpm = root._pick(v.rpm, root.rpm);
                    root.engineTemp = root._pick(v.engine_temp, root.engineTemp);
                    root.battery = root._pick(v.battery_v, root.battery);
                    root.chargePct = root._pick(v.charge_pct, root.chargePct);
                    root.rangeKm = root._pick(v.range_km, root.rangeKm);
                    var m = d.media || {};
                    root.mediaTitle = root._pick(m.title, root.mediaTitle);
                    root.mediaArtist = root._pick(m.artist, root.mediaArtist);
                    var a = d.agent || {};
                    root.agentListening = root._pick(a.listening, false);
                    root.agentMessage = root._pick(a.message, root.agentMessage);
                } catch (e) {
                    root.online = false;
                }
            } else {
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
