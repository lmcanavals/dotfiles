pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Core
import Primitives

RowLayout {
    id: root

    required property ShellScreen screen
    spacing: Config.spacing

    Repeater {
        model: {
            const list = Hyprland.workspaces.values.filter(ws => ws && ws.monitor && ws.monitor.name === root.screen.name);
            return list.slice().sort((a, b) => a.id - b.id);
        }

        delegate: StyledButton {
            required property HyprlandWorkspace modelData

            focused: modelData?.focused ?? false
            active: modelData?.active ?? false
            urgent: modelData?.urgent ?? false
            implicitWidth: Math.max(Config.workspaceButtonWidth, labelItem.implicitWidth + Config.padding)

            text: {
                if (!modelData) return "";
                const name = modelData.name ?? `${modelData.id ?? ""}`;
                return name.replace(/^special:/, "");
            }

            onClicked: {
                if (modelData && !modelData.focused) {
                    modelData.activate();
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
