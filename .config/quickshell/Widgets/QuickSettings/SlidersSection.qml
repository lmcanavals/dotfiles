pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

ColumnLayout {
	id: root

	property string activeDrawer: "" // "" | "sink" | "source"

	function toggleDrawer(name: string): void {
		if (root.activeDrawer === name) {
			root.activeDrawer = "";
		} else {
			root.activeDrawer = name;
		}
	}

	Connections {
		target: QuickSettingsService
		function onOpenChanged() {
			if (!QuickSettingsService.open) {
				root.activeDrawer = "";
			}
		}
	}

	Layout.fillWidth: true
	spacing: Config.spacing

	SliderRow {
		id: sinkSlider
		Layout.fillWidth: true
		glyph: AudioService.glyph
		value: AudioService.volume
		muted: AudioService.muted
		accentColor: Theme.colors.fg_widget
		expandable: true
		expanded: root.activeDrawer === "sink"

		onIconClicked: AudioService.toggleMute()
		onIconRightClicked: root.toggleDrawer("sink")
		onChevronClicked: root.toggleDrawer("sink")
		onValueModified: val => AudioService.setVolume(val)
	}

	Loader {
		id: sinkDrawerLoader
		Layout.fillWidth: true
		active: root.activeDrawer === "sink"
		visible: active
		sourceComponent: InlineSelectionDrawer {
			title: "Audio Outputs"
			modelList: AudioService.sinks
			selectedItem: AudioService.sink
			itemLabelFunc: node => AudioService.nodeLabel(node)
			onItemSelected: node => {
				AudioService.setSink(node);
				root.activeDrawer = "";
			}
		}
	}

	SliderRow {
		id: sourceSlider
		Layout.fillWidth: true
		glyph: AudioService.micGlyph
		value: AudioService.micVolume
		muted: AudioService.micMuted
		accentColor: Theme.colors.fg_widget
		expandable: true
		expanded: root.activeDrawer === "source"

		onIconClicked: AudioService.toggleMicMute()
		onIconRightClicked: root.toggleDrawer("source")
		onChevronClicked: root.toggleDrawer("source")
		onValueModified: val => AudioService.setMicVolume(val)
	}

	Loader {
		id: sourceDrawerLoader
		Layout.fillWidth: true
		active: root.activeDrawer === "source"
		visible: active
		sourceComponent: InlineSelectionDrawer {
			title: "Audio Inputs"
			modelList: AudioService.sources
			selectedItem: AudioService.source
			itemLabelFunc: node => AudioService.nodeLabel(node)
			onItemSelected: node => {
				AudioService.setSource(node);
				root.activeDrawer = "";
			}
		}
	}

	SliderRow {
		Layout.fillWidth: true
		glyph: BrightnessService.glyph
		value: BrightnessService.brightness
		muted: false
		accentColor: Theme.colors.fg_widget

		onValueModified: val => BrightnessService.setBrightness(val)
	}
}
