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
	property string userIcon: ""
	property string realName: ""
	property bool isQueryingAccount: false

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

	property Process accountProc: Process {
		id: accountProcess
		command: ["sh", "-c", "icon=$(busctl get-property org.freedesktop.Accounts /org/freedesktop/Accounts/User$(id -u) org.freedesktop.Accounts.User IconFile --json=short 2>/dev/null | jq -r '.data // empty'); realname=$(busctl get-property org.freedesktop.Accounts /org/freedesktop/Accounts/User$(id -u) org.freedesktop.Accounts.User RealName --json=short 2>/dev/null | jq -r '.data // empty'); if [ -z \"$icon\" ] || [ ! -f \"$icon\" ]; then if [ -f \"$HOME/.face\" ]; then icon=\"$HOME/.face\"; elif [ -f \"$HOME/.face.icon\" ]; then icon=\"$HOME/.face.icon\"; else icon=\"\"; fi; fi; printf '%s\\n%s\\n' \"$icon\" \"$realname\""]
		running: false

		stdout: StdioCollector {
			id: accountCollector
			onStreamFinished: {
				try {
					const lines = accountCollector.text.split("\n");
					const iconPath = lines.length > 0 ? lines[0].trim() : "";
					const rName = lines.length > 1 ? lines[1].trim() : "";
					if (iconPath.length > 0) {
						root.userIcon = iconPath.startsWith("/") ? ("file://" + iconPath) : iconPath;
					} else {
						root.userIcon = "";
					}
					root.realName = rName;
				} catch (e) {}
				root.isQueryingAccount = false;
			}
		}

		// qmllint disable signal-handler-parameters
		onExited: exitCode => {
			root.isQueryingAccount = false;
		}
		// qmllint enable signal-handler-parameters
	}

	function queryAccount(): void {
		if (root.isQueryingAccount || accountProcess.running)
			return;
		root.isQueryingAccount = true;
		accountProcess.running = true;
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
		root.queryAccount();
	}

	Component.onCompleted: {
		root.updateUptime();
		root.queryAccount();
	}

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
