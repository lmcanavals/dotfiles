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
			const list = Hyprland.workspaces.values.filter(ws => ws && ws.monitor?.name === root.screen?.name);
			return list.slice().sort((a, b) => a.id - b.id);
		}

		delegate: StyledButton {
			required property HyprlandWorkspace modelData

			minWidth: Config.workspaceButtonWidth
			bg: modelData?.focused ? Theme.colors.bg_widget_r : modelData?.urgent ? Theme.colors.accent_dim : modelData?.active ? Theme.colors.bg_highlight : Theme.colors.bg_widget
			fg: modelData?.focused ? Theme.colors.fg_widget_r : Theme.colors.fg_widget

			text: {
				if (!modelData)
					return "";
				const name = modelData.name ?? `${modelData.id ?? ""}`;
				return name.replace(/^special:/, "");
			}

			onClicked: (modelData && !modelData.focused) && modelData.activate()
		}
	}
}
