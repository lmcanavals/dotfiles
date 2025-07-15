import QtQuick
import "MyShell"

Rectangle {
    required property var textContent
    anchors.verticalCenter: parent.verticalCenter
    color: Config.itemBackground
    implicitHeight: parent.implicitHeight
    implicitWidth: textContent.paintedWidth + Config.padding * 2
    radius: Config.radius
}
