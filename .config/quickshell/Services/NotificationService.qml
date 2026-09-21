pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.Notifications
import Services

QtObject {
	id: root

	property var activeList: []
	property var historyList: []
	readonly property int unreadCount: historyList.length

	property NotificationServer server: NotificationServer {
		id: server
		property bool running: true
		keepOnReload: true

		onNotification: notif => {
			const rawTag = (notif.hints && (notif.hints["x-dunst-stack-tag"] || notif.hints["tag"] || notif.hints["synchronous"] || notif.hints["x-canonical-private-synchronous"])) || "";
			const tag = String(rawTag).trim();

			const rawVal = notif.hints ? notif.hints["value"] : undefined;
			const value = (rawVal !== undefined && rawVal !== null && !isNaN(Number(rawVal))) ? Number(rawVal) : -1;

			const appName = String(notif.appName || "System");
			const summary = String(notif.summary || "");
			const body = String(notif.body || "");

			let iconSrc = "";
			if (notif.image && String(notif.image).trim().length > 0) {
				iconSrc = String(notif.image).trim();
			} else if (notif.appIcon && String(notif.appIcon).trim().length > 0) {
				iconSrc = String(notif.appIcon).trim();
			} else if (notif.hints && (notif.hints["image-path"] || notif.hints["image_path"])) {
				iconSrc = String(notif.hints["image-path"] || notif.hints["image_path"]).trim();
			}

			const time = new Date().toLocaleTimeString([], {
				hour: "2-digit",
				minute: "2-digit"
			});
			const timestamp = Date.now();

			// 1. Check for match in activeList
			let activeIdx = -1;
			if (tag.length > 0) {
				activeIdx = root.activeList.findIndex(item => item && item.tag === tag);
			}
			if (activeIdx === -1) {
				activeIdx = root.activeList.findIndex(item => item && item.appName === appName && item.baseSummary === summary && item.body === body);
			}

			let itemToStore = null;

			if (activeIdx !== -1) {
				const existing = root.activeList[activeIdx];
				let displaySummary = summary;
				let count = 1;

				if (tag.length === 0) {
					count = (existing.count || 1) + 1;
					displaySummary = `(${count}) ${summary}`;
				}

				itemToStore = {
					id: notif.id,
					previousId: existing.id,
					appName: appName,
					summary: displaySummary,
					baseSummary: summary,
					body: body,
					appIcon: iconSrc.length > 0 ? iconSrc : (existing.appIcon || ""),
					tag: tag,
					count: count,
					value: value,
					time: time,
					timestamp: timestamp
				};

				const newActive = [...root.activeList];
				newActive[activeIdx] = itemToStore;
				root.activeList = newActive;
			} else {
				itemToStore = {
					id: notif.id,
					previousId: notif.id,
					appName: appName,
					summary: summary,
					baseSummary: summary,
					body: body,
					appIcon: iconSrc,
					tag: tag,
					count: 1,
					value: value,
					time: time,
					timestamp: timestamp
				};

				if (!EnvironmentService.dndActive) {
					root.activeList = [...root.activeList, itemToStore];
				}
			}

			// 2. Update historyList (deduplicate and move latest to top)
			const filteredHistory = root.historyList.filter(item => {
				if (!item)
					return false;
				if (tag.length > 0) {
					return item.tag !== tag;
				}
				return !(item.appName === appName && item.baseSummary === summary && item.body === body);
			});
			root.historyList = [itemToStore, ...filteredHistory].slice(0, 50);
		}
	}

	property Connections dndConn: Connections {
		target: EnvironmentService

		function onDndActiveChanged() {
			if (EnvironmentService.dndActive) {
				root.activeList = [];
			}
		}
	}

	function dismissActive(id: int): void {
		root.activeList = root.activeList.filter(n => n && n.id !== id && n.previousId !== id);
	}

	function clearHistory(): void {
		root.historyList = [];
	}

	function removeHistory(id: int): void {
		root.historyList = root.historyList.filter(n => n && n.id !== id && n.previousId !== id);
	}

	function invokeAction(item: var, actionId: string): void {
		if (item && item.id !== undefined) {
			root.dismissActive(item.id);
		}
	}
}
