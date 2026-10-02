pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Services

QtObject {
	id: root

	readonly property string username: Quickshell.env("USER") || "unknown"
	property string hostname: Quickshell.env("HOSTNAME") || "unknown"
	property string uptime: "..."
	property string userIcon: ""
	property string realName: ""
	property bool isQueryingAccount: false

	property FileView hostFile: FileView {
		path: "/etc/hostname"
		onLoaded: {
			const text = this.text().trim();
			if (text.length > 0)
				root.hostname = text;
		}
	}

	property FileView uptimeFile: FileView {
		id: procUptime
		path: "/proc/uptime"

		onLoaded: root.updateUptime()
	}

	readonly property string uid: {
		const runtimeDir = Quickshell.env("XDG_RUNTIME_DIR") || "";
		const match = runtimeDir.match(/\/run\/user\/(\d+)/);
		return match ? match[1] : "1000";
	}

	property Process accountProc: Process {
		id: accountProcess
		command: ["busctl", "get-property", "--json=short", "org.freedesktop.Accounts", "/org/freedesktop/Accounts/User" + root.uid, "org.freedesktop.Accounts.User", "IconFile", "RealName"]
		running: false

		stdout: StdioCollector {
			id: accountCollector
			onStreamFinished: {
				try {
					const lines = accountCollector.text.trim().split("\n");
					let iconPath = "";
					let rName = "";

					if (lines.length > 0 && lines[0].trim().length > 0) {
						const iconObj = JSON.parse(lines[0]);
						if (iconObj && typeof iconObj.data === "string") {
							iconPath = iconObj.data.trim();
						}
					}

					if (lines.length > 1 && lines[1].trim().length > 0) {
						const nameObj = JSON.parse(lines[1]);
						if (nameObj && typeof nameObj.data === "string") {
							rName = nameObj.data.trim();
						}
					}

					if (iconPath.length > 0) {
						root.userIcon = iconPath.startsWith("/") ? ("file://" + iconPath) : iconPath;
					} else {
						const home = Quickshell.env("HOME") || "";
						root.userIcon = home.length > 0 ? ("file://" + home + "/.face") : "";
					}
					root.realName = rName;
				} catch (e) {
					console.log(`Error on SystemInfoService ${accountProcess.command}: ${e}`);
				}
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
}
