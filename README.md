# GSOI Cockpit

Interfaccia (cockpit/infotainment) di **GSOI Automotive OS**, scritta in
**Qt 6 / Qt Quick (QML)**. Gira a schermo intero come **client Wayland**
(compositor Weston) sul Raspberry Pi 5, avviata al boot dopo lo splash.

> Toolkit nativo (niente web), touch-first, estetica editoriale automotive.
> Responsive: disegnato a 1280×720 e **scalato uniformemente** a qualsiasi
> risoluzione dello schermo.

## Cosa contiene

- **Navigazione a sezioni** dalla barra laterale (NavRail): Home, Navigazione,
  Media, Agente, Connessioni, Clima, Quadro, Telefono, Impostazioni.
- **Header** con logo GSOI, stato rete e orologio.
- **Dati live**: `VehicleData` legge lo stato da Jarvis Mini (server HTTP
  locale `127.0.0.1:8090/state`) — velocità, giri, temperatura, batteria,
  media, stato agente. Se Jarvis Mini non risponde, resta sugli ultimi valori.
- **Icone Phosphor** (font imbarcato `Phosphor.ttf`) e font serif
  **Source Serif 4** (nell'immagine via ricetta Yocto).
- **Retrocamera + sensori di parcheggio** (vedi sotto).

## Retrocamera e sensori (RearView)

Funzione di **sicurezza**, **indipendente dall'AI** (niente Jarvis Mini, niente
LLM): appena si innesta la **retromarcia**, compare a tutto schermo — sopra al
cockpit — il **video della telecamera posteriore** con **linee guida** di
parcheggio e il **grafico dei sensori PDC** (auto vista dall'alto con archi che
si accendono/colorano avvicinandosi all'ostacolo), come la Media Nav di serie.
Togliendo la retromarcia si torna al cockpit.

- `ReverseData.qml` — stato retromarcia + distanze sensori. **Mock-first**: in
  QEMU il tasto **`R`** simula la retromarcia e un ostacolo che si avvicina. In
  auto il segnale reale arriva dal **filo luce-retromarcia via GPIO** e i
  sensori dal **PDC** (CAN in sola lettura o kit dedicato) — sorgente dedicata,
  fuori dallo stack AI.
- `CameraView.qml` — video + linee guida (segnaposto in mock; slot pronto per un
  `VideoOutput` V4L2/QtMultimedia sull'hardware).
- `ParkingSensors.qml` — grafico PDC (auto + archi per zona).
- `RearViewScreen.qml` — composizione a tutto schermo (video + PDC + badge).

## Struttura

```
gsoi-cockpit/
├── CMakeLists.txt         # progetto Qt6 (Quick), eseguibile "gsoi-cockpit"
├── src/main.cpp           # entrypoint: registra il font e carica il QML
├── Main.qml               # finestra, layout, overlay retrocamera
├── Theme.js               # token di design (colori, font)
├── Icons.js / Icon.qml / IconButton.qml   # icone Phosphor
├── NavRail.qml / Header.qml               # navigazione e barra superiore
├── VehicleData.qml        # dati live da Jarvis Mini (/state)
├── *Screen.qml            # le sezioni (Home, Nav, Media, Agent, …)
└── ReverseData.qml / CameraView.qml / ParkingSensors.qml / RearViewScreen.qml
                           # retrocamera + sensori (indipendenti dall'AI)
```

## Build e run (sviluppo, su PC con Qt6)

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
./build/gsoi-cockpit                 # -platform wayland | eglfs per forzare il backend
```

Test della retrocamera: premi **`R`** per simulare la retromarcia.

## Integrazione in GSOI Automotive OS

Installato via `meta-gsoi/recipes-gsoi/cockpit/` e avviato da Weston come client
Wayland a schermo intero. Per la **telecamera reale** serve aggiungere
`qtmultimedia` all'immagine e collegare il `VideoOutput` al device V4L2 del
dongle di acquisizione (vedi `docs/hardware.md` nell'OS).

## Roadmap

- telecamera reale (V4L2/QtMultimedia) + beep sonoro PDC
- dati veicolo reali da OBD (sola lettura) via Jarvis Mini
- rifinitura grafica e temi
