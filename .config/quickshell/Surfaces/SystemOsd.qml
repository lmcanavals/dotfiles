pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Core
import Services
import Primitives

Scope {
	id: root

	property bool showOsd: false
	property string currentMode: "volume" // "volume" | "mic" | "brightness"
	property bool ready: false

	Component.onCompleted: {
		Qt.callLater(() => {
			root.ready = true;
		});
	}

	function trigger(mode: string): void {
		if (!root.ready || QuickSettingsService.open)
			return;
		root.currentMode = mode;
		root.showOsd = true;
		hideTimer.restart();
	}

	Connections {
		target: AudioService

		function onVolumeChanged() {
			root.trigger("volume");
		}

		function onMutedChanged() {
			root.trigger("volume");
		}

		function onMicVolumeChanged() {
			root.trigger("mic");
		}

		function onMicMutedChanged() {
			root.trigger("mic");
		}
	}

	Connections {
		target: BrightnessService

		function onBrightnessChanged() {
			root.trigger("brightness");
		}
	}

	Timer {
		id: hideTimer
		interval: 1500
		onTriggered: root.showOsd = false
	}

	readonly property string activeGlyph: {
		if (root.currentMode === "mic")
			return AudioService.micGlyph;
		if (root.currentMode === "brightness")
			return BrightnessService.glyph;
		return AudioService.glyph;
	}

	readonly property real activeValue: {
		if (root.currentMode === "mic")
			return AudioService.micVolume;
		if (root.currentMode === "brightness")
			return BrightnessService.brightness;
		return AudioService.volume;
	}

	readonly property color activeBarColor: {
		if (root.currentMode === "mic")
			return AudioService.micMuted ? Theme.colors.comment : Theme.colors.fg_widget;
		if (root.currentMode === "brightness")
			return Theme.colors.fg_widget;
		return AudioService.muted ? Theme.colors.comment : Theme.colors.fg_widget;
	}

	readonly property string activeValueText: {
		if (root.currentMode === "mic")
			return AudioService.micMuted ? "Muted" : `${Math.round(AudioService.micVolume * 100)}%`;
		if (root.currentMode === "brightness")
			return `${Math.round(BrightnessService.brightness * 100)}%`;
		return AudioService.muted ? "Muted" : `${Math.round(AudioService.volume * 100)}%`;
	}

	LazyLoader {
		active: root.showOsd

		// qmllint disable uncreatable-type
		PanelWindow { // qmllint enable uncreatable-type
			anchors.bottom: true
			// qmllint disable unqualified unresolved-type
			margins.bottom: (screen?.height ?? 1080) / 6 // qmllint enable unqualified unresolved-type
			exclusiveZone: 0

			implicitWidth: 320
			implicitHeight: 46
			color: "transparent"

			WlrLayershell.layer: WlrLayer.Overlay
			WlrLayershell.namespace: "quickshell:osd"

			mask: Region {}

			SurfaceCard {
				anchors.fill: parent
				color: Theme.bgSurface

				MetricBar {
					anchors.fill: parent
					anchors.leftMargin: Config.padding * 2
					anchors.rightMargin: Config.padding * 2
					Layout.fillWidth: true
					glyph: root.activeGlyph
					value: root.activeValue
					barColor: root.activeBarColor
					valueText: root.activeValueText
				}
			}
		}
	}
}
