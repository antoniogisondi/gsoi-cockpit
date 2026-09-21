import QtQuick

// Barra delle spie: mostra, centrate, solo le spie ACCESE (come un quadro
// digitale). Ordine per gravità: rosse, poi ambra, poi blu.
Row {
    id: root
    property var cd: null           // ClusterData
    property real cell: 34
    spacing: 16

    // Elenco {kind, on} in ordine di priorità; il Repeater ne mostra solo gli on.
    readonly property var slots: !cd ? [] : [
        { kind: "brake",    on: cd.tBrake },
        { kind: "oil",      on: cd.tOil },
        { kind: "battery",  on: cd.tBattery },
        { kind: "coolant",  on: cd.tCoolant },
        { kind: "airbag",   on: cd.tAirbag },
        { kind: "seatbelt", on: cd.tSeatbelt },
        { kind: "engine",   on: cd.tEngine },
        { kind: "abs",      on: cd.tAbs },
        { kind: "lowFuel",  on: cd.tLowFuel },
        { kind: "glow",     on: cd.tGlow },
        { kind: "highBeam", on: cd.tHighBeam }
    ]
    readonly property var active: slots.filter(function (s) { return s.on; })

    Repeater {
        model: root.active
        delegate: Telltale {
            required property var modelData
            kind: modelData.kind
            size: root.cell
        }
    }
}
