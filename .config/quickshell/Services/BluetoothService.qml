pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
	id: root

	property bool enabled: false
	property bool connected: false
	property string connectedDevice: ""
	property string glyph: "󰂲"

	property Process statusProc: Process {
		id: poller
		command: ["sh", "-c", "powered=$(bluetoothctl show | grep -i 'Powered:' | awk '{print $2}'); " + "device=$(bluetoothctl devices Connected | head -n1 | cut -d' ' -f3-); " + "echo \"$powered|$device\""]
		running: false

		stdout: StdioCollector {
			onStreamFinished: {
				const out = this.text.trim();
				if (!out)
					return;

				const parts = out.split("|");
				const power = parts[0] || "no";
				const dev = parts[1] || "";

				root.enabled = (power.toLowerCase() === "yes");
				root.connectedDevice = dev;
				root.connected = (dev.length > 0);

				if (!root.enabled) {
					root.glyph = "󰂲";
				} else if (!root.connected) {
					root.glyph = "󰂯";
				} else {
					root.glyph = "󰂱";
				}
			}
		}
	}

	property Process toggleProc: Process {
		running: false
		// qmllint disable signal-handler-parameters
		onExited: exitCode => {
			root.refresh();
		}
		// qmllint enable signal-handler-parameters
	}

	property Process pickerProc: Process {
		command: ["blueman-manager"]
		running: false
	}

	property Timer pollTimer: Timer {
		interval: 4000
		repeat: true
		running: QuickSettingsService.open
		triggeredOnStart: true
		onTriggered: root.refresh()
	}

	property Connections openWatcher: Connections {
		target: QuickSettingsService
		function onOpenChanged() {
			if (QuickSettingsService.open) {
				root.refresh();
			}
		}
	}

	Component.onCompleted: root.refresh()

	function refresh(): void {
		if (!poller.running) {
			poller.running = true;
		}
	}

	function toggleBluetooth(): void {
		const next = !root.enabled;
		root.enabled = next; // Optimistic update
		toggleProc.command = ["bluetoothctl", "power", next ? "on" : "off"];
		toggleProc.running = true;
	}

	function openPicker(): void {
		QuickSettingsService.close();
		if (!pickerProc.running) {
			pickerProc.running = true;
		}
	}
}
