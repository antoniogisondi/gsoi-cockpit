.pragma library

// GSOI Automotive OS — sistema di design (tema SCURO "glass").
// Ricostruito sui mockup ufficiali: fondo blu-notte, superfici in vetro
// traslucido, accento ciano, tipografia Barlow. I nomi storici dei token sono
// mantenuti (rimappati su valori scuri) così le schermate non ancora ridisegnate
// restano leggibili durante la transizione.

// --- Fondali -----------------------------------------------------------------
var bg       = "#070b12";   // fondo generale (blu-notte)
var bgDeep   = "#04070c";   // più profondo (sidebar / gradienti)
var surface  = "#0e141d";   // superficie piena

// Vetro (superfici traslucide sopra il fondo/hero). Formato #AARRGGBB.
var glass       = "#0affffff";   // ~4% bianco
var glassHi     = "#16ffffff";   // ~9% (hover / attivo)
var glassBorder = "#1fffffff";   // ~12% bordo hairline
var hairline    = "#14ffffff";   // separatori

// --- Testo -------------------------------------------------------------------
var text    = "#eaf0f7";
var divider = "#1b2431";

// --- Accenti -----------------------------------------------------------------
var accent      = "#33b7e8";   // ciano GSOI (attivo, sottotitoli, link)
var accent700   = "#5cccf2";   // ciano chiaro (testo accento su scuro)
var accentDeep  = "#1f7fb0";
var accent2     = "#ff5c9d";   // magenta (usato di rado)
var accent2_700 = "#ff86b7";
var yellow      = "#f4b524";
var green       = "#37e08a";
var red         = "#ff5648";

// --- Rampa neutra (invertita per il tema scuro) ------------------------------
// numeri bassi = superfici/bordi scuri, numeri alti = testo chiaro.
var n200 = "#10161f";
var n300 = "#182029";   // track / stato premuto
var n400 = "#26303c";
var n500 = "#5b6675";
var n600 = "#8593a4";   // testo attenuato
var n700 = "#a6b3c2";   // testo secondario
var n800 = "#cdd8e4";   // testo quasi pieno

// --- Tipografia (font imbarcati, vedi src/main.cpp) --------------------------
// "serif" è mantenuto come nome storico ma punta a Barlow (le vecchie schermate
// lo usano ovunque). Per il testo nuovo usare i nomi espliciti.
var serif = "Barlow";           // compat: era Source Serif 4
var sans  = "Barlow";           // UI generale
var num   = "Saira Condensed";  // numeri / dati

// Spaziatura lettere per le etichette maiuscole larghe dei mockup.
var trackWide = 3.0;
