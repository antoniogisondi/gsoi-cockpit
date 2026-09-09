import QtQuick
import QtQuick.Layouts
import "Theme.js" as T

Rectangle {
    id: root

    property string current: "home"
    signal select(string screen)

    color: T.bg

    Rectangle {
        anchors.right: parent.right
        width: 1
        height: parent.height
        color: T.divider
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 2

        Text {
            text: "GSOI"
            font.family: T.serif
            font.pixelSize: 22
            font.weight: Font.DemiBold
            color: T.text
        }
        Text {
            text: "AUTOMOTIVE OS"
            font.pixelSize: 11
            font.letterSpacing: 1.6
            color: T.n600
            Layout.bottomMargin: 22
        }

        Repeater {
            model: [
                ["home", "Home", "house"],
                ["nav", "Naviga", "navigation-arrow"],
                ["media", "Musica", "music-notes"],
                ["agent", "Agent", "sparkle"],
                ["conn", "Connessioni", "bluetooth-connected"],
                ["climate", "Clima", "thermometer-simple"],
                ["cluster", "Cruscotto", "gauge"],
                ["phone", "Telefono", "phone"],
                ["settings", "Impostazioni", "gear"]
            ]
            delegate: Rectangle {
                id: item
                required property var modelData
                readonly property bool active: root.current === modelData[0]
                Layout.fillWidth: true
                implicitHeight: 46
                radius: 2
                color: item.active ? Qt.rgba(0, 0.53, 0.69, 0.12)
                                   : (ma.containsMouse ? Qt.rgba(0.12, 0.12, 0.11, 0.06) : "transparent")

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 10
                    spacing: 12
                    Icon {
                        name: item.modelData[2]
                        size: 24
                        color: item.active ? T.accent700 : T.text
                    }
                    Text {
                        Layout.fillWidth: true
                        text: item.modelData[1]
                        font.family: T.serif
                        font.pixelSize: 18
                        font.weight: Font.DemiBold
                        color: item.active ? T.accent700 : T.text
                    }
                }

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.select(modelData[0])
                }
            }
        }

        Item { Layout.fillHeight: true }

        Text {
            text: "v0.1 · Genesis"
            font.pixelSize: 13
            color: T.n600
        }
    }
}
