pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
	id: root

	property bool enabled: false
	property bool connected: false
	property string connectedDevice: ""
	property string glyph: "󰂲"
	readonly property bool busy: toggleProc.running

	property Process statusProc: Process {
		id: poller
		command: ["bluetoothctl", "show"]
		running: false

		stdout: StdioCollector {
			onStreamFinished: {
				const out = this.text;
				if (!out) {
					root.enabled = false;
					root.connected = false;
					root.connectedDevice = "";
					root.glyph = "󰂲";
					return;
				}

				const match = out.match(/^\s*Powered:\s*(\w+)/m);
				const isPowered = match ? (match[1].toLowerCase() === "yes") : false;

				root.enabled = isPowered;

				if (!isPowered) {
					root.connected = false;
					root.connectedDevice = "";
					root.glyph = "󰂲";
					return;
				}

				if (!devicesPoller.running) {
					devicesPoller.running = true;
				}
			}
		}
	}

	property Process devicesProc: Process {
		id: devicesPoller
		command: ["bluetoothctl", "devices", "Connected"]
		running: false

		stdout: StdioCollector {
			onStreamFinished: {
				const out = this.text.trim();
				if (!out) {
					root.connected = false;
					root.connectedDevice = "";
					root.glyph = "󰂯";
					return;
				}

				const firstLine = out.split("\n")[0].trim();
				const match = firstLine.match(/^Device\s+([0-9A-Fa-f:]+)(?:\s+(.+))?$/);
				const devName = match ? (match[2] ? match[2].trim() : match[1]) : "";

				root.connectedDevice = devName;
				root.connected = (devName.length > 0);
				root.glyph = root.connected ? "󰂱" : "󰂯";
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

	property bool active: false

	property Timer pollTimer: Timer {
		interval: 4000
		repeat: true
		running: root.active
		triggeredOnStart: true
		onTriggered: root.refresh()
	}

	Component.onCompleted: root.refresh()

	function refresh(): void {
		if (!poller.running) {
			poller.running = true;
		}
	}

	function toggleBluetooth(): void {
		if (toggleProc.running)
			return;
		const next = !root.enabled;
		root.enabled = next; // Optimistic update
		toggleProc.command = ["bluetoothctl", "power", next ? "on" : "off"];
		toggleProc.running = true;
	}

	function openPicker(): void {
		if (!pickerProc.running) {
			pickerProc.running = true;
		}
	}
}
