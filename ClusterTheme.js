.pragma library

// Token di design del QUADRO STRUMENTI (gsoi-cluster) — tema SCURO dedicato,
// distinto dal cockpit (che è chiaro/editoriale). Un quadro dietro al volante
// deve essere scuro: di notte non abbaglia. Stile ispirato ai cockpit digitali
// premium (ali laterali, riempimento luminoso, velocità digitale al centro).

// Fondali / neutri (nero con leggera dominante blu).
var bg     = "#070a0f";
var stage  = "#090d13";
var stage2 = "#0f1723";     // alone in alto
var track  = "#18212e";     // traccia degli strumenti

// Testo.
var ink    = "#eef4fa";
var muted  = "#8593a4";
var dim    = "#46525f";

// Accenti / semafori (colori standard, leggibili su fondo scuro).
var teal   = "#1ec8e6";     // accento GSOI (riempimento strumenti)
var amber  = "#f4b524";
var red    = "#ff4d3d";
var green  = "#37e08a";
var blue   = "#55a6ff";

// Famiglie font imbarcate nell'app (vedi src/cluster_main.cpp).
var display = "Saira Condensed";   // numeri (velocità, giri, tacche)
var label   = "Barlow";            // etichette / testo piccolo
