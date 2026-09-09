import QtQuick
import "Theme.js" as T

// Etichetta di sezione (piccola, in accento) — lo "h6" del mockup.
Text {
    font.family: T.serif
    font.pixelSize: 14
    font.weight: Font.DemiBold
    font.letterSpacing: 0.5
    color: T.accent700
}
