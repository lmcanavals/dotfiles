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
        Layout.fillWidth: true
        glyph: AudioService.glyph
        value: AudioService.volume
        muted: AudioService.muted
        accentColor: Theme.colors.fg_widget

        onIconClicked: AudioService.toggleMute()
        onValueModified: val => AudioService.setVolume(val)
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
// vim: set ts=4 sw=4 et sts=0 :
