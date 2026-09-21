import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Navigazione (mockup): mappa reale a tutto campo, card di svolta in alto a
// sinistra, riepilogo viaggio, e controlli N / 3D / zoom a destra.
Item {
    id: root

    component MapBtn: Rectangle {
        property string label: ""
        implicitWidth: 46; implicitHeight: 46; radius: 23
        color: "#cc0e141d"; border.width: 1; border.color: T.glassBorder
        Text { anchors.centerIn: parent; text: parent.label
               font.family: T.sans; font.pixelSize: 16; font.weight: Font.DemiBold; color: T.text }
    }

    // ------------------------------------------------------------------- MAPPA
    Rectangle {
        anchors.fill: parent
        color: "#14232e"
        clip: true

        Image {
            anchors.fill: parent
            source: "images/navigation-map.png"
            fillMode: Image.PreserveAspectCrop
        }

        // percorso attivo
        Canvas {
            anchors.fill: parent
            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()
            onPaint: {
                var c = getContext("2d"); c.reset();
                var W = width, H = height;
                c.lineJoin = "round"; c.lineCap = "round";
                c.strokeStyle = "#0f335c"; c.lineWidth = 16;
                c.beginPath();
                c.moveTo(W * 0.52, H * 0.86);
                c.lineTo(W * 0.52, H * 0.52);
                c.lineTo(W * 0.49, H * 0.30);
                c.lineTo(W * 0.50, H * 0.12);
                c.stroke();
                c.save();
                c.strokeStyle = "#3aa5ff"; c.lineWidth = 8;
                c.shadowColor = "#3aa5ff"; c.shadowBlur = 12;
                c.stroke();
                c.restore();
            }
        }

        // marker auto (freccia)
        Rectangle {
            x: parent.width * 0.52 - 26; y: parent.height * 0.86 - 26
            width: 52; height: 52; radius: 26
            color: "#0f6fd6"; border.width: 2; border.color: "#63c8ff"
            Icon { anchors.centerIn: parent; name: "nav"; size: 30; rotation: -45 }
        }
    }

    // -------------------------------------------------------- CARD DI SVOLTA
    Rectangle {
        id: turnCard
        anchors.left: parent.left; anchors.top: parent.top
        anchors.leftMargin: 24; anchors.topMargin: 24
        width: 300
        implicitHeight: turnCol.implicitHeight + 32
        radius: 14
        color: "#e60e141d"; border.width: 1; border.color: T.glassBorder

        Column {
            id: turnCol
            anchors.left: parent.left; anchors.right: parent.right
            anchors.top: parent.top; anchors.margins: 16
            spacing: 12
            RowLayout {
                width: parent.width
                spacing: 14
                Canvas {
                    width: 42; height: 42; Layout.alignment: Qt.AlignVCenter
                    onPaint: {
                        var c = getContext("2d"); c.reset();
                        c.strokeStyle = T.accent; c.fillStyle = T.accent;
                        c.lineWidth = 4; c.lineCap = "round"; c.lineJoin = "round";
                        c.beginPath(); c.moveTo(13, 34); c.lineTo(13, 20);
                        c.quadraticCurveTo(13, 14, 19, 14); c.lineTo(28, 14); c.stroke();
                        c.beginPath(); c.moveTo(24, 8); c.lineTo(32, 14); c.lineTo(24, 20);
                        c.closePath(); c.fill();
                    }
                }
                ColumnLayout {
                    spacing: 0
                    Text { text: "800 m"; font.family: T.num; font.pixelSize: 30
                           font.weight: Font.DemiBold; color: T.text }
                    Text { text: "Turn right"; font.family: T.sans; font.pixelSize: 16; color: T.n700 }
                }
                Item { Layout.fillWidth: true }
            }
            Rectangle { width: parent.width; height: 1; color: T.hairline }
            Text { text: "Mittelring"; font.family: T.sans; font.pixelSize: 16; color: T.n700 }
        }
    }

    // -------------------------------------------------------- RIEPILOGO VIAGGIO
    Rectangle {
        anchors.left: turnCard.left; anchors.top: turnCard.bottom
        anchors.topMargin: 16
        width: 200
        implicitHeight: tripCol.implicitHeight + 28
        radius: 14
        color: "#e60e141d"; border.width: 1; border.color: T.glassBorder

        Column {
            id: tripCol
            anchors.left: parent.left; anchors.top: parent.top; anchors.margins: 14
            spacing: 12
            Repeater {
                model: [["clock", "12 min"], ["route", "8.4 km"], ["clock", "10:36 arrival"]]
                delegate: RowLayout {
                    required property var modelData
                    spacing: 10
                    Icon { name: modelData[0]; size: 18 }
                    Text { text: modelData[1]; font.family: T.sans; font.pixelSize: 16; color: T.text }
                }
            }
        }
    }

    // -------------------------------------------------------------- CONTROLLI
    ColumnLayout {
        anchors.right: parent.right; anchors.top: parent.top
        anchors.rightMargin: 24; anchors.topMargin: 74
        spacing: 12

        MapBtn { label: "N" }
        MapBtn { label: "3D" }
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 46; implicitHeight: 92; radius: 23
            color: "#cc0e141d"; border.width: 1; border.color: T.glassBorder
            Text {
                text: "+"; font.family: T.sans; font.pixelSize: 24; color: T.text
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height * 0.25 - height / 2
            }
            Rectangle {
                width: parent.width - 16; height: 1; x: 8; color: T.hairline
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: "−"; font.family: T.sans; font.pixelSize: 24; color: T.text
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height * 0.75 - height / 2
            }
        }
    }
}
