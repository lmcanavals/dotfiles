pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Core
import Services
import Primitives

SurfaceCard {
    id: root

    property ShellScreen screen: null

    readonly property string titleText: {
        if (!root.screen)
            return HyprlandService.activeTitle;

        const monitor = Hyprland.monitorFor(root.screen);
        if (!monitor || !monitor.activeWorkspace)
            return "";

        if (monitor.focused && Hyprland.activeToplevel)
            return Hyprland.activeToplevel.title ?? "";

        const toplevels = monitor.activeWorkspace.toplevels?.values ?? [];
        if (toplevels.length === 0)
            return "";

        const activeClient = toplevels.find(tl => tl && tl.activated) || toplevels[0];
        return activeClient?.title ?? "";
    }

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
    }
}
// vim: set ts=4 sw=4 et sts=0 :
