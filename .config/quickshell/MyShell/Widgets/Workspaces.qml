pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import ".."

RowLayout {
    id: row

    required property ShellScreen screen

    anchors.margins: Config.margin

    Repeater {
        id: repeater

        model: {
            Hyprland.workspaces.values.filter(d => d ? d.monitor.name == row.screen.name : false);
        }

        delegate: StyledButton {
            id: btn

            required property HyprlandWorkspace modelData

            focused: modelData?.focused ?? false
            text: {
                const workspaceName = modelData ? modelData.name : "bye";
                return workspaceName.replace(/special:/, "");
            }

            onClicked: {
                if (!modelData.focused) {
                    modelData.activate();
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
