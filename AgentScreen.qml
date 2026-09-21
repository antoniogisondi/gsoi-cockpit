import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// AI (fedele al mockup): orb luminoso al centro, "How can I help you today?",
// 4 chip di suggerimento, e a destra la frase d'accompagnamento.
Item {
    id: root
    property var vehicle: null

    // Chip: i suggerimenti proattivi REALI dell'agente (se presenti),
    // altrimenti gli spunti predefiniti.
    readonly property var defaultChips: [
        ["search", "Find a charging station nearby"],
        ["media",  "Play some relaxing music"],
        ["cloud",  "What’s the weather at my destination?"],
        ["news",   "Give me a summary of today’s news"]
    ]
    readonly property var chips: (vehicle && vehicle.agentSuggestions && vehicle.agentSuggestions.length > 0)
        ? vehicle.agentSuggestions.map(function (s) { return ["ai", s.text]; })
        : defaultChips

    // Colonna centrale
    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: -60
        width: Math.min(660, parent.width - 320)
        spacing: 22

        // --- Orb ---
        Item {
            id: orb
            Layout.alignment: Qt.AlignHCenter
            width: 150; height: 150
            SequentialAnimation on scale {
                loops: Animation.Infinite
                NumberAnimation { from: 0.97; to: 1.05; duration: 2200; easing.type: Easing.InOutSine }
                NumberAnimation { from: 1.05; to: 0.97; duration: 2200; easing.type: Easing.InOutSine }
            }
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var c = getContext("2d"); c.reset();
                    var W = width, H = height, cx = W / 2, cy = H / 2, R = W / 2 - 12;
                    var glow = c.createRadialGradient(cx, cy, R * 0.3, cx, cy, R * 1.7);
                    glow.addColorStop(0, "rgba(60,150,255,0.30)");
                    glow.addColorStop(1, "rgba(0,0,0,0)");
                    c.fillStyle = glow; c.fillRect(0, 0, W, H);
                    var body = c.createRadialGradient(cx, cy - R * 0.35, R * 0.2, cx, cy, R);
                    body.addColorStop(0, "#173352"); body.addColorStop(1, "#0a1626");
                    c.fillStyle = body;
                    c.beginPath(); c.arc(cx, cy, R, 0, Math.PI * 2); c.fill();
                    c.save();
                    c.strokeStyle = "#4aa8ff"; c.lineWidth = 2.5;
                    c.shadowColor = "#4aa8ff"; c.shadowBlur = 20;
                    c.beginPath(); c.arc(cx, cy, R, 0, Math.PI * 2); c.stroke();
                    c.restore();
                    // riflesso in alto
                    c.strokeStyle = "rgba(255,255,255,0.55)"; c.lineWidth = 2;
                    c.beginPath(); c.arc(cx, cy, R - 2, Math.PI * 1.15, Math.PI * 1.5); c.stroke();
                }
            }
        }

        // Titolo: a riposo è ESATTAMENTE quello del mockup; durante un dialogo
        // riflette con discrezione la fase dell'assistente.
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: {
                if (root.vehicle && root.vehicle.convState === "listening") return "I’m listening…";
                if (root.vehicle && root.vehicle.convState === "thinking")  return "Thinking…";
                return "How can I help you today?";
            }
            font.family: T.sans; font.pixelSize: 30; font.weight: Font.Medium; color: T.text
        }

        // Riga messaggio LIVE — appare SOLO quando c'è qualcosa di reale da dire:
        // la risposta dell'assistente durante un dialogo, oppure (a riposo) un
        // suggerimento proattivo. Senza nulla di attivo la schermata resta
        // identica al mockup.
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: parent.width
            visible: text.length > 0
            text: {
                if (!root.vehicle) return "";
                if (root.vehicle.convActive && root.vehicle.convReply.length > 0)
                    return root.vehicle.convReply;
                if (root.vehicle.agentSuggestions && root.vehicle.agentSuggestions.length > 0)
                    return root.vehicle.agentMessage;
                return "";
            }
            font.family: T.sans; font.pixelSize: 16; color: T.accent
            horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap
        }

        // --- Chip suggeriti (2x2) ---
        GridLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 8
            columns: 2
            rowSpacing: 14; columnSpacing: 14
            Repeater {
                model: root.chips
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.preferredWidth: 315
                    implicitHeight: 58
                    radius: 12
                    color: ma.pressed ? T.glassHi : T.glass
                    border.width: 1; border.color: ma.containsMouse ? T.accent : T.glassBorder
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16; anchors.rightMargin: 16
                        spacing: 13
                        Icon { name: modelData[0]; size: 20; color: T.accent }
                        Text { Layout.fillWidth: true; text: modelData[1]
                               font.family: T.sans; font.pixelSize: 16; color: T.n800
                               elide: Text.ElideRight }
                    }
                    MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                // Toccare un chip "parla" con l'assistente (ponte /ask).
                                onClicked: if (root.vehicle) root.vehicle.ask(modelData[1]) }
                }
            }
        }
    }

    // Frase a destra
    ColumnLayout {
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2
        Text { Layout.alignment: Qt.AlignRight; text: "Natural conversation."
               font.family: T.sans; font.pixelSize: 15; color: T.n700 }
        Text { Layout.alignment: Qt.AlignRight; text: "Real assistance."
               font.family: T.sans; font.pixelSize: 15; color: T.n700 }
        Text { Layout.alignment: Qt.AlignRight; text: "On every journey."
               font.family: T.sans; font.pixelSize: 15; color: T.n700 }
    }
}
