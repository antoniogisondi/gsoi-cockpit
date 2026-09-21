import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Card informativa in "vetro": intestazione (icona + etichetta + chevron) e
// un'area contenuto libera (slot di default).
Rectangle {
    id: root
    property string icon: ""
    property string label: ""
    property bool showChevron: true

    default property alias content: contentArea.data

    radius: 14
    color: T.glass
    border.width: 1
    border.color: T.glassBorder

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 9
            Icon { name: root.icon; size: 17; color: T.n600 }
            Text {
                Layout.fillWidth: true
                text: root.label
                font.family: T.sans; font.pixelSize: 14; color: T.n700
                elide: Text.ElideRight
            }
            Canvas {
                visible: root.showChevron
                width: 10; height: 15
                onPaint: {
                    var c = getContext("2d"); c.reset();
                    c.strokeStyle = T.n600; c.lineWidth = 1.8;
                    c.lineCap = "round"; c.lineJoin = "round";
                    c.beginPath(); c.moveTo(3, 2.5); c.lineTo(8, 7.5); c.lineTo(3, 12.5); c.stroke();
                }
            }
        }

        Item {
            id: contentArea
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
