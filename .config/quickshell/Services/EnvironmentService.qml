pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
	id: root

	// --- Idle Inhibitor State (Wayland Protocol Native) ---
	// Consumed by Surfaces/WaylandIntegrations.qml
	property bool idleInhibited: false

	function toggleIdleInhibit(): void {
		root.idleInhibited = !root.idleInhibited;
	}

	// --- Night Light Hyprsunset IPC ---
	// TODO: figure out a way to detect if this thing is on
	property bool nightLightActive: true

	property Process nightLightSetter: Process {
		running: false
	}

	function toggleNightLight(): void {
		root.nightLightActive = !root.nightLightActive;
		if (root.nightLightActive) {
			nightLightSetter.command = ["hyprctl", "hyprsunset", "reset"];
		} else {
			nightLightSetter.command = ["hyprctl", "hyprsunset", "identity"];
		}
		nightLightSetter.running = true;
	}
}
