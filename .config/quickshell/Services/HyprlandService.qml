pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Core

QtObject {
	id: root

	readonly property string activeTitle: Hyprland.activeToplevel?.title ?? ""
	property string currentSubmap: ""

	readonly property var _emptyArray: []
	readonly property var _iconCache: new Map()
	readonly property var _workspacesCache: new Map()
	readonly property var _appIconsCache: new Map()

	function _arraysEqual(a, b): bool {
		if (!a || !b || a.length !== b.length)
			return false;
		for (let i = 0; i < a.length; i++) {
			if (a[i] !== b[i])
				return false;
		}
		return true;
	}

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
			return root._emptyArray;

		const monitor = Hyprland.monitorFor(screen);
		const screenName = monitor?.name ?? screen?.name ?? (typeof screen === "string" ? screen : "");
		if (!screenName)
			return root._emptyArray;

		const next = Hyprland.workspaces.values.filter(ws => ws?.monitor?.name === screenName).slice().sort((a, b) => a.id - b.id);
		const prev = root._workspacesCache.get(screenName);
		if (root._arraysEqual(prev, next))
			return prev;

		root._workspacesCache.set(screenName, next);
		return next;
	}

	function toplevelsForWorkspace(workspace): var {
		if (!workspace)
			return root._emptyArray;
		return workspace.toplevels?.values ?? root._emptyArray;
	}

	function iconForToplevel(toplevel): string {
		if (!toplevel)
			return "";

		const rawClass = toplevel.lastIpcObject?.class ?? toplevel.lastIpcObject?.initialClass ?? toplevel.wayland?.appId ?? "";
		const appClass = String(rawClass).trim();

		if (root._iconCache.has(appClass))
			return root._iconCache.get(appClass);

		let resolved = "";
		if (!appClass) {
			resolved = Quickshell.iconPath(Config.workspaceFallbackAppIcon);
		} else {
			const overrides = Config.workspaceAppIconOverrides ?? {};
			const override = overrides[appClass] ?? overrides[appClass.toLowerCase()];
			if (override && override.length > 0) {
				resolved = Quickshell.hasThemeIcon(override) ? Quickshell.iconPath(override) : override;
			} else if (Quickshell.hasThemeIcon(appClass)) {
				resolved = Quickshell.iconPath(appClass);
			} else {
				const lower = appClass.toLowerCase();
				if (Quickshell.hasThemeIcon(lower))
					resolved = Quickshell.iconPath(lower);
				else
					resolved = Quickshell.iconPath(Config.workspaceFallbackAppIcon);
			}
		}

		root._iconCache.set(appClass, resolved);
		return resolved;
	}

	function appIconsForWorkspace(workspace): var {
		if (!workspace)
			return root._emptyArray;

		const wsKey = workspace.id !== undefined ? workspace.id : workspace;
		const toplevels = root.toplevelsForWorkspace(workspace);
		if (!toplevels || toplevels.length === 0) {
			root._appIconsCache.set(wsKey, root._emptyArray);
			return root._emptyArray;
		}

		const icons = [];
		for (let i = 0; i < toplevels.length; i++) {
			const icon = root.iconForToplevel(toplevels[i]);
			if (icon && icon.length > 0) {
				if (!Config.workspaceAppIconDeduplicate || icons.indexOf(icon) === -1)
					icons.push(icon);
			}
		}

		const prev = root._appIconsCache.get(wsKey);
		if (root._arraysEqual(prev, icons))
			return prev;

		root._appIconsCache.set(wsKey, icons);
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
