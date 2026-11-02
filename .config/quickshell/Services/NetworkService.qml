pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
	id: root

	// Wi-Fi properties
	property bool enabled: false
	property bool connected: false
	property string ssid: ""
	property string wifiDevice: ""
	readonly property bool wifiEnabled: enabled
	readonly property bool wifiConnected: connected
	readonly property string wifiGlyph: !enabled ? "󰤮" : (!connected ? "󰤫" : "󰤨")

	// Ethernet properties
	property bool hasEthernet: false
	property bool ethernetConnected: false
	property string ethernetDevice: ""
	property string ethernetName: "Ethernet"
	property string ethernetGlyph: ethernetConnected ? "󰈀" : "󰈁"

	// Combined telemetry & status
	property string primaryConnectionType: "none" // "dual", "ethernet", "wifi", "none"
	property string glyph: "󰤮"
	property string label: "Disconnected"

	readonly property bool busy: toggleProcess.running
	readonly property bool ethernetBusy: ethToggleProcess.running

	function _splitNmcli(line: string): var {
		const parts = [];
		let cur = "";
		let i = 0;
		while (i < line.length) {
			if (line[i] === "\\" && i + 1 < line.length && line[i + 1] === ":") {
				cur += ":";
				i += 2;
			} else if (line[i] === ":") {
				parts.push(cur);
				cur = "";
				i += 1;
			} else {
				cur += line[i];
				i += 1;
			}
		}
		parts.push(cur);
		return parts;
	}

	// Primary poller for NetworkManager radio, Wi-Fi, and Ethernet devices
	property Process statusProc: Process {
		id: poller
		command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION,DEVICE", "dev"]
		running: false

		stdout: StdioCollector {
			onStreamFinished: {
				const out = this.text.trim();
				if (!out)
					return;

				let wifiFound = false;
				let isWifiEnabled = false;
				let isWifiConnected = false;
				let activeSsid = "";
				let wDevice = "";

				let ethFound = false;
				let isEthConnected = false;
				let ethConnName = "";
				let eDevice = "";

				const lines = out.split("\n");
				for (let i = 0; i < lines.length; i++) {
					const line = lines[i].trim();
					if (!line)
						continue;
					const parts = root._splitNmcli(line);
					if (parts.length < 2)
						continue;

					const type = parts[0];
					const state = parts[1];
					const connName = parts.length > 2 ? parts[2].trim() : "";
					const devName = parts.length > 3 ? parts[3].trim() : "";

					if (type === "wifi") {
						wifiFound = true;
						wDevice = devName;
						isWifiEnabled = (state !== "unavailable" && state !== "unmanaged");
						isWifiConnected = (state === "connected" && connName.length > 0);
						if (isWifiConnected) {
							activeSsid = connName;
						}
					} else if (type === "ethernet") {
						ethFound = true;
						if (devName.length > 0 && !eDevice) {
							eDevice = devName;
						}
						if (state === "connected") {
							isEthConnected = true;
							ethConnName = connName.length > 0 ? connName : (devName || "Wired");
							eDevice = devName;
						}
					}
				}

				// Update Wi-Fi state
				if (wifiFound) {
					root.enabled = isWifiEnabled;
					root.connected = isWifiConnected;
					root.ssid = activeSsid;
					root.wifiDevice = wDevice;
				} else {
					root.enabled = false;
					root.connected = false;
					root.ssid = "";
					root.wifiDevice = "";
				}

				// Update Ethernet state
				root.hasEthernet = ethFound;
				root.ethernetConnected = isEthConnected;
				root.ethernetDevice = eDevice;
				root.ethernetName = isEthConnected ? (ethConnName.length > 0 ? ethConnName : "Wired") : "Ethernet";
				root.ethernetGlyph = isEthConnected ? "󰈀" : "󰈁";

				// Update primary connection type & overall telemetry
				if (root.ethernetConnected && root.connected) {
					root.primaryConnectionType = "dual";
					root.glyph = "󰈀";
					root.label = `${root.ethernetName} + ${root.ssid}`;
				} else if (root.ethernetConnected) {
					root.primaryConnectionType = "ethernet";
					root.glyph = "󰈀";
					root.label = root.ethernetName;
				} else if (root.connected) {
					root.primaryConnectionType = "wifi";
					root.glyph = "󰤨";
					root.label = root.ssid;
				} else if (root.enabled) {
					root.primaryConnectionType = "none";
					root.glyph = root.hasEthernet ? "󰈁" : "󰤫";
					root.label = "Disconnected";
				} else {
					root.primaryConnectionType = "none";
					root.glyph = root.hasEthernet ? "󰈁" : "󰤮";
					root.label = root.hasEthernet ? "Disconnected" : "Wi-Fi Off";
				}
			}
		}
	}

	// Setter for Wi-Fi radio state
	property Process toggleProc: Process {
		id: toggleProcess
		running: false
		onExited: exitCode => {
			root.refresh();
		}
	}

	// Setter for Ethernet device state
	property Process ethernetToggleProc: Process {
		id: ethToggleProcess
		running: false
		onExited: exitCode => {
			root.refresh();
		}
	}

	// Launch external helper (networkmanager-dmenu)
	property Process dmenuProc: Process {
		command: ["networkmanager_dmenu"]
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

	function toggleWifi(): void {
		if (toggleProcess.running)
			return;
		const next = !root.enabled;
		root.enabled = next; // Optimistic update
		toggleProcess.command = ["nmcli", "radio", "wifi", next ? "on" : "off"];
		toggleProcess.running = true;
	}

	function toggleEthernet(): void {
		if (ethToggleProcess.running || !root.ethernetDevice || root.ethernetDevice.length === 0)
			return;
		if (root.ethernetConnected) {
			ethToggleProcess.command = ["nmcli", "device", "disconnect", root.ethernetDevice];
		} else {
			ethToggleProcess.command = ["nmcli", "device", "connect", root.ethernetDevice];
		}
		ethToggleProcess.running = true;
	}

	function openPicker(): void {
		if (!dmenuProc.running) {
			dmenuProc.running = true;
		}
	}
}
