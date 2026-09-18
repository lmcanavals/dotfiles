pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Services

QtObject {
	id: root

	readonly property string gitDir: (Quickshell.env("HOME") ?? "") + "/.dotfiles.git"
	readonly property string workTree: Quickshell.env("HOME") ?? ""

	property string branch: "main"
	property int ahead: 0
	property int behind: 0
	property int staged: 0
	property int modified: 0
	property int untracked: 0

	readonly property bool isDiverged: (root.ahead > 0 && root.behind > 0)
	readonly property bool isClean: (root.ahead === 0 && root.behind === 0 && root.staged === 0 && root.modified === 0 && root.untracked === 0)

	property Process statusProc: Process {
		id: statusProcess
		command: ["git", `--git-dir=${root.gitDir}`, `--work-tree=${root.workTree}`, "status", "-u", "--porcelain=v1", "--branch"]
		running: false

		stdout: StdioCollector {
			onStreamFinished: {
				const text = this.text;
				if (!text || text.trim().length === 0) {
					root.ahead = 0;
					root.behind = 0;
					root.staged = 0;
					root.modified = 0;
					root.untracked = 0;
					return;
				}

				const lines = text.split("\n").map(l => l.replace(/\s+$/, "")).filter(l => l.length > 0);
				if (lines.length === 0)
					return;

				let parsedBranch = "main";
				let parsedAhead = 0;
				let parsedBehind = 0;
				let parsedStaged = 0;
				let parsedModified = 0;
				let parsedUntracked = 0;

				// Line 0 contains branch tracking info: e.g. "## main...origin/main [ahead 1, behind 2]"
				if (lines[0].startsWith("## ")) {
					const rest = lines[0].slice(3).trim();
					const bMatch = rest.match(/^([^\.\s]+)/);
					if (bMatch) {
						parsedBranch = bMatch[1];
					}
					const aheadMatch = rest.match(/ahead\s+(\d+)/);
					if (aheadMatch) {
						parsedAhead = parseInt(aheadMatch[1], 10);
					}
					const behindMatch = rest.match(/behind\s+(\d+)/);
					if (behindMatch) {
						parsedBehind = parseInt(behindMatch[1], 10);
					}
				}

				// Subsequent lines contain file changes
				for (let i = 1; i < lines.length; i++) {
					const line = lines[i];
					if (!line || line.length < 2)
						continue;

					const x = line[0];
					const y = line[1];

					if (x === "?" && y === "?") {
						parsedUntracked++;
					} else {
						if (x !== " " && x !== "?") {
							parsedStaged++;
						}
						if (y === "M" || y === "D") {
							parsedModified++;
						}
					}
				}

				root.branch = parsedBranch;
				root.ahead = parsedAhead;
				root.behind = parsedBehind;
				root.staged = parsedStaged;
				root.modified = parsedModified;
				root.untracked = parsedUntracked;
			}
		}
	}

	property Process lazygitProc: Process {
		id: lazygitProcess
		running: false
	}

	function refresh(): void {
		if (!statusProcess.running) {
			statusProcess.running = true;
		}
	}

	function openLazygit(): void {
		QuickSettingsService.close();
		lazygitProcess.command = ["kitty", "--title", "  Lazygit: dotfiles", "lazygit", `--git-dir=${root.gitDir}`, `--work-tree=${root.workTree}`];
		lazygitProcess.startDetached();
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
}
