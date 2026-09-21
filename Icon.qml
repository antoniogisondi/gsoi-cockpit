import QtQuick

// Icona SVG (set dai mockup GSOI). `name` = file images/icons/<name>.svg.
// È un Item che contiene l'Image: così la dimensione implicita (che un Layout
// usa per dimensionarla) è `size` e non la sourceSize dell'SVG → niente icone
// giganti. `color` è mantenuto per compat (gli SVG non vengono ricolorati).
// Richiede il modulo qtsvg.
Item {
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

    implicitWidth: size
    implicitHeight: size
    width: size
    height: size

    Image {
        anchors.fill: parent
        source: root.name === "" ? ""
                : "images/icons/" + (root._map[root.name] !== undefined ? root._map[root.name] : root.name) + ".svg"
        sourceSize: Qt.size(64, 64)     // risoluzione di rasterizzazione dell'SVG
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
    }
}
