import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

// Media / Radio (fedele al mockup): tab in alto, "now playing" a sinistra con
// logo stazione + equalizzatore + controlli, lista stazioni a destra.
Item {
    id: root
    property var vehicle: null
    property int tab: 0
    readonly property var tabs: ["Radio", "Bluetooth", "USB", "Streaming"]

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 34
        anchors.rightMargin: 34
        anchors.topMargin: 22
        anchors.bottomMargin: 24
        spacing: 22

        // ------------------------------------------------------------- TAB
        RowLayout {
            spacing: 30
            Repeater {
                model: root.tabs
                delegate: Item {
                    required property int index
                    required property var modelData
                    implicitWidth: lbl.implicitWidth
                    implicitHeight: 30
                    Text {
                        id: lbl
                        text: modelData
                        font.family: T.sans; font.pixelSize: 18
                        font.weight: root.tab === index ? Font.DemiBold : Font.Medium
                        color: root.tab === index ? T.text : T.n600
                    }
                    Rectangle {
                        visible: root.tab === index
                        anchors.top: lbl.bottom; anchors.topMargin: 6
                        width: lbl.width; height: 2; radius: 1; color: T.accent
                    }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: root.tab = index }
                }
            }
            Item { Layout.fillWidth: true }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 34

            // ------------------------------------------------ NOW PLAYING
            ColumnLayout {
                Layout.preferredWidth: 320
                Layout.maximumWidth: 360
                Layout.fillHeight: true
                spacing: 16

                RowLayout {
                    spacing: 18
                    // logo stazione
                    Rectangle {
                        width: 108; height: 108; radius: 16
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#8ec63f" }
                            GradientStop { position: 1.0; color: "#5a9e1e" }
                        }
                        Text { anchors.centerIn: parent; text: "B3"
                               font.family: T.num; font.pixelSize: 46; font.weight: Font.DemiBold
                               color: "#10240a" }
                    }
                    ColumnLayout {
                        spacing: 3
                        Text { text: (root.vehicle && root.vehicle.mediaTitle) ? root.vehicle.mediaTitle : "Bayern 3"
                               font.family: T.sans; font.pixelSize: 26
                               font.weight: Font.DemiBold; color: T.text }
                        Text { text: (root.vehicle && root.vehicle.mediaArtist) ? root.vehicle.mediaArtist : "Good Music. Good Mood."
                               font.family: T.sans; font.pixelSize: 15; color: T.n700 }
                        RowLayout {
                            spacing: 10
                            Layout.topMargin: 4
                            Rectangle {
                                implicitWidth: dab.implicitWidth + 14; implicitHeight: 22; radius: 4
                                color: T.glassHi; border.width: 1; border.color: T.glassBorder
                                Text { id: dab; anchors.centerIn: parent; text: "DAB+"
                                       font.family: T.sans; font.pixelSize: 12; font.weight: Font.DemiBold
                                       font.letterSpacing: 1; color: T.accent }
                            }
                            // equalizzatore
                            Item {
                                implicitWidth: 27; implicitHeight: 20
                                Layout.alignment: Qt.AlignVCenter
                                Repeater {
                                    model: 5
                                    delegate: Rectangle {
                                        id: bar
                                        required property int index
                                        x: index * 6
                                        width: 3; radius: 1.5; color: T.accent
                                        anchors.bottom: parent.bottom
                                        height: 6
                                        Timer {
                                            interval: 180 + bar.index * 40; running: true; repeat: true
                                            onTriggered: bar.height = 4 + Math.random() * 16
                                        }
                                        Behavior on height { NumberAnimation { duration: 180 } }
                                    }
                                }
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                // controlli
                RowLayout {
                    spacing: 18
                    IconButton { icon: "skip-back"; size: 54; round: true }
                    IconButton { icon: "pause"; size: 66; round: true; primary: true }
                    IconButton { icon: "skip-forward"; size: 54; round: true }
                    Item { Layout.fillWidth: true }
                    Icon { name: "speaker-high"; size: 22; color: T.n700; Layout.alignment: Qt.AlignVCenter }
                }
            }

            // ------------------------------------------------ LISTA STAZIONI
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8
                Repeater {
                    model: [
                        [1, "Bayern 3",       "B3",  "#8ec63f", "#10240a", true],
                        [2, "ANTENNE BAYERN", "AB",  "#0a63b8", "#ffffff", false],
                        [3, "BR Klassik",     "BR",  "#12314f", "#cfe0f2", false],
                        [4, "Sunshine Live",  "SL",  "#e8541e", "#ffffff", false],
                        [5, "ENERGY",         "EN",  "#d81f3a", "#ffffff", false]
                    ]
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        implicitHeight: 60
                        radius: 12
                        color: modelData[5] ? T.glassHi : (ma.containsMouse ? T.glass : "transparent")
                        border.width: 1
                        border.color: modelData[5] ? T.glassBorder : "transparent"
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14; anchors.rightMargin: 16
                            spacing: 14
                            Text { text: modelData[0]; font.family: T.num; font.pixelSize: 18
                                   color: modelData[5] ? T.accent : T.n600; Layout.preferredWidth: 16 }
                            Rectangle {
                                width: 40; height: 40; radius: 9; color: modelData[3]
                                Text { anchors.centerIn: parent; text: modelData[2]
                                       font.family: T.num; font.pixelSize: 18; font.weight: Font.DemiBold
                                       color: modelData[4] }
                            }
                            Text { Layout.fillWidth: true; text: modelData[1]
                                   font.family: T.sans; font.pixelSize: 18
                                   font.weight: modelData[5] ? Font.DemiBold : Font.Medium
                                   color: modelData[5] ? T.text : T.n800 }
                        }
                        MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor }
                    }
                }
                Item { Layout.fillHeight: true }
            }
        }
    }
}
