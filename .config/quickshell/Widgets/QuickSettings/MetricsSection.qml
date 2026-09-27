import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

RowLayout {
	id: root

	Layout.fillWidth: true
	spacing: Config.spacing * 2

	RadarChart {
		Layout.preferredWidth: 116
		Layout.preferredHeight: 96

		glyph: "󰻠"
		lineColor: HardwareService.cpuColor
		values: HardwareService.coresUsage
		total: HardwareService.cpuUsage
	}
	ColumnLayout {
		MetricBar {
			Layout.fillWidth: true
			glyph: `󰍛 ${HardwareService.memTotal}GiB`
			value: HardwareService.memUsage
			valueText: `${Math.round(Math.max(0.0, Math.min(1.0, HardwareService.memUsage)) * 100)}%`
			barColor: HardwareService.memColor
		}

		MetricBar {
			Layout.fillWidth: true
			glyph: `󰾴 ${HardwareService.swapTotal}GiB`
			value: HardwareService.swapUsage
			valueText: `${Math.round(Math.max(0.0, Math.min(1.0, HardwareService.swapUsage)) * 100)}%`
			barColor: HardwareService.swapColor
		}

		MetricBar {
			Layout.fillWidth: true
			glyph: "󰔏"
			value: Math.min(1.0, HardwareService.temperature / 100.0)
			valueText: `${HardwareService.temperature}°C`
			barColor: HardwareService.tempColor
		}
	}
}
