pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell.Hyprland

QtObject {
	id: root

	property string activeLayout: "English (US)"
	property string shortLayout: "US"

	function deriveShort(layout: string): string {
		if (!layout || layout.length === 0)
			return "US";
		const lower = layout.toLowerCase();
		if (lower.includes("dvorak"))
			return "DV";
		if (lower.includes("spanish") || lower.includes("latam") || lower.includes("es") || lower.includes("español"))
			return "ES";
		if (lower.includes("english") || lower.includes("us") || lower.includes("intl"))
			return "US";
		if (lower.includes("german") || lower.includes("deutsch"))
			return "DE";
		if (lower.includes("french") || lower.includes("français"))
			return "FR";
		if (lower.includes("russian"))
			return "RU";
		if (lower.includes("japanese"))
			return "JP";
		return layout.slice(0, 2).toUpperCase();
	}

	function updateLayout(name: string): void {
		if (!name || name.length === 0)
			return;
		root.activeLayout = name;
		root.shortLayout = root.deriveShort(name);
	}

	property Connections ipcConn: Connections {
		target: Hyprland

		function onRawEvent(event) {
			if (event.name === "activelayout") {
				const parts = event.parse(2);
				if (parts && parts.length > 1) {
					root.updateLayout(parts[1].trim());
				} else if (parts && parts.length > 0) {
					root.updateLayout(parts[0].trim());
				}
			}
		}
	}

	property Process queryProc: Process {
		id: queryProcess
		command: ["hyprctl", "devices", "-j"]
		running: false

		stdout: StdioCollector {
			onStreamFinished: {
				try {
					const raw = this.text.trim();
					if (raw.length === 0)
						return;
					const parsed = JSON.parse(raw);
					if (!parsed || !Array.isArray(parsed.keyboards))
						return;

					const kbs = parsed.keyboards;
					const mainKb = kbs.find(k => k && k.main) || kbs[0];
					if (mainKb && mainKb.active_keymap) {
						root.updateLayout(mainKb.active_keymap);
					}
				} catch (e) {
					// Ignore parse error
				}
			}
		}
	}

	property Process switchProc: Process {
		id: switchProcess
		command: ["hyprctl", "switchxkblayout", "current", "next"]
		running: false
	}

	function nextLayout(): void {
		switchProcess.command = ["hyprctl", "switchxkblayout", "current", "next"];
		switchProcess.startDetached();
	}

	Component.onCompleted: {
		queryProcess.running = true;
	}
}
// vim: set ts=4 sw=4 et sts=0 :
