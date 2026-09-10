import QtQuick
import Core
import Services
import Primitives

SurfaceCard {
    id: root

    implicitWidth: label.implicitWidth + Config.padding * 2
    implicitHeight: Config.widgetHeight

    StyledText {
        id: label

        anchors.centerIn: parent
        text: BinaryClockService.timeString
        color: Theme.colors.accent_alt
        font.pixelSize: 11
    }
}
// vim: set ts=4 sw=4 et sts=0 :
