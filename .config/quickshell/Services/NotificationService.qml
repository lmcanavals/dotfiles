pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

QtObject {
	id: root

	property bool dndActive: false

	function toggleDnd(): void {
		root.dndActive = !root.dndActive;
	}

	onDndActiveChanged: {
		if (root.dndActive) {
			const cachedFiles = [];
			for (let i = 0; i < activeListModel.count; i++) {
				const it = activeListModel.get(i);
				if (it) {
					if (it.cachedFile)
						cachedFiles.push(it.cachedFile);
					if (it.rawNotif) {
						try {
							it.rawNotif.expire();
						} catch (e) {}
					}
				}
			}
			activeListModel.clear();
			for (let i = 0; i < cachedFiles.length; i++) {
				root._safeUnlinkIcon(cachedFiles[i]);
			}
		}
	}

	property ListModel activeList: ListModel {
		id: activeListModel
	}
	property var historyList: []
	readonly property int unreadCount: historyList.length

	readonly property string iconCacheDir: {
		const xdg = Quickshell.env("XDG_CACHE_HOME");
		const base = (xdg && xdg.length > 0) ? xdg : (Quickshell.env("HOME") + "/.cache");
		return base + "/quickshell/notification-icons";
	}

	property Timer cachePruneTimer: Timer {
		interval: 86400000 // 24 hours
		repeat: true
		running: true
		onTriggered: Quickshell.execDetached(["find", root.iconCacheDir, "-type", "f", "-mtime", "+3", "-delete"])
	}

	Component.onCompleted: {
		Quickshell.execDetached(["mkdir", "-p", root.iconCacheDir]);
		Quickshell.execDetached(["find", root.iconCacheDir, "-type", "f", "-mtime", "+3", "-delete"]);
	}

	function _isCachedFileInActive(path: string): bool {
		if (!path || path.length === 0)
			return false;
		for (let i = 0; i < activeListModel.count; i++) {
			const it = activeListModel.get(i);
			if (it && it.cachedFile === path)
				return true;
		}
		return false;
	}

	function _isCachedFileInHistory(path: string): bool {
		if (!path || path.length === 0)
			return false;
		for (let i = 0; i < root.historyList.length; i++) {
			const it = root.historyList[i];
			if (it && it.cachedFile === path)
				return true;
		}
		return false;
	}

	function _safeUnlinkIcon(path: string): void {
		if (!path || path.length === 0)
			return;
		if (!_isCachedFileInActive(path) && !_isCachedFileInHistory(path)) {
			Quickshell.execDetached(["rm", "-f", path]);
		}
	}

	function _findActiveIndex(id: int): int {
		for (let i = 0; i < activeListModel.count; i++) {
			const it = activeListModel.get(i);
			if (it && (it.id === id || it.previousId === id))
				return i;
		}
		return -1;
	}

	function _removeActiveAt(idx: int): void {
		if (idx < 0 || idx >= activeListModel.count)
			return;
		const item = activeListModel.get(idx);
		const cachedFile = item ? item.cachedFile : "";
		activeListModel.remove(idx);
		root._safeUnlinkIcon(cachedFile);
	}

	function sanitizeNotificationText(text: string): string {
		if (!text || text.length === 0)
			return "";
		let clean = text;
		// Strip leading HTML anchors like <a href="...">origin</a>
		clean = clean.replace(/^\s*<a\s+[^>]*href=["'][^"']*["'][^>]*>[^<]*<\/a>[\s\r\n]*/i, "");
		// Strip leading origin domain headers (e.g. "mail.google.com\n\n")
		clean = clean.replace(/^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(?::\d+)?[\s\r\n]+/i, "");
		return clean.trim();
	}

	function sanitizeAndCacheIcon(rawIcon: string, notifId: int): var {
		if (!rawIcon || rawIcon.length === 0) {
			return {
				source: "",
				cachedFile: ""
			};
		}

		let clean = rawIcon.trim().replace(/^image:\/\/icon\/(file:\/\/)?/, "").replace(/^file:\/\//, "");

		const isTemp = clean.startsWith("/tmp/") || clean.startsWith("/var/tmp/") || clean.startsWith("/run/user/");
		if (!isTemp) {
			return {
				source: rawIcon.trim(),
				cachedFile: ""
			};
		}

		const lastDot = clean.lastIndexOf(".");
		const ext = (lastDot !== -1 && lastDot > clean.lastIndexOf("/")) ? clean.substring(lastDot) : ".png";
		const safeExt = /^\.[a-zA-Z0-9]+$/.test(ext) ? ext : ".png";
		const destFile = root.iconCacheDir + "/" + notifId + "_" + Date.now() + safeExt;

		Quickshell.execDetached(["cp", clean, destFile]);

		return {
			source: "file://" + destFile,
			cachedFile: destFile
		};
	}

	property NotificationServer server: NotificationServer {
		id: server
		property bool running: true
		keepOnReload: true
		persistenceSupported: true
		bodySupported: true
		bodyMarkupSupported: true
		bodyHyperlinksSupported: true
		bodyImagesSupported: true
		actionsSupported: true
		actionIconsSupported: true
		imageSupported: true
		inlineReplySupported: true

		onNotification: notif => {
			// Mark tracked immediately to prevent C++ from discarding/closing it
			notif.tracked = true;

			const rawTag = (notif.hints && (notif.hints["x-dunst-stack-tag"] || notif.hints["tag"] || notif.hints["synchronous"] || notif.hints["x-canonical-private-synchronous"])) || "";
			const tag = String(rawTag).trim();

			const rawVal = notif.hints ? notif.hints["value"] : undefined;
			const value = (rawVal !== undefined && rawVal !== null && !isNaN(Number(rawVal))) ? Number(rawVal) : -1;

			const appName = String(notif.appName || "System");
			const summary = root.sanitizeNotificationText(String(notif.summary || ""));
			const body = root.sanitizeNotificationText(String(notif.body || ""));

			let iconSrc = "";
			if (notif.image && String(notif.image).trim().length > 0) {
				iconSrc = String(notif.image).trim();
			} else if (notif.appIcon && String(notif.appIcon).trim().length > 0) {
				iconSrc = String(notif.appIcon).trim();
			} else if (notif.hints && (notif.hints["image-path"] || notif.hints["image_path"])) {
				iconSrc = String(notif.hints["image-path"] || notif.hints["image_path"]).trim();
			}

			// Extract actions info
			let hasDefaultAction = false;
			const activeActions = [];
			const historyActions = [];

			// qmllint disable unresolved-type
			if (notif.actions && notif.actions.length > 0) {
				for (let i = 0; i < notif.actions.length; i++) {
					const act = notif.actions[i];
					if (!act)
						continue;
					const idStr = String(act.identifier || "");
					const textStr = String(act.text || idStr);

					if (idStr === "default") {
						hasDefaultAction = true;
					} else {
						activeActions.push({
							id: idStr,
							text: textStr
						});
						historyActions.push({
							id: idStr,
							text: textStr
						});
					}
				}

				if (!hasDefaultAction && notif.actions.length > 0) {
					const first = notif.actions[0];
					if (first && (first.identifier === "" || first.identifier === "0")) {
						hasDefaultAction = true;
					}
				}
			}
			// qmllint enable unresolved-type

			// Extract inline reply
			const hasInlineReply = Boolean(notif.hasInlineReply);
			const replyPlaceholder = String(notif.inlineReplyPlaceholder || "Type a reply...");

			const time = new Date().toLocaleTimeString([], {
				hour: "2-digit",
				minute: "2-digit"
			});
			const timestamp = Date.now();

			// 1. Check for match in activeList
			let activeIdx = -1;
			if (tag.length > 0) {
				for (let i = 0; i < activeListModel.count; i++) {
					const item = activeListModel.get(i);
					if (item && item.tag === tag) {
						activeIdx = i;
						break;
					}
				}
			}
			if (activeIdx === -1) {
				for (let i = 0; i < activeListModel.count; i++) {
					const item = activeListModel.get(i);
					if (item && item.appName === appName && item.baseSummary === summary && item.body === body) {
						activeIdx = i;
						break;
					}
				}
			}

			let itemToStore = null;

			if (activeIdx !== -1) {
				const existing = activeListModel.get(activeIdx);
				// Dismiss the older notification instance that is being replaced
				if (existing && existing.rawNotif && existing.rawNotif !== notif) {
					try {
						existing.rawNotif.dismiss();
					} catch (e) {}
				}

				let displaySummary = summary;
				let count = 1;

				if (tag.length === 0) {
					count = (existing.count || 1) + 1;
					displaySummary = `(${count}) ${summary}`;
				}

				let finalSource = "";
				let finalCachedFile = "";
				if (iconSrc.length > 0) {
					const cached = root.sanitizeAndCacheIcon(iconSrc, notif.id);
					finalSource = cached.source;
					finalCachedFile = cached.cachedFile;
					if (existing.cachedFile && existing.cachedFile.length > 0 && existing.cachedFile !== finalCachedFile) {
						root._safeUnlinkIcon(existing.cachedFile);
					}
				} else {
					finalSource = existing.appIcon || "";
					finalCachedFile = existing.cachedFile || "";
				}

				itemToStore = {
					id: notif.id,
					previousId: existing.id,
					rawNotif: notif,
					hasDefaultAction: hasDefaultAction,
					appName: appName,
					summary: displaySummary,
					baseSummary: summary,
					body: body,
					appIcon: finalSource,
					cachedFile: finalCachedFile,
					tag: tag,
					count: count,
					value: value,
					time: time,
					timestamp: timestamp,
					actions: activeActions,
					hasInlineReply: hasInlineReply,
					replyPlaceholder: replyPlaceholder
				};

				activeListModel.set(activeIdx, itemToStore);
			} else {
				let finalSource = "";
				let finalCachedFile = "";
				if (iconSrc.length > 0) {
					const cached = root.sanitizeAndCacheIcon(iconSrc, notif.id);
					finalSource = cached.source;
					finalCachedFile = cached.cachedFile;
				}

				itemToStore = {
					id: notif.id,
					previousId: notif.id,
					rawNotif: notif,
					hasDefaultAction: hasDefaultAction,
					appName: appName,
					summary: summary,
					baseSummary: summary,
					body: body,
					appIcon: finalSource,
					cachedFile: finalCachedFile,
					tag: tag,
					count: 1,
					value: value,
					time: time,
					timestamp: timestamp,
					actions: activeActions,
					hasInlineReply: hasInlineReply,
					replyPlaceholder: replyPlaceholder
				};

				if (!root.dndActive) {
					activeListModel.append(itemToStore);
				}
			}

			// 2. Update historyList (deduplicate and move latest to top, sanitized pure data log)
			const historyItem = {
				id: itemToStore.id,
				previousId: itemToStore.previousId,
				appName: itemToStore.appName,
				summary: itemToStore.summary,
				baseSummary: itemToStore.baseSummary,
				body: itemToStore.body,
				appIcon: itemToStore.appIcon,
				cachedFile: itemToStore.cachedFile,
				tag: itemToStore.tag,
				count: itemToStore.count,
				value: itemToStore.value,
				time: itemToStore.time,
				timestamp: itemToStore.timestamp,
				actions: historyActions,
				hasInlineReply: false
			};

			for (let i = 0; i < root.historyList.length; i++) {
				const it = root.historyList[i];
				if (!it)
					continue;
				const matches = (tag.length > 0) ? (it.tag === tag) : (it.appName === appName && it.baseSummary === summary && it.body === body);
				if (matches && it.cachedFile && it.cachedFile.length > 0 && it.cachedFile !== historyItem.cachedFile) {
					root._safeUnlinkIcon(it.cachedFile);
				}
			}

			const filteredHistory = root.historyList.filter(item => {
				if (!item)
					return false;
				if (tag.length > 0) {
					return item.tag !== tag;
				}
				return !(item.appName === appName && item.baseSummary === summary && item.body === body);
			});

			const newHistory = [historyItem, ...filteredHistory];
			if (newHistory.length > 50) {
				const dropped = newHistory.slice(50);
				for (let i = 0; i < dropped.length; i++) {
					if (dropped[i] && dropped[i].cachedFile && dropped[i].cachedFile.length > 0) {
						root._safeUnlinkIcon(dropped[i].cachedFile);
					}
				}
			}
			root.historyList = newHistory.slice(0, 50);
		}
	}

	function invokeDefault(id: int): void {
		const idx = root._findActiveIndex(id);
		if (idx !== -1) {
			const item = activeListModel.get(idx);
			if (item && item.rawNotif) {
				let invoked = false;
				try {
					let act = null;
					if (item.rawNotif.actions && item.rawNotif.actions.length > 0) {
						act = item.rawNotif.actions.find(a => a && a.identifier === "default");
						if (!act) {
							const first = item.rawNotif.actions[0];
							if (first && (first.identifier === "" || first.identifier === "0")) {
								act = first;
							}
						}
					}
					if (act) {
						act.invoke();
						invoked = true;
					}
				} catch (e) {
					console.log("Error invoking default action:", e);
				}

				if (invoked && !item.rawNotif.resident) {
					root._removeActiveAt(idx);
					return;
				}
			}
		}
		root.dismissActive(id);
	}

	function invokeAction(id: int, actionId: string): void {
		const idx = root._findActiveIndex(id);
		if (idx !== -1) {
			const item = activeListModel.get(idx);
			if (item && item.rawNotif) {
				let invoked = false;
				try {
					if (item.rawNotif.actions && item.rawNotif.actions.length > 0) {
						const act = item.rawNotif.actions.find(a => a && a.identifier === actionId);
						if (act) {
							act.invoke();
							invoked = true;
						}
					}
				} catch (e) {
					console.log("Error invoking action:", actionId, e);
				}

				if (invoked && !item.rawNotif.resident) {
					root._removeActiveAt(idx);
					return;
				}
			}
		}
		root.dismissActive(id);
	}

	function sendReply(id: int, replyText: string): void {
		const idx = root._findActiveIndex(id);
		if (idx !== -1) {
			const item = activeListModel.get(idx);
			if (item && item.rawNotif) {
				let sent = false;
				try {
					item.rawNotif.sendInlineReply(String(replyText));
					sent = true;
				} catch (e) {
					console.log("Error sending reply:", e);
				}

				if (sent && !item.rawNotif.resident) {
					root._removeActiveAt(idx);
					return;
				}
			}
		}
		root.dismissActive(id);
	}

	function dismissActive(id: int): void {
		const idx = root._findActiveIndex(id);
		if (idx !== -1) {
			const item = activeListModel.get(idx);
			if (item && item.rawNotif) {
				try {
					item.rawNotif.dismiss();
				} catch (e) {}
			}
			root._removeActiveAt(idx);
		}
	}

	function expireActive(id: int): void {
		const idx = root._findActiveIndex(id);
		if (idx !== -1) {
			const item = activeListModel.get(idx);
			if (item && item.rawNotif) {
				try {
					item.rawNotif.expire();
				} catch (e) {}
			}
			root._removeActiveAt(idx);
		}
	}

	function clearHistory(): void {
		const oldList = root.historyList;
		root.historyList = [];
		for (let i = 0; i < oldList.length; i++) {
			const it = oldList[i];
			if (it && it.cachedFile && it.cachedFile.length > 0) {
				root._safeUnlinkIcon(it.cachedFile);
			}
		}
	}

	function removeHistory(id: int): void {
		const toRemove = root.historyList.filter(n => n && (n.id === id || n.previousId === id));
		root.historyList = root.historyList.filter(n => n && n.id !== id && n.previousId !== id);
		for (let i = 0; i < toRemove.length; i++) {
			if (toRemove[i] && toRemove[i].cachedFile && toRemove[i].cachedFile.length > 0) {
				root._safeUnlinkIcon(toRemove[i].cachedFile);
			}
		}
	}
}
