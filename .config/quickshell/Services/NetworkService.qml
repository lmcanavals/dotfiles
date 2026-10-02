pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
	id: root

	property bool enabled: false
	property bool connected: false
	property string ssid: ""
	property string glyph: "󰤮"

	// Primary poller for NetworkManager radio and active Wi-Fi connection
	property Process statusProc: Process {
		id: poller
		command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "dev"]
		running: false

		stdout: StdioCollector {
			onStreamFinished: {
				const out = this.text.trim();
				if (!out)
					return;

				let wifiFound = false;
				let isEnabled = false;
				let isConnected = false;
				let activeSsid = "";

				const lines = out.split("\n");
				for (let i = 0; i < lines.length; i++) {
					const line = lines[i];
					if (line.startsWith("wifi:")) {
						wifiFound = true;
						const match = line.match(/^wifi:([^:]+):?(.*)$/);
						if (match) {
							const state = match[1];
							const rawConn = match[2] || "";
							activeSsid = rawConn.replace(/\\:/g, ":").trim();
							isEnabled = (state !== "unavailable" && state !== "unmanaged");
							isConnected = (state === "connected" && activeSsid.length > 0);
						}
						break;
					}
				}

				if (!wifiFound) {
					root.enabled = false;
					root.connected = false;
					root.ssid = "";
					root.glyph = "󰤮";
					return;
				}

				root.enabled = isEnabled;
				root.ssid = isConnected ? activeSsid : "";
				root.connected = isConnected;

				if (!root.enabled) {
					root.glyph = "󰤮";
				} else if (!root.connected) {
					root.glyph = "󰤫";
				} else {
					root.glyph = "󰤨";
				}
			}
		}
	}

	// Setter for Wi-Fi radio state
	property Process toggleProc: Process {
		running: false
		// qmllint disable signal-handler-parameters
		onExited: exitCode => {
			root.refresh();
		}
		// qmllint enable signal-handler-parameters
	}

	// Launch external helper (networkmanager-dmenu)
	property Process dmenuProc: Process {
		command: ["networkmanager_dmenu"]
		running: false
	}

	property Timer pollTimer: Timer {
		interval: 4000
		repeat: true
		running: QuickSettingsService.open
		triggeredOnStart: true
		onTriggered: root.refresh()
	}

	Component.onCompleted: root.refresh()

	function refresh(): void {
		if (!poller.running) {
			poller.running = true;
		}
	}

	function toggleWifi(): void {
		const next = !root.enabled;
		root.enabled = next; // Optimistic update
		toggleProc.command = ["nmcli", "radio", "wifi", next ? "on" : "off"];
		toggleProc.running = true;
	}

	function openPicker(): void {
		QuickSettingsService.close();
		if (!dmenuProc.running) {
			dmenuProc.running = true;
		}
	}
}
