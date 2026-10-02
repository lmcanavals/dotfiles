pragma Singleton

import QtQuick
import Quickshell.Services.Mpris

QtObject {
	id: root

	readonly property MprisPlayer activePlayer: {
		const players = Mpris.players?.values;
		if (!players || players.length === 0)
			return null;

		return players.find(p => p?.playbackState === MprisPlaybackState.Playing) || players.find(p => p?.playbackState === MprisPlaybackState.Paused) || players[0] || null;
	}
	readonly property string album: activePlayer?.trackAlbum ?? ""
	readonly property string artUrl: activePlayer?.trackArtUrl ?? ""
	readonly property string artist: activePlayer?.trackArtist ?? ""
	readonly property bool hasPlayer: activePlayer !== null
	readonly property bool isPlaying: activePlayer?.playbackState === MprisPlaybackState.Playing
	readonly property real length: activePlayer?.length ?? 0
	property real position: 0
	readonly property string title: activePlayer?.trackTitle ?? ""
	property bool open: false
	property bool hasOpened: false
	property Item targetItem: null

	function formatTime(val: real): string {
		if (val <= 0 || isNaN(val))
			return "0:00";
		const totalSecs = val > 10000 ? Math.floor(val / 1000000) : Math.floor(val);
		const mins = Math.floor(totalSecs / 60);
		const secs = totalSecs % 60;
		return `${mins}:${secs < 10 ? "0" : ""}${secs}`;
	}

	// INFO: there is a chance that position is updated twice, by timer and naturally by
	// signal from mpris, but some apps appear to not update at the same rate. Youtube only
	// updates on demand, while hbo+ updates automatically even without timer
	function updatePosition(): void {
		root.position = activePlayer?.position ?? 0;
	}

	property Timer positionTimer: Timer {
		interval: 1000
		repeat: true
		running: root.isPlaying && root.open

		onTriggered: root.updatePosition()
	}

	onActivePlayerChanged: root.updatePosition()
	onOpenChanged: {
		if (root.open) {
			root.hasOpened = true;
			root.updatePosition();
		}
	}

	readonly property real progress: {
		if (!activePlayer || root.length <= 0)
			return 0.0;
		return Math.max(0.0, Math.min(1.0, root.position / root.length));
	}

	function adjustVolume(delta: real): void {
		if (!activePlayer)
			return;
		const current = activePlayer.volume ?? 1.0;
		activePlayer.volume = Math.max(0.0, Math.min(1.0, current + delta));
	}

	function close(): void {
		root.open = false;
	}

	function next(): void {
		if (activePlayer && activePlayer.canGoNext)
			activePlayer.next();
	}

	function playPause(): void {
		if (!activePlayer || !activePlayer.canPlay)
			return;
		if (root.isPlaying) {
			activePlayer.pause();
		} else {
			activePlayer.play();
		}
	}

	function previous(): void {
		if (activePlayer && activePlayer.canGoPrevious)
			activePlayer.previous();
	}

	function seek(ratio: real): void {
		if (!activePlayer || root.length <= 0)
			return;
		const clamped = Math.max(0.0, Math.min(1.0, ratio));
		activePlayer.position = clamped * root.length;
		root.updatePosition();
	}

	function toggle(target: Item): void {
		if (root.open && root.targetItem === target) {
			root.close();
		} else {
			root.targetItem = target;
			root.open = true;
		}
	}
}
