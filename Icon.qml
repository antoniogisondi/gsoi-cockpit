import QtQuick
import "Theme.js" as T
import "Icons.js" as Ic

// Icona Phosphor: passa `name` (es. "house") e opzionalmente size/color.
Text {
    property string name: ""
    property real size: 24

    font.family: "Phosphor"
    font.pixelSize: size
    text: Ic.glyph(name)
    color: T.text
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
}
