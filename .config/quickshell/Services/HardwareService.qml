pragma Singleton

import QtQuick
import Quickshell.Io
import Core
import Services

QtObject {
	id: root

	property real cpuUsage: 0.0
	property var coresUsage: []
	property real memUsage: 0.0
	property string memUsedGb: "0.0 GiB / 0.0 GiB"
	property int temperature: 0

	readonly property color cpuColor: colorForUsage(cpuUsage)
	readonly property color memColor: colorForUsage(memUsage)
	readonly property color tempColor: colorForTemp(temperature)

	function colorForUsage(ratio: real): color {
		if (ratio >= 0.80)
			return Theme.colors.error;
		if (ratio >= 0.60)
			return Theme.colors.warning;
		return Theme.colors.accent;
	}

	function colorForTemp(celsius: int): color {
		if (celsius >= 80)
			return Theme.colors.error;
		if (celsius >= 60)
			return Theme.colors.warning;
		return Theme.colors.accent;
	}

	property FileView statFile: FileView {
		id: procStat
		path: "/proc/stat"
		blockLoading: true
		onLoaded: root.parseCpu()
	}

	property FileView memFile: FileView {
		id: procMeminfo
		path: "/proc/meminfo"
		blockLoading: true
		onLoaded: root.parseMem()
	}

	property FileView tempFile: FileView {
		id: thermalTemp
		path: "/sys/class/thermal/thermal_zone0/temp"
		blockLoading: true
		onLoaded: root.parseTemp()
	}

	property var _lastCores: []

	function _getUsage(line, idxDelta): void {
		const fields = line.split(/\s+/).slice(1).map(Number);
		const idle = fields[3] + fields[4];
		const nonIdle = fields[0] + fields[1] + fields[2] + fields[5] + fields[6] + fields[7];
		const sum = idle + nonIdle;

		const dSum = sum - _lastCores[idxDelta].sum;
		const dIdle = idle - _lastCores[idxDelta].idle;

		_lastCores[idxDelta].sum = sum;
		_lastCores[idxDelta].idle = idle;

		return Math.max(0, Math.min(1, (dSum - dIdle) / dSum));
	}

	function parseCpu(): void {
		const text = procStat.text();
		const lines = text.trim().split("\n");

		if (_lastCores.length === 0) {
			_lastCores.push({
				"sum": 0,
				"idle": 0
			});
		} else {
			root.cpuUsage = _getUsage(lines[0], 0);
		}

		for (let i = 1; i < lines.length; i++) {
			if (!lines[i].startsWith("cpu"))
				break;
			if (_lastCores.length === i) {
				_lastCores.push({
					"sum": 0,
					"idle": 0
				});
				root.coresUsage.push(0);
			} else {
				root.coresUsage[i - 1] = _getUsage(lines[i], i);
			}
		}
	}

	function parseMem(): void {
		const text = procMeminfo.text();
		if (!text || text.length === 0)
			return;

		const totalMatch = text.match(/MemTotal:\s+(\d+)\s+kB/);
		const availMatch = text.match(/MemAvailable:\s+(\d+)\s+kB/);

		if (totalMatch && availMatch) {
			const totalKb = parseInt(totalMatch[1], 10);
			const availKb = parseInt(availMatch[1], 10);
			const usedKb = totalKb - availKb;

			if (totalKb > 0) {
				root.memUsage = Math.max(0.0, Math.min(1.0, usedKb / totalKb));
				const usedGb = (usedKb / 1048576).toFixed(1);
				const totalGb = (totalKb / 1048576).toFixed(1);
				root.memUsedGb = `${usedGb} GiB / ${totalGb} GiB`;
			}
		}
	}

	function parseTemp(): void {
		const raw = parseInt(thermalTemp.text().trim(), 10);
		if (!isNaN(raw)) {
			root.temperature = Math.round(raw / 1000);
		}
	}

	function refresh(): void {
		procStat.reload();
		procMeminfo.reload();
		thermalTemp.reload();
	}

	property Timer pollTimer: Timer {
		interval: 2000
		repeat: true
		running: QuickSettingsService.open
		triggeredOnStart: true
		onTriggered: root.refresh()
	}

	property Connections openWatcher: Connections {
		target: QuickSettingsService
		function onOpenChanged() {
			if (QuickSettingsService.open) {
				root.refresh();
			}
		}
	}

	Component.onCompleted: root.refresh()
}
