# GSOI Cockpit

Interfaccia (cockpit/infotainment) di **GSOI Automotive OS**, scritta in
**Qt 6 / Qt Quick (QML)**. Gira a schermo intero come **client Wayland** sul
Raspberry Pi 5, avviata al boot da GSOI Automotive OS.

> Toolkit nativo (niente web), touch-first, tema scuro automotive.

## Cosa contiene la v0.1

- **Home touch** con riquadri: Jarvis, Auto, Mappa, Musica, Telefono, Casa,
  Bluetooth, Impostazioni (feedback alla pressione).
- **Barra di stato**: logo GSOI, stato connessione (offline/connesso),
  orologio live.
- **Pannello veicolo**: giri motore, temperatura, tensione batteria
  (valori **mock**; in futuro alimentati da Jarvis Mini / OBD in sola lettura).

L'interfaccia è volutamente **indipendente dai font** (nessuna emoji): usa
monogrammi e forme, così è leggibile anche su un'immagine Yocto minimale.

## Struttura

```
gsoi-cockpit/
├── CMakeLists.txt        # progetto Qt6 (Quick), eseguibile "gsoi-cockpit"
├── src/main.cpp          # entrypoint: carica il modulo QML a schermo intero
├── Main.qml              # schermata principale (layout)
├── StatusBar.qml         # barra superiore
├── Tile.qml              # riquadro touch
├── VehiclePanel.qml      # pannello dati veicolo
└── Readout.qml           # singola voce del pannello
```

## Build e run (sviluppo, su PC con Qt6)

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
./build/gsoi-cockpit
```

Per forzare il backend grafico:

```bash
# su desktop Wayland
./build/gsoi-cockpit -platform wayland
# oppure diretto su framebuffer/DRM (single app, senza compositor)
./build/gsoi-cockpit -platform eglfs
```

## Integrazione in GSOI Automotive OS

Nell'immagine viene installato via una ricetta in `meta-gsoi`
(`recipes-gsoi/cockpit/`) e avviato a schermo intero come client Wayland
(compositor Weston) tramite un servizio systemd, dopo lo splash.

## Roadmap

- collegare i dati veicolo reali (da Jarvis Mini / OBD)
- navigazione fra le sezioni (Jarvis, Mappa, Musica…)
- integrazione avvisi proattivi e stato vocale
- design rifinito con Qt Design Studio
