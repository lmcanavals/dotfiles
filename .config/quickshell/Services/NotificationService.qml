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
			for (let i = 0; i < activeListModel.count; i++) {
				const it = activeListModel.get(i);
				if (it) {
					if (it.rawNotif) {
						try {
							it.rawNotif.expire();
						} catch (e) {}
					}
					if (it.cachedFile && it.cachedFile.length > 0) {
						root._decrementIconRef(it.cachedFile);
					}
				}
			}
			activeListModel.clear();
			root._rebuildActiveIndex();
		}
	}

	property ListModel activeList: ListModel {
		id: activeListModel
	}
	property ListModel historyList: ListModel {
		id: historyListModel
	}
	readonly property int unreadCount: historyList.count

	readonly property var _activeIdMap: new Map()
	readonly property var _activeTagMap: new Map()
	readonly property var _activeSigMap: new Map()
	readonly property var _historyIdMap: new Map()
	readonly property var _historyTagMap: new Map()
	readonly property var _historySigMap: new Map()
	readonly property var _iconRefCounts: new Map()

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

	function _incrementIconRef(path: string): void {
		if (!path || path.length === 0)
			return;
		const cur = root._iconRefCounts.get(path) || 0;
		root._iconRefCounts.set(path, cur + 1);
	}

	function _decrementIconRef(path: string): void {
		if (!path || path.length === 0)
			return;
		const cur = root._iconRefCounts.get(path) || 0;
		if (cur <= 1) {
			root._iconRefCounts.delete(path);
			Quickshell.execDetached(["rm", "-f", path]);
		} else {
			root._iconRefCounts.set(path, cur - 1);
		}
	}

	function _safeUnlinkIcon(path: string): void {
		root._decrementIconRef(path);
	}

	function _rebuildActiveIndex(): void {
		root._activeIdMap.clear();
		root._activeTagMap.clear();
		root._activeSigMap.clear();
		for (let i = 0; i < activeListModel.count; i++) {
			const it = activeListModel.get(i);
			if (!it)
				continue;
			root._activeIdMap.set(it.id, i);
			if (it.previousId !== undefined && it.previousId !== 0) {
				root._activeIdMap.set(it.previousId, i);
			}
			if (it.tag && it.tag.length > 0) {
				root._activeTagMap.set(it.tag, i);
			}
			const sig = it.appName + "\0" + it.baseSummary + "\0" + it.body;
			root._activeSigMap.set(sig, i);
		}
	}

	function _rebuildHistoryIndex(): void {
		root._historyIdMap.clear();
		root._historyTagMap.clear();
		root._historySigMap.clear();
		for (let i = 0; i < historyListModel.count; i++) {
			const it = historyListModel.get(i);
			if (!it)
				continue;
			root._historyIdMap.set(it.id, i);
			if (it.previousId !== undefined && it.previousId !== 0) {
				root._historyIdMap.set(it.previousId, i);
			}
			if (it.tag && it.tag.length > 0) {
				root._historyTagMap.set(it.tag, i);
			}
			const sig = it.appName + "\0" + it.baseSummary + "\0" + it.body;
			root._historySigMap.set(sig, i);
		}
	}

	function _findActiveIndex(id: int): int {
		if (root._activeIdMap.has(id)) {
			return root._activeIdMap.get(id);
		}
		return -1;
	}

	function _findHistoryIndex(id: int): int {
		if (root._historyIdMap.has(id)) {
			return root._historyIdMap.get(id);
		}
		return -1;
	}

	function _removeActiveAt(idx: int): void {
		if (idx < 0 || idx >= activeListModel.count)
			return;
		const item = activeListModel.get(idx);
		const cachedFile = item ? item.cachedFile : "";
		activeListModel.remove(idx);
		if (cachedFile && cachedFile.length > 0) {
			root._decrementIconRef(cachedFile);
		}
		root._rebuildActiveIndex();
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
			let defaultActionText = "";
			const activeActions = [];
			const historyActions = [];

			// qmllint disable missing-property
			if (notif.actions && notif.actions.length > 0) {
				for (let i = 0; i < notif.actions.length; i++) {
					const act = notif.actions[i];
					if (!act)
						continue;
					const idStr = String(act.identifier || "");
					const textStr = String(act.text || idStr);

					if (idStr === "default") {
						hasDefaultAction = true;
						defaultActionText = textStr !== "default" ? textStr : "";
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
						const txt = String(first.text || "");
						defaultActionText = (txt !== "" && txt !== "0") ? txt : "";
					}
				}
			}
			// qmllint enable missing-property

			// Extract inline reply
			const hasInlineReply = Boolean(notif.hasInlineReply);
			const replyPlaceholder = String(notif.inlineReplyPlaceholder || "Type a reply...");

			const time = new Date().toLocaleTimeString([], {
				hour: "2-digit",
				minute: "2-digit"
			});
			const timestamp = Date.now();

			// 1. Check for match in activeList using index maps
			const sig = appName + "\0" + summary + "\0" + body;
			let activeIdx = -1;
			if (tag.length > 0) {
				if (root._activeTagMap.has(tag))
					activeIdx = root._activeTagMap.get(tag);
			} else {
				if (root._activeSigMap.has(sig))
					activeIdx = root._activeSigMap.get(sig);
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
					count = (existing.count ?? 1) + 1;
					displaySummary = `(${count}) ${summary}`;
				}

				let finalSource = "";
				let finalCachedFile = "";
				if (iconSrc.length > 0) {
					const cached = root.sanitizeAndCacheIcon(iconSrc, notif.id);
					finalSource = cached.source;
					finalCachedFile = cached.cachedFile;
					if (existing.cachedFile && existing.cachedFile.length > 0 && existing.cachedFile !== finalCachedFile) {
						root._decrementIconRef(existing.cachedFile);
					}
					if (finalCachedFile.length > 0 && finalCachedFile !== existing.cachedFile) {
						root._incrementIconRef(finalCachedFile);
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
					defaultActionText: defaultActionText,
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
					defaultActionText: defaultActionText,
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
					if (finalCachedFile.length > 0) {
						root._incrementIconRef(finalCachedFile);
					}
					activeListModel.append(itemToStore);
				}
			}
			root._rebuildActiveIndex();

			// 2. Update historyList (deduplicate and move latest to top, preserving expanded state)
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
				hasInlineReply: false,
				expanded: false
			};

			let historyIdx = -1;
			if (tag.length > 0) {
				if (root._historyTagMap.has(tag))
					historyIdx = root._historyTagMap.get(tag);
			} else {
				if (root._historySigMap.has(sig))
					historyIdx = root._historySigMap.get(sig);
			}

			if (historyIdx !== -1) {
				const existing = historyListModel.get(historyIdx);
				if (existing) {
					historyItem.expanded = Boolean(existing.expanded);
					if (existing.cachedFile && existing.cachedFile.length > 0 && existing.cachedFile !== historyItem.cachedFile) {
						root._decrementIconRef(existing.cachedFile);
					}
				}
				if (historyItem.cachedFile && historyItem.cachedFile.length > 0 && (!existing || existing.cachedFile !== historyItem.cachedFile)) {
					root._incrementIconRef(historyItem.cachedFile);
				}
				historyListModel.set(historyIdx, historyItem);
				if (historyIdx !== 0) {
					historyListModel.move(historyIdx, 0, 1);
				}
			} else {
				if (historyItem.cachedFile && historyItem.cachedFile.length > 0) {
					root._incrementIconRef(historyItem.cachedFile);
				}
				historyListModel.insert(0, historyItem);
			}

			while (historyListModel.count > 50) {
				const tailIdx = historyListModel.count - 1;
				const dropped = historyListModel.get(tailIdx);
				if (dropped && dropped.cachedFile && dropped.cachedFile.length > 0) {
					root._decrementIconRef(dropped.cachedFile);
				}
				historyListModel.remove(tailIdx);
			}

			root._rebuildHistoryIndex();
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

	function toggleHistoryExpanded(idx: int): void {
		if (idx >= 0 && idx < historyListModel.count) {
			const it = historyListModel.get(idx);
			if (it) {
				historyListModel.setProperty(idx, "expanded", !it.expanded);
			}
		}
	}

	function clearHistory(): void {
		for (let i = 0; i < historyListModel.count; i++) {
			const it = historyListModel.get(i);
			if (it && it.cachedFile && it.cachedFile.length > 0) {
				root._decrementIconRef(it.cachedFile);
			}
		}
		historyListModel.clear();
		root._rebuildHistoryIndex();
	}

	function removeHistory(id: int): void {
		const idx = root._findHistoryIndex(id);
		if (idx !== -1) {
			const it = historyListModel.get(idx);
			if (it && it.cachedFile && it.cachedFile.length > 0) {
				root._decrementIconRef(it.cachedFile);
			}
			historyListModel.remove(idx);
			root._rebuildHistoryIndex();
		}
	}
}
