import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

ColumnLayout {
	id: root

	Layout.fillWidth: true
	spacing: Config.spacing * 2

	MetricBar {
		Layout.fillWidth: true
		glyph: "󰻠"
		value: HardwareService.cpuUsage
		barColor: Theme.colors.accent
	}

	MetricBar {
		Layout.fillWidth: true
		glyph: "󰘚"
		value: HardwareService.memUsage
		valueText: HardwareService.memUsedGb
		barColor: Theme.colors.accent_alt
	}

	MetricBar {
		Layout.fillWidth: true
		glyph: "󰔏"
		value: Math.min(1.0, HardwareService.temperature / 100.0)
		valueText: `${HardwareService.temperature}°C`
		barColor: Theme.colors.warning
	}
}
