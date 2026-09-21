import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Navigazione (fedele al mockup): mappa a tutto campo, card di svolta in alto a
// sinistra, riepilogo viaggio, e controlli N / 3D / zoom a destra.
Item {
    id: root

    // Pulsante mappa rotondo (N / 3D).
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
        color: "#0c1420"
        clip: true

        Canvas {
            anchors.fill: parent
            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()
            onPaint: {
                var ctx = getContext("2d"); ctx.reset();
                var W = width, H = height;
                ctx.fillStyle = "#0c1420"; ctx.fillRect(0, 0, W, H);

                // Parco (English Garden) a destra
                ctx.fillStyle = "#132a20";
                ctx.beginPath();
                ctx.moveTo(W * 0.68, H * 0.0);
                ctx.lineTo(W, H * 0.06);
                ctx.lineTo(W, H);
                ctx.lineTo(W * 0.74, H);
                ctx.bezierCurveTo(W * 0.66, H * 0.7, W * 0.8, H * 0.4, W * 0.68, H * 0.0);
                ctx.closePath(); ctx.fill();

                // Strade minori
                ctx.strokeStyle = "#1a2634"; ctx.lineWidth = 6; ctx.lineCap = "round";
                var minor = [[0.10,0.0,0.10,1.0],[0.34,0.0,0.30,1.0],[0.0,0.30,1.0,0.24],
                             [0.0,0.72,0.7,0.80],[0.5,0.0,0.6,1.0]];
                for (var m = 0; m < minor.length; m++) {
                    ctx.beginPath();
                    ctx.moveTo(W*minor[m][0], H*minor[m][1]);
                    ctx.lineTo(W*minor[m][2], H*minor[m][3]);
                    ctx.stroke();
                }
                // Strade maggiori
                ctx.strokeStyle = "#243444"; ctx.lineWidth = 12;
                ctx.beginPath(); ctx.moveTo(0, H*0.52); ctx.lineTo(W, H*0.46); ctx.stroke();
                ctx.beginPath(); ctx.moveTo(W*0.22, H); ctx.lineTo(W*0.30, 0); ctx.stroke();

                // Percorso attivo (blu, con alone)
                ctx.save();
                ctx.strokeStyle = "#2f9bff"; ctx.lineWidth = 8;
                ctx.lineJoin = "round"; ctx.lineCap = "round";
                ctx.shadowColor = "#2f9bff"; ctx.shadowBlur = 14;
                ctx.beginPath();
                ctx.moveTo(W*0.30, H*0.92);
                ctx.lineTo(W*0.30, H*0.52);
                ctx.lineTo(W*0.52, H*0.49);
                ctx.lineTo(W*0.56, H*0.16);
                ctx.stroke();
                ctx.restore();

                // Marker partenza (auto)
                ctx.fillStyle = "#2f9bff";
                ctx.beginPath(); ctx.arc(W*0.30, H*0.92, 9, 0, Math.PI*2); ctx.fill();
                ctx.strokeStyle = "#0c1420"; ctx.lineWidth = 3; ctx.stroke();
                // Marker destinazione
                ctx.fillStyle = "#33b7e8";
                ctx.beginPath(); ctx.arc(W*0.56, H*0.16, 8, 0, Math.PI*2); ctx.fill();

                // Etichette
                ctx.fillStyle = "#5b6675";
                ctx.font = "500 14px 'Barlow'";
                ctx.fillText("Leopoldstr.", W*0.34, H*0.30);
                ctx.fillText("Schwabing", W*0.16, H*0.62);
                ctx.fillText("Münchner Freiheit", W*0.30, H*0.86);
                ctx.fillStyle = "#3f6b52";
                ctx.fillText("English Garden", W*0.80, H*0.66);
            }
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
                // freccia svolta a destra (disegnata)
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
                model: [["gauge", "12 min"], ["navigation-arrow", "8.4 km"], ["gauge", "10:36 arrival"]]
                delegate: RowLayout {
                    required property var modelData
                    spacing: 10
                    Icon { name: modelData[0]; size: 17; color: T.accent }
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
            Icon {
                name: "plus"; size: 20; color: T.text
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height * 0.25 - height / 2
            }
            Rectangle {
                width: parent.width - 16; height: 1; x: 8; color: T.hairline
                anchors.verticalCenter: parent.verticalCenter
            }
            Icon {
                name: "minus"; size: 20; color: T.text
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height * 0.75 - height / 2
            }
        }
    }
}
