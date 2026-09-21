import QtQuick

// Icona SVG (set dai mockup GSOI). `name` = file images/icons/<name>.svg.
// Mantiene `size` e `color` per compatibilità con le chiamate esistenti: gli
// SVG hanno il proprio tratto e NON vengono ricolorati (lo stato attivo si
// indica via sfondo/etichetta, come nei mockup). Richiede il modulo qtsvg.
Image {
    id: root
    property string name: "home"
    property real size: 24
    property color color: "#c5dafa"     // compat (ignorato dagli SVG)

    // Mappa dai nomi storici (Phosphor) ai file SVG.
    readonly property var _map: ({
        "house": "home", "navigation-arrow": "nav", "music-notes": "media",
        "sparkle": "ai", "gear": "settings", "bluetooth-connected": "bluetooth",
        "wifi-high": "wifi", "thermometer-simple": "sun", "speaker-high": "speaker",
        "skip-back": "previous", "skip-forward": "next", "lightning": "search",
        "gauge": "clock", "warning": "info", "microphone": "ai"
    })

    width: size
    height: size
    source: name === "" ? "" : "images/icons/" + (_map[name] !== undefined ? _map[name] : name) + ".svg"
    sourceSize: Qt.size(96, 96)
    fillMode: Image.PreserveAspectFit
    smooth: true
    mipmap: true
}
