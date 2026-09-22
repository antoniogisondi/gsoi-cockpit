import QtQuick

// Stato di ALIMENTAZIONE del cockpit — replica il comportamento della testa
// di serie (Media Nav) della Clio: a quadro in ACC / sportello aperto lo
// schermo non si accende del tutto, ma resta in STANDBY mostrando l'orologio
// su fondo nero. Si "accende" davvero col pulsante power o all'avvio del motore.
//
//   mode = "standby"  → schermo orologio (nero), cockpit sospeso
//   mode = "on"       → cockpit attivo
//
// Ingressi reali (in auto): pulsante power (GPIO) e linea di accensione /
// motore (ACC/IGN via CAN o GPIO). Qui, mock: il motore si deduce dalla
// telemetria (rpm/velocità) e il pulsante power si simula col tasto 'P'.
Item {
    id: root
    visible: false

    property var vehicle: null

    // Al boot si parte in standby (come "apri lo sportello → orologio").
    property string mode: "standby"
    readonly property bool powered: mode === "on"

    // Motore in moto? (rpm o velocità > 0). In auto arriverà dalla linea IGN.
    readonly property bool engineRunning:
        vehicle ? (vehicle.rpm > 0 || vehicle.speedKmh > 0) : false

    // Avvio motore → accende; motore spento → torna all'orologio (standby).
    onEngineRunningChanged: root.mode = root.engineRunning ? "on" : "standby"
    // Se all'avvio del cockpit il motore risulta già in moto, parti acceso.
    Component.onCompleted: if (root.engineRunning) root.mode = "on"

    // Pulsante power: accende/spegne (toggle), come la testa di serie.
    function toggle() { root.mode = (root.mode === "on") ? "standby" : "on" }
    function wake()   { root.mode = "on" }
    function sleep()  { root.mode = "standby" }
}
