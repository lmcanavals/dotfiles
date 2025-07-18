pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "MyShell"

RowLayout {
    id: row

    required property ShellScreen screen

    anchors.margins: Config.margin

    Repeater {
        id: repeater

        model: Hyprland.workspaces

        delegate: StyledButton {
            id: btn

            required property HyprlandWorkspace modelData

            focused: modelData?.focused ?? false
            text: modelData?.name ?? "bye"
            visible: modelData?.monitor?.name === row.screen.name

            onClicked: {
                if (!modelData.focused) {
                    modelData.activate();
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
