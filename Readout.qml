import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    property string caption: ""
    property string unit: ""
    property var value: 0
    property color textMain: "#E6EDF3"
    property color textMuted: "#8A97A6"

    Text {
        text: root.caption
        color: root.textMuted
        font.pixelSize: 16
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
    }

    Text {
        text: root.value + " " + root.unit
        color: root.textMain
        font.pixelSize: 22
        font.bold: true
        Layout.alignment: Qt.AlignVCenter
    }
}
