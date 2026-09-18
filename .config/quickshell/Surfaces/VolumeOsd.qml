import QtQuick
import QtQuick.Layouts
import Quickshell
import Core
import Services
import Primitives

Scope {
	id: root

	property bool showOsd: false

	Connections {
		target: AudioService

		function onVolumeChanged() {
			if (!QuickSettingsService.open) {
				root.showOsd = true;
				hideTimer.restart();
			}
		}

		function onMutedChanged() {
			if (!QuickSettingsService.open) {
				root.showOsd = true;
				hideTimer.restart();
			}
		}
	}

	Timer {
		id: hideTimer

		interval: 1500
		onTriggered: root.showOsd = false
	}

	LazyLoader {
		active: root.showOsd

		// qmllint disable uncreatable-type
		PanelWindow {
			// qmllint enable uncreatable-type
			anchors.bottom: true
			// qmllint disable unqualified unresolved-type
			margins.bottom: (screen?.height ?? 1080) / 6
			// qmllint enable unqualified unresolved-type
			exclusiveZone: 0

			implicitWidth: 320
			implicitHeight: 46
			color: "transparent"

			mask: Region {}

			SurfaceCard {
				anchors.fill: parent
				color: Theme.alpha(Theme.colors.bg_dark, 0.4)
				radius: Config.radius

				MetricBar {
					anchors.fill: parent
					anchors.leftMargin: Config.padding * 2
					anchors.rightMargin: Config.padding * 2
					Layout.fillWidth: true
					glyph: AudioService.glyph
					value: AudioService.volume
					barColor: AudioService.muted ? Theme.colors.comment : Theme.colors.fg_widget
				}
			}
		}
	}
}
