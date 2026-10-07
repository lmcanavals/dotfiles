pragma Singleton

import QtQuick
import Quickshell.Io
import Core

QtObject {
	id: root

	property int count: 0
	property int version: -1
	property var updates: []
	property var levelCounts: ({
			major: 0,
			minor: 0,
			patch: 0,
			pre: 0,
			other: 0
		})
	property string lastUpdated: ""
	property bool isChecking: false
	property bool open: false
	property Item targetItem: null

	readonly property string glyph: "󰮯"

	function toggle(item: Item): void {
		if (root.open && root.targetItem === item) {
			root.close();
		} else {
			root.targetItem = item;
			root.open = true;
		}
	}

	function close(): void {
		root.open = false;
	}

	function levelColor(level: string): color {
		switch (level) {
		case "major":
			return Theme.colors.error;
		case "minor":
			return Theme.colors.warning;
		case "patch":
			return Theme.colors.success;
		case "pre":
			return Theme.colors.info;
		default:
			return Theme.colors.comment;
		}
	}

	function _handleJSON(line: string): void {
		const raw = line.trim();
		if (raw.length === 0)
			return;

		try {
			const parsed = JSON.parse(raw);
			if (parsed?.changed) {
				root.version = parsed.version || root.version;
				root.lastUpdated = parsed.timestamp || "";

				const rawList = Array.isArray(parsed.updates) ? parsed.updates : [];
				const list = [];
				let majors = 0;
				let minors = 0;
				let patches = 0;
				let pre = 0;
				let others = 0;

				for (let i = 0; i < rawList.length; i++) {
					const item = rawList[i];
					const level = item.level || "other";

					if (level === "major")
						majors++;
					else if (level === "minor")
						minors++;
					else if (level === "patch")
						patches++;
					else if (level === "pre")
						pre++;
					else
						others++;

					list.push({
						name: item.name || "",
						source: item.source || "pacman",
						old: item.old || "",
						unchanged: item.unchanged || "",
						changed: item.changed || "",
						level: level
					});
				}

				root.updates = list;
				root.count = list.length;
				root.levelCounts = {
					major: majors,
					minor: minors,
					patch: patches,
					pre: pre,
					other: others
				};
			}
		} catch (e) {
			console.log(`UpdatesService JSON parse error: ${e}`);
		}
		root.isChecking = false;
		checkingTimeoutTimer.stop();
	}

	property Process queryProc: Process {
		id: queryProcess
		command: ["updates-query", "-format", "json"]
		running: true

		stdout: SplitParser {
			splitMarker: "\n"
			onRead: data => root._handleJSON(data)
		}

		stderr: StdioCollector {
			id: queryErrCollector
		}

		// qmllint disable signal-handler-parameters
		onExited: (exitCode, exitStatus) => {
			if (exitCode !== 0) {
				const err = queryErrCollector.text.trim();
				if (err.length > 0) {
					console.log(`UpdatesService updates-query failed (code ${exitCode}): ${err}`);
				}
			}
			root.isChecking = false;
			checkingTimeoutTimer.stop();
			restartTimer.restart();
		}
		// qmllint enable signal-handler-parameters
	}

	property Timer restartTimer: Timer {
		id: restartTimer
		interval: 5000
		repeat: false
		onTriggered: {
			if (!queryProcess.running) {
				queryProcess.running = true;
			}
		}
	}

	property Timer checkingTimeoutTimer: Timer {
		id: checkingTimeoutTimer
		interval: 15000
		repeat: false
		onTriggered: root.isChecking = false
	}

	property Process checkNowProc: Process {
		id: checkNowProcess
		command: ["updates-query", "-check-now"]
		running: false

		stderr: StdioCollector {
			id: checkNowErr
		}

		// qmllint disable signal-handler-parameters
		onExited: (exitCode, exitStatus) => {
			if (exitCode !== 0) {
				const err = checkNowErr.text.trim();
				if (err.length > 0) {
					console.log(`UpdatesService check-now failed (code ${exitCode}): ${err}`);
				}
				root.isChecking = false;
				checkingTimeoutTimer.stop();
			}
		}
		// qmllint enable signal-handler-parameters
	}

	property Process upgradeProc: Process {
		id: upgradeProcess
		running: false
	}

	function refresh(): void {
		if (!queryProcess.running) {
			queryProcess.running = true;
		} else {
			root.checkNow();
		}
	}

	function checkNow(): void {
		if (checkNowProcess.running)
			return;
		root.isChecking = true;
		checkingTimeoutTimer.restart();
		checkNowProcess.running = true;
	}

	function triggerUpgrade(): void {
		root.close();
		upgradeProcess.command = ["kitty", "--title", "󰣇  System Upgrade", "sh", "-c", "yay; updates-query -check-now >/dev/null 2>&1; echo 'Press enter to exit'; read"];
		upgradeProcess.startDetached();
	}
}
