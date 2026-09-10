import QtQuick
import Core
import Primitives

SurfaceCard {
    id: root

    implicitWidth: label.implicitWidth + Config.padding * 2
    implicitHeight: Config.widgetHeight

    StyledText {
        id: label

        anchors.centerIn: parent
        text: Config.osIcon
        color: Theme.colors.accent
        font.bold: true
        font.pixelSize: 14
    }
}
