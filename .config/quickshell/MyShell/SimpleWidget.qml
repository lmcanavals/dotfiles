import QtQuick
import "."

Rectangle {
    color: Config.itemBackground
    implicitHeight: parent.implicitHeight
    implicitWidth: 200
    radius: Config.radius

    anchors {
        margins: Config.margin
        verticalCenter: parent.verticalCenter
    }
}
// vim: set ts=4 sw=4 et sts=0 :
