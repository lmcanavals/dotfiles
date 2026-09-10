import QtQuick
import QtQuick.Layouts
import Core
import Services
import Primitives

SurfaceCard {
    id: root

    readonly property string titleText: HyprlandService.activeTitle

    visible: titleText.length > 0
    implicitHeight: Config.widgetHeight

    Layout.fillWidth: true
    Layout.minimumWidth: 60
    Layout.maximumWidth: 550

    StyledText {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Config.padding
        width: Math.max(0, parent.width - Config.padding * 2)
        text: root.titleText
        elide: Text.ElideRight
        color: Theme.colors.fg_dark
    }
}
// vim: set ts=4 sw=4 et sts=0 :
