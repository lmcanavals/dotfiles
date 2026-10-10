pragma Singleton

import QtQuick
import Quickshell.Hyprland

QtObject {
	id: root

	readonly property string activeTitle: Hyprland.activeToplevel?.title ?? ""
	property string currentSubmap: ""

	property Connections ipcConn: Connections {
		target: Hyprland

		function onRawEvent(event) {
			if (event.name === "submap") {
				const parts = event.parse(1);
				root.currentSubmap = (parts?.length > 0) ? parts[0].trim() : "";
			}
		}
	}

	function titleForScreen(screen): string {
		if (!screen)
			return root.activeTitle;

		const monitor = Hyprland.monitorFor(screen);
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
}
