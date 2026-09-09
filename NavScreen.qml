import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

Item {
    RowLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 28

        // Colonna rotta
        ColumnLayout {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            spacing: 6
            SectionLabel { text: "Percorso" }
            Text { text: "Via Tortona 21"; font.family: T.serif; font.pixelSize: 30; font.weight: Font.DemiBold; color: T.text }
            Text { text: "Arrivo 09:55 · 14 min · 9.4 km"; font.family: T.serif; font.pixelSize: 17; color: T.n700; Layout.bottomMargin: 16 }

            RowLayout {
                spacing: 12
                Text { text: "↱"; font.pixelSize: 44; color: T.accent }
                ColumnLayout {
                    spacing: 0
                    Text { text: "400 m"; font.family: T.serif; font.pixelSize: 24; font.weight: Font.DemiBold; color: T.text }
                    Text { text: "A destra su Viale Coni Zugna"; font.family: T.serif; font.pixelSize: 16; color: T.n700 }
                }
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: T.divider; Layout.topMargin: 14; Layout.bottomMargin: 12 }
            Text { text: "Poi · A sinistra su Via Solari"; font.family: T.serif; font.pixelSize: 16; color: T.n700 }
            Text { text: "Poi · A destra su Via Tortona"; font.family: T.serif; font.pixelSize: 16; color: T.n700 }
            Item { Layout.fillHeight: true }
            PrimaryButton { text: "Alternative"; primary: false }
        }

        // Mappa stilizzata
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: T.n200
            clip: true

            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.strokeStyle = "#d7d3d3"; ctx.lineWidth = 22;
                    var ys = [height*0.25, height*0.65]; var xs = [width*0.18, width*0.55, width*0.82];
                    for (var i=0;i<ys.length;i++){ ctx.beginPath(); ctx.moveTo(0,ys[i]); ctx.lineTo(width,ys[i]); ctx.stroke(); }
                    for (var j=0;j<xs.length;j++){ ctx.beginPath(); ctx.moveTo(xs[j],0); ctx.lineTo(xs[j],height); ctx.stroke(); }
                    // percorso
                    ctx.strokeStyle = "#0088b0"; ctx.lineWidth = 12; ctx.lineJoin = "round";
                    ctx.beginPath();
                    ctx.moveTo(width*0.18, height*0.9);
                    ctx.lineTo(width*0.18, height*0.65);
                    ctx.lineTo(width*0.55, height*0.65);
                    ctx.lineTo(width*0.55, height*0.25);
                    ctx.lineTo(width*0.82, height*0.25);
                    ctx.stroke();
                    // destinazione
                    ctx.fillStyle = "#d6006c";
                    ctx.beginPath(); ctx.arc(width*0.82, height*0.25, 9, 0, Math.PI*2); ctx.fill();
                    // partenza
                    ctx.fillStyle = "#201e1d";
                    ctx.beginPath(); ctx.arc(width*0.18, height*0.9, 7, 0, Math.PI*2); ctx.fill();
                }
            }
            Rectangle {
                anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: 16
                width: info.implicitWidth + 28; height: info.implicitHeight + 20; color: T.bg
                Text { id: info; anchors.centerIn: parent; text: "Parcheggio a destinazione · 6 liberi"; font.family: T.serif; font.pixelSize: 15; color: T.text }
            }
        }
    }
}
