pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Services

QtObject {
	id: root

	readonly property string username: Quickshell.env("USER") || "unknown"
	readonly property string hostname: hostFile.text().trim() || Quickshell.env("HOSTNAME") || "unknown"
	property string uptime: "..."

	property FileView hostFile: FileView {
		path: "/etc/hostname"
		blockLoading: true
	}

	property FileView uptimeFile: FileView {
		id: procUptime
		path: "/proc/uptime"
		blockLoading: true

		onLoaded: root.updateUptime()
	}

	function formatUptime(totalSeconds: real): string {
		const days = Math.floor(totalSeconds / 86400);
		const hours = Math.floor((totalSeconds % 86400) / 3600);
		const minutes = Math.floor((totalSeconds % 3600) / 60);

		if (days > 0)
			return `${days}d ${hours}h ${minutes}m`;
		if (hours > 0)
			return `${hours}h ${minutes}m`;
		return `${minutes}m`;
	}

	function updateUptime(): void {
		const raw = procUptime.text().trim();
		if (raw.length > 0) {
			const parts = raw.split(" ");
			const sec = parseFloat(parts[0]);
			if (!isNaN(sec)) {
				root.uptime = root.formatUptime(sec);
			}
		}
	}

	function refresh(): void {
		procUptime.reload();
	}

	Component.onCompleted: root.updateUptime()

	property Timer pollTimer: Timer {
		interval: 60000
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
}
