import QtQuick

Rectangle {
    anchors.verticalCenter: parent.verticalCenter
    color: Config.itemBackground
    implicitHeight: parent.implicitHeight
    implicitWidth: text.paintedWidth + Config.padding * 2
    radius: Config.radius
}
