import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Tile rapida in "vetro": icona, titolo, sottotitolo in accento, chevron.
Rectangle {
    id: root
    property string icon: ""
    property string title: ""
    property string subtitle: ""
    signal clicked()

    radius: 14
    color: ma.pressed ? T.glassHi : T.glass
    border.width: 1
    border.color: ma.containsMouse ? T.accent : T.glassBorder

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 18
        spacing: 16

        Icon { name: root.icon; size: 30; color: T.text }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Text {
                text: root.title
                font.family: T.sans; font.pixelSize: 18; font.weight: Font.Medium
                color: T.text; elide: Text.ElideRight; Layout.fillWidth: true
            }
            Text {
                visible: root.subtitle !== ""
                text: root.subtitle
                font.family: T.sans; font.pixelSize: 14; color: T.accent
                elide: Text.ElideRight; Layout.fillWidth: true
            }
        }

        // chevron
        Canvas {
            width: 12; height: 18
            Layout.alignment: Qt.AlignVCenter
            onPaint: {
                var c = getContext("2d");
                c.reset();
                c.strokeStyle = T.n600; c.lineWidth = 2;
                c.lineCap = "round"; c.lineJoin = "round";
                c.beginPath();
                c.moveTo(3, 3); c.lineTo(9, 9); c.lineTo(3, 15);
                c.stroke();
            }
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
