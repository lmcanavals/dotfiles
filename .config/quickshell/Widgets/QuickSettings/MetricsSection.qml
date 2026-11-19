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
		Layout.preferredWidth: 96
		Layout.preferredHeight: 96

		lineColor: Theme.metricStateColor(HardwareService.cpuState)
		values: HardwareService.coresUsage
	}
	ColumnLayout {
		Layout.fillWidth: true
		MetricBar {
			Layout.fillWidth: true
			glyph: "󰻠"
			value: HardwareService.cpuUsage
			valueText: `${Math.round(Math.max(0.0, Math.min(1.0, HardwareService.cpuUsage)) * 100)}%`
			barColor: Theme.metricStateColor(HardwareService.cpuState)
		}

		MetricBar {
			Layout.fillWidth: true
			glyph: "󰔏"
			value: Math.min(1.0, HardwareService.temperature / 100.0)
			valueText: `${HardwareService.temperature}°C`
			barColor: Theme.metricStateColor(HardwareService.tempState)
		}

		MetricBar {
			Layout.fillWidth: true
			glyph: `󰍛 ${HardwareService.memTotal.toFixed(1)}GiB`
			value: HardwareService.memUsage
			valueText: `${Math.round(Math.max(0.0, Math.min(1.0, HardwareService.memUsage)) * 100)}%`
			barColor: Theme.metricStateColor(HardwareService.memState)
		}

		MetricBar {
			Layout.fillWidth: true
			glyph: `󰾴 ${HardwareService.swapTotal.toFixed(1)}GiB`
			value: HardwareService.swapUsage
			valueText: `${Math.round(Math.max(0.0, Math.min(1.0, HardwareService.swapUsage)) * 100)}%`
			barColor: Theme.metricStateColor(HardwareService.swapState)
		}

		MetricBar {
			Layout.fillWidth: true
			glyph: `󰋊 ${HardwareService.diskTotal.toFixed(1)}GiB`
			value: HardwareService.diskUsage
			valueText: `${Math.round(Math.max(0.0, Math.min(1.0, HardwareService.diskUsage)) * 100)}%`
			barColor: Theme.metricStateColor(HardwareService.diskState)
		}
	}
}
