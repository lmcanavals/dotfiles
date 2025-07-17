import QtQuick
import "."

Rectangle {
    required property var textContent

    anchors {
        verticalCenter: parent.verticalCenter
        margins: Config.margin
    }
    color: Config.itemBackground
    implicitHeight: parent.implicitHeight
    implicitWidth: textContent.paintedWidth + Config.padding * 2
    radius: Config.radius
}
