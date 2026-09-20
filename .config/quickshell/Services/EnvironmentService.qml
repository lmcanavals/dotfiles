pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell.Wayland

QtObject {
	id: root

	// --- Idle Inhibitor (Wayland Protocol Native) ---
	property bool idleInhibited: false
	property IdleInhibitor inhibitor: IdleInhibitor {
		enabled: root.idleInhibited
	}

	function toggleIdleInhibit(): void {
		root.idleInhibited = !root.idleInhibited;
	}

	// --- Do Not Disturb (Native Quickshell) ---
	property bool dndActive: false

	function toggleDnd(): void {
		root.dndActive = !root.dndActive;
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

	// --- Session Lock Execution ---
	property Process lockProc: Process {
		command: ["loginctl", "lock-session"]
		running: false
	}

	function lockSession(): void {
		if (!lockProc.running) {
			lockProc.running = true;
		}
	}
}
