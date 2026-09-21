# GSOI Cockpit

Interfaccia di **GSOI Automotive OS**, scritta in **Qt 6 / Qt Quick (QML)**.
Gira a schermo intero come **client Wayland** (compositor Weston) sul Raspberry
Pi 5, avviata al boot dopo lo splash. Il repo produce **due eseguibili**:

- **`gsoi-cockpit`** — infotainment sullo schermo centrale (app_id `org.gsoi.cockpit`).
- **`gsoi-cluster`** — **quadro strumenti digitale** sulla 2ª uscita HDMI, dietro
  al volante (app_id `org.gsoi.cluster`). Processo separato, indipendente
  dall'infotainment e dall'AI.

> Toolkit nativo (niente web), touch-first. **Tema scuro "glass"**: fondo
> blu-notte, superfici in vetro traslucido, accento ciano, tipografia Barlow —
> la stessa identità del quadro strumenti (`gsoi-cluster`).

## Aspetto (design)

Ricostruito sui mockup ufficiali di GSOI Automotive OS:

- **Sidebar** (`Sidebar.qml`) con wordmark GSOI e le voci Home · Navigation ·
  Media · Phone · AI · Settings; la voce attiva ha accento ciano e barretta.
- **Status bar** (`StatusBar.qml`) in alto a destra: segnale, bluetooth,
  temperatura, ora.
- **Barra clima** (`ClimateBar.qml`) persistente in basso: temperatura −/+ con
  slider blu→rosso e comandi HVAC (fan, sedili, sbrinamento, ricircolo).
- **Home** (`HomeScreen.qml`): hero atmosferico "Good morning" (`HeroBackground.qml`),
  4 **tile** rapide (`Tile.qml`) e 4 **card** informative (`InfoCard.qml`).
- Font imbarcati (OFL): **Barlow** (UI, 3 pesi) + **Saira Condensed** (numeri) +
  icone **Phosphor**.
- **Schermate** ridisegnate sui pannelli del mockup: **Navigation** (mappa +
  card svolta + N/3D/zoom), **Media** (radio + lista stazioni + equalizzatore),
  **Phone** (dispositivo + azioni), **AI** (orb + chip suggeriti), **Settings**
  (elenco + pannello scenografico).

## Dati live

`VehicleData` legge lo stato da Jarvis Mini (server HTTP locale
`127.0.0.1:8090/state`). Se Jarvis Mini non risponde, resta sugli ultimi valori.

## Funzioni dedicate

- **Retrocamera + sensori di parcheggio** (vedi sotto).
- **Quadro strumenti digitale** su schermo dedicato (vedi sotto).

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

## Quadro strumenti digitale (Cluster)

Eseguibile **separato** (`gsoi-cluster`) pensato per il **2° schermo dietro al
volante**: affianca il quadro OEM (che resta al suo posto: odometro legale,
spie omologate, immobilizer). È una funzione di **strumentazione/sicurezza**,
**indipendente dall'AI**: legge i dati dal servizio **`gsoi-vehicled`** (CAN in
sola lettura) su `127.0.0.1:8093`, **non** da Jarvis Mini né dal modello.

Mostra: **tachimetro** (centrale), **contagiri** con zona rossa dCi, **carburante**
e **temperatura motore**, **contachilometri/tragitto**, **temperatura esterna**,
**ora**, **frecce** lampeggianti e la **barra spie** (abbaglianti, preriscaldo
candelette, riserva, avaria motore, olio, batteria, ABS, airbag, cintura,
freno, temperatura) — accese solo quando attive, con i colori standard.

- `ClusterData.qml` — legge `gsoi-vehicled` (velocità, giri, temp, carburante,
  spie…). In QEMU il servizio gira in **mock animato**, così il quadro è
  visibile e rifinibile anche senza hardware.
- `Gauge.qml` — strumento ad arco riutilizzabile (lancetta + numero digitale).
- `Telltale.qml` / `TelltaleBar.qml` — spie disegnate a vettori, mostrate solo
  quando accese.
- `TurnSignal.qml` — frecce direzione lampeggianti.
- `ClusterMain.qml` — composizione del quadro a tutto schermo (root di `gsoi-cluster`).

L'assegnazione ai due schermi HDMI è gestita da Weston (kiosk-shell) tramite gli
app_id; vedi `meta-gsoi/recipes-graphics/weston-init` nell'OS.

## Struttura

```
gsoi-cockpit/
├── CMakeLists.txt         # progetto Qt6: due eseguibili (cockpit + cluster)
├── src/main.cpp           # entrypoint cockpit (modulo QML GsoiCockpit)
├── src/cluster_main.cpp   # entrypoint quadro strumenti (modulo GsoiCluster)
├── Main.qml               # finestra cockpit, layout, overlay retrocamera
├── Theme.js               # token di design (colori, font) — condiviso
├── Icons.js / Icon.qml / IconButton.qml   # icone Phosphor
├── NavRail.qml / Header.qml               # navigazione e barra superiore
├── VehicleData.qml        # dati live da Jarvis Mini (/state) — cockpit
├── *Screen.qml            # le sezioni cockpit (Home, Nav, Media, Agent, …)
├── ReverseData.qml / CameraView.qml / ParkingSensors.qml / RearViewScreen.qml
│                          # retrocamera + sensori (indipendenti dall'AI)
└── ClusterData.qml / Gauge.qml / Telltale.qml / TelltaleBar.qml /
    TurnSignal.qml / ClusterMain.qml       # quadro strumenti digitale (2° schermo)
```

## Build e run (sviluppo, su PC con Qt6)

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
./build/gsoi-cockpit                  # infotainment  (-platform wayland|eglfs)
./build/gsoi-cluster                  # quadro strumenti (schermo separato)
```

Test della retrocamera: premi **`R`** nel cockpit per simulare la retromarcia.
Il quadro strumenti si alimenta dal servizio `gsoi-vehicled` (mock in QEMU).

## Integrazione in GSOI Automotive OS

Installato via `meta-gsoi/recipes-gsoi/cockpit/` e avviato da Weston come client
Wayland a schermo intero. Per la **telecamera reale** serve aggiungere
`qtmultimedia` all'immagine e collegare il `VideoOutput` al device V4L2 del
dongle di acquisizione (vedi `docs/hardware.md` nell'OS).

## Roadmap

- telecamera reale (V4L2/QtMultimedia) + beep sonoro PDC
- dati veicolo reali da OBD (sola lettura) via Jarvis Mini
- rifinitura grafica e temi
