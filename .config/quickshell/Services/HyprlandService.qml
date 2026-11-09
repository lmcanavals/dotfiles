pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Core

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

	function workspacesForScreen(screen): var {
		if (!screen)
			return [];

		const monitor = Hyprland.monitorFor(screen);
		const screenName = monitor?.name ?? screen?.name ?? (typeof screen === "string" ? screen : "");
		if (!screenName)
			return [];

		return Hyprland.workspaces.values.filter(ws => ws?.monitor?.name === screenName).slice().sort((a, b) => a.id - b.id);
	}

	function toplevelsForWorkspace(workspace): var {
		if (!workspace)
			return [];
		return workspace.toplevels?.values ?? [];
	}

	function iconForToplevel(toplevel): string {
		if (!toplevel)
			return "";

		const rawClass = toplevel.lastIpcObject?.class ?? toplevel.lastIpcObject?.initialClass ?? toplevel.wayland?.appId ?? "";
		const appClass = String(rawClass).trim();
		if (!appClass)
			return Quickshell.iconPath(Config.workspaceFallbackAppIcon);

		const overrides = Config.workspaceAppIconOverrides ?? {};
		const override = overrides[appClass] ?? overrides[appClass.toLowerCase()];
		if (override && override.length > 0) {
			if (Quickshell.hasThemeIcon(override))
				return Quickshell.iconPath(override);
			return override;
		}

		if (Quickshell.hasThemeIcon(appClass))
			return Quickshell.iconPath(appClass);

		const lower = appClass.toLowerCase();
		if (Quickshell.hasThemeIcon(lower))
			return Quickshell.iconPath(lower);

		return Quickshell.iconPath(Config.workspaceFallbackAppIcon);
	}

	function appIconsForWorkspace(workspace): var {
		const toplevels = root.toplevelsForWorkspace(workspace);
		if (!toplevels || toplevels.length === 0)
			return [];

		const icons = [];
		for (let i = 0; i < toplevels.length; i++) {
			const icon = root.iconForToplevel(toplevels[i]);
			if (icon && icon.length > 0) {
				if (!Config.workspaceAppIconDeduplicate || icons.indexOf(icon) === -1)
					icons.push(icon);
			}
		}
		return icons;
	}

	function toplevelsForScreen(screen): var {
		if (!screen)
			return [];
		const monitor = Hyprland.monitorFor(screen);
		if (!monitor || !monitor.activeWorkspace)
			return [];
		return monitor.activeWorkspace.toplevels?.values ?? [];
	}

	function titleForScreen(screen): string {
		if (!screen)
			return root.activeTitle;

		const monitor = Hyprland.monitorFor(screen);
		if (!monitor || !monitor.activeWorkspace)
			return "";

		if (monitor.focused && Hyprland.activeToplevel)
			return Hyprland.activeToplevel.title ?? "";

		const toplevels = root.toplevelsForScreen(screen);
		if (toplevels.length === 0)
			return "";

		const activeClient = toplevels.find(tl => tl && tl.activated) ?? toplevels[0];
		return activeClient?.title ?? "";
	}
}
