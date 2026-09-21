import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Cluster di stato in alto a destra: segnale, bluetooth, temperatura esterna,
// separatore, ora. Stile mockup (icone chiare su fondo scuro).
Item {
    id: root
    property var vehicle: null
    property string outsideTemp: "24°C"

    property string clock: Qt.formatTime(new Date(), "hh:mm")
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: root.clock = Qt.formatTime(new Date(), "hh:mm")
    }

    implicitHeight: 26

    RowLayout {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 16

        // Segnale (4 barre)
        RowLayout {
            spacing: 2
            Layout.alignment: Qt.AlignVCenter
            Repeater {
                model: 4
                delegate: Rectangle {
                    required property int index
                    Layout.alignment: Qt.AlignBottom
                    width: 3
                    height: 5 + index * 3
                    radius: 1
                    color: index < 3 ? T.text : T.n500
                }
            }
        }

        Icon { name: "bluetooth-connected"; size: 17; color: T.text; Layout.alignment: Qt.AlignVCenter }
        Icon { name: "navigation-arrow"; size: 17; color: T.text; Layout.alignment: Qt.AlignVCenter }

        Text {
            text: root.outsideTemp
            font.family: T.sans; font.pixelSize: 16; color: T.text
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle { width: 1; height: 16; color: T.divider; Layout.alignment: Qt.AlignVCenter }

        Text {
            text: root.clock
            font.family: T.sans; font.pixelSize: 16; font.weight: Font.Medium; color: T.text
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
