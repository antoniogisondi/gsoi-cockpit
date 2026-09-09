import QtQuick
import "Theme.js" as T

Rectangle {
    id: b
    property string text: ""
    property bool primary: true
    signal clicked()

    implicitHeight: 42
    implicitWidth: label.implicitWidth + 44
    radius: 2
    color: b.primary
           ? (ma.pressed ? T.accent700 : T.accent)
           : (ma.pressed ? T.n300 : T.surface)
    border.width: b.primary ? 0 : 1
    border.color: T.divider

    Text {
        id: label
        anchors.centerIn: parent
        text: b.text
        font.family: T.serif
        font.pixelSize: 17
        font.weight: Font.DemiBold
        color: b.primary ? "#ffffff" : T.text
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: b.clicked()
    }
}
