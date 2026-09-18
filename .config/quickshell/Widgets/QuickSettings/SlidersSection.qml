import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

ColumnLayout {
	id: root

	Layout.fillWidth: true
	spacing: Config.spacing * 2

	SliderRow {
		id: sinkSlider
		Layout.fillWidth: true
		glyph: AudioService.glyph
		value: AudioService.volume
		muted: AudioService.muted
		accentColor: Theme.colors.fg_widget

		onIconClicked: AudioService.toggleMute()
		onIconRightClicked: sinkPicker.visible = !sinkPicker.visible
		onValueModified: val => AudioService.setVolume(val)
	}

	AudioNodePicker {
		id: sinkPicker
		anchorItem: sinkSlider
		modelList: AudioService.sinks
		activeNode: AudioService.sink
		isSourcePicker: false
	}

	SliderRow {
		id: sourceSlider
		Layout.fillWidth: true
		glyph: AudioService.micGlyph
		value: AudioService.micVolume
		muted: AudioService.micMuted
		accentColor: Theme.colors.fg_widget

		onIconClicked: AudioService.toggleMicMute()
		onIconRightClicked: sourcePicker.visible = !sourcePicker.visible
		onValueModified: val => AudioService.setMicVolume(val)
	}

	AudioNodePicker {
		id: sourcePicker
		anchorItem: sourceSlider
		modelList: AudioService.sources
		activeNode: AudioService.source
		isSourcePicker: true
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
