.pragma library

// Mappa nome icona -> codepoint del font Phosphor (weight "regular").
var map = {
    "house": 0xe2c2,
    "navigation-arrow": 0xeade,
    "music-notes": 0xe340,
    "sparkle": 0xe6a2,
    "bluetooth-connected": 0xe0dc,
    "thermometer-simple": 0xe5cc,
    "gauge": 0xe628,
    "phone": 0xe3b8,
    "gear": 0xe270,
    "play": 0xe3d0,
    "pause": 0xe39e,
    "skip-back": 0xe5a4,
    "skip-forward": 0xe5a6,
    "plus": 0xe3d4,
    "minus": 0xe32a,
    "warning": 0xe4e0,
    "microphone": 0xe326,
    "wifi-high": 0xe4ea,
    "car": 0xe112,
    "speaker-high": 0xe44a,
    "arrow-bend-up-right": 0xe026,
    "phone-incoming": 0xe3be,
    "phone-outgoing": 0xe3c0,
    "lightning": 0xe2de,
    "waveform": 0xe802,
    "steering-wheel": 0xe9ac,
    "battery-high": 0xe0c2
};

function glyph(name) {
    var c = map[name];
    return c ? String.fromCharCode(c) : "";
}
