pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire

QtObject {
	id: root
	// Sink (Output)
	readonly property PwNode sink: Pipewire.defaultAudioSink
	readonly property real volume: Pipewire.defaultAudioSink?.audio?.volume ?? 0.0
	readonly property bool muted: Pipewire.defaultAudioSink?.audio?.muted ?? false

	// Source (Input / Microphone)
	readonly property PwNode source: Pipewire.defaultAudioSource
	readonly property real micVolume: Pipewire.defaultAudioSource?.audio?.volume ?? 0.0
	readonly property bool micMuted: Pipewire.defaultAudioSource?.audio?.muted ?? false
	readonly property string micGlyph: root.micMuted ? "󰍭" : "󰍬"

	readonly property string sinkType: {
		const desc = sink?.description.toLowerCase() ?? "";
		const name = sink?.name.toLowerCase() ?? "";
		if (desc.includes("headphone") || name.includes("headphone") || desc.includes("headset") || name.includes("usb"))
			return "headphone";
		if (desc.includes("hdmi") || desc.includes("displayport"))
			return "hdmi";
		if (desc.includes("bluetooth") || name.includes("bluez"))
			return "bluetooth";
		return "speaker";
	}

	readonly property string glyph: {
		if (root.sinkType === "headphone")
			return root.muted ? "󰟎" : "󰋋";
		if (root.sinkType === "bluetooth")
			return root.muted ? "󰗿" : "󰗾";

		const v = Math.round(root.volume * 100);
		if (v === 0 || root.muted)
			return "󰖁";
		if (v < 30)
			return "󰕿";
		if (v < 70)
			return "󰖀";
		return "󰕾";
	}

	property PwObjectTracker tracker: PwObjectTracker {
		objects: [root.sink, root.source]
	}

	function setVolume(val: real): void {
		if (sink?.audio) {
			sink.audio.volume = Math.max(0.0, Math.min(1.0, val));
		}
	}

	function toggleMute(): void {
		if (sink?.audio) {
			sink.audio.muted = !sink.audio.muted;
		}
	}

	function setMicVolume(val: real): void {
		if (source?.audio) {
			source.audio.volume = Math.max(0.0, Math.min(1.0, val));
		}
	}

	function toggleMicMute(): void {
		if (source?.audio) {
			source.audio.muted = !source.audio.muted;
		}
	}

	// Filtered lists
	readonly property var sinks: (Pipewire.nodes && Pipewire.nodes.values) ? Pipewire.nodes.values.filter(n => n && n.isSink && !n.isStream) : []

	readonly property var sources: (Pipewire.nodes && Pipewire.nodes.values) ? Pipewire.nodes.values.filter(n => n && (n.isSource || (!n.isSink && !n.isStream && (n.audio || n.properties?.["media.class"] === "Audio/Source")))) : []

	function nodeLabel(node: var): string {
		if (!node)
			return "";
		return node.description || node.name || ("Node #" + node.id);
	}

	property Process wpctlProc: Process {
		id: wpctlProcess
		running: false
	}

	function setSink(node: var): void {
		if (!node)
			return;
		// qmllint disable missing-property
		if (typeof Pipewire.setDefaultAudioSink === "function") {
			Pipewire.setDefaultAudioSink(node);
		} else {
			wpctlProcess.command = ["wpctl", "set-default", String(node.id)];
			wpctlProcess.startDetached();
		}
		// qmllint enable missing-property
	}

	function setSource(node: var): void {
		if (!node)
			return;
		// qmllint disable missing-property
		if (typeof Pipewire.setDefaultAudioSource === "function") {
			Pipewire.setDefaultAudioSource(node);
		} else {
			wpctlProcess.command = ["wpctl", "set-default", String(node.id)];
			wpctlProcess.startDetached();
		}
		// qmllint enable missing-property
	}
}
