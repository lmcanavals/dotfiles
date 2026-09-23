pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import Services

QtObject {
	id: root

	property var activeList: []
	property var historyList: []
	readonly property int unreadCount: historyList.length

	readonly property string iconCacheDir: {
		const xdg = Quickshell.env("XDG_CACHE_HOME");
		const base = (xdg && xdg.length > 0) ? xdg : (Quickshell.env("HOME") + "/.cache");
		return base + "/quickshell/notification-icons";
	}

	Component.onCompleted: {
		Quickshell.execDetached(["mkdir", "-p", root.iconCacheDir]);
		Quickshell.execDetached(["find", root.iconCacheDir, "-type", "f", "-mtime", "+3", "-delete"]);
	}

	function sanitizeAndCacheIcon(rawIcon: string, notifId: int): var {
		if (!rawIcon || rawIcon.length === 0) {
			return {
				source: "",
				cachedFile: ""
			};
		}

		let clean = rawIcon.trim();
		if (clean.startsWith("image://icon//")) {
			clean = clean.substring(13);
		} else if (clean.startsWith("image://icon/file://")) {
			clean = clean.substring(18);
		} else if (clean.startsWith("image://icon/")) {
			clean = clean.substring(13);
		}
		if (clean.startsWith("file://")) {
			clean = clean.substring(7);
		}

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

			// Extract actions safely
			let defaultInvoke = null;
			const activeActions = [];
			const historyActions = [];

			if (notif.actions && notif.actions.length > 0) {
				for (let i = 0; i < notif.actions.length; i++) {
					const act = notif.actions[i];
					if (!act)
						continue;
					const idStr = String(act.identifier || "");
					const textStr = String(act.text || idStr);

					if (idStr === "default") {
						defaultInvoke = () => {
							try {
								act.invoke();
							} catch (e) {}
						};
					} else {
						activeActions.push({
							id: idStr,
							text: textStr,
							invoke: () => {
								try {
									act.invoke();
								} catch (e) {}
							}
						});
						historyActions.push({
							id: idStr,
							text: textStr
						});
					}
				}
			}

			// Extract inline reply
			const hasInlineReply = Boolean(notif.hasInlineReply);
			const replyPlaceholder = String(notif.inlineReplyPlaceholder || "Type a reply...");
			const sendReplyFn = hasInlineReply ? replyText => {
				try {
					notif.sendInlineReply(String(replyText));
				} catch (e) {}
			} : null;

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

				let finalSource = "";
				let finalCachedFile = "";
				if (iconSrc.length > 0) {
					const cached = root.sanitizeAndCacheIcon(iconSrc, notif.id);
					finalSource = cached.source;
					finalCachedFile = cached.cachedFile;
					if (existing.cachedFile && existing.cachedFile.length > 0 && existing.cachedFile !== finalCachedFile) {
						Quickshell.execDetached(["rm", "-f", existing.cachedFile]);
					}
				} else {
					finalSource = existing.appIcon || "";
					finalCachedFile = existing.cachedFile || "";
				}

				itemToStore = {
					id: notif.id,
					previousId: existing.id,
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
					defaultInvoke: defaultInvoke,
					hasInlineReply: hasInlineReply,
					replyPlaceholder: replyPlaceholder,
					sendReply: sendReplyFn
				};

				const newActive = [...root.activeList];
				newActive[activeIdx] = itemToStore;
				root.activeList = newActive;
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
					defaultInvoke: defaultInvoke,
					hasInlineReply: hasInlineReply,
					replyPlaceholder: replyPlaceholder,
					sendReply: sendReplyFn
				};

				if (!EnvironmentService.dndActive) {
					root.activeList = [...root.activeList, itemToStore];
				}
			}

			// 2. Update historyList (deduplicate and move latest to top, sanitized pure data)
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
					Quickshell.execDetached(["rm", "-f", it.cachedFile]);
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
						Quickshell.execDetached(["rm", "-f", dropped[i].cachedFile]);
					}
				}
			}
			root.historyList = newHistory.slice(0, 50);
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
		for (let i = 0; i < root.historyList.length; i++) {
			const it = root.historyList[i];
			if (it && it.cachedFile && it.cachedFile.length > 0) {
				Quickshell.execDetached(["rm", "-f", it.cachedFile]);
			}
		}
		root.historyList = [];
	}

	function removeHistory(id: int): void {
		const toRemove = root.historyList.filter(n => n && (n.id === id || n.previousId === id));
		for (let i = 0; i < toRemove.length; i++) {
			if (toRemove[i] && toRemove[i].cachedFile && toRemove[i].cachedFile.length > 0) {
				Quickshell.execDetached(["rm", "-f", toRemove[i].cachedFile]);
			}
		}
		root.historyList = root.historyList.filter(n => n && n.id !== id && n.previousId !== id);
	}

	function invokeAction(item: var, actionId: string): void {
		if (item && item.actions) {
			const act = item.actions.find(a => a && a.id === actionId);
			if (act && typeof act.invoke === "function") {
				act.invoke();
			}
		}
		if (item && item.id !== undefined) {
			root.dismissActive(item.id);
		}
	}
}
