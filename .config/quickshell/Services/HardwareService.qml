pragma Singleton

import QtQuick
import Quickshell.Io
import Core
import Services

QtObject {
	id: root

	property real cpuUsage: 0.0
	property var coresUsage: []
	property var _coresUsage: []
	property real memTotal: 0.0
	property real memUsage: 0.0
	property real swapTotal: 0.0
	property real swapUsage: 0.0
	property int temperature: 0

	readonly property color cpuColor: colorForUsage(cpuUsage)
	readonly property color memColor: colorForUsage(memUsage)
	readonly property color swapColor: colorForUsage(swapUsage)
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

	property var _lastSums: []
	property var _lastIdles: []

	function _getUsage(line: string, idxDelta: int): real {
		const fields = line.split(/\s+/).slice(1).map(Number);
		const idle = fields[3] + fields[4];
		const nonIdle = fields[0] + fields[1] + fields[2] + fields[5] + fields[6] + fields[7];
		const sum = idle + nonIdle;

		if (_lastSums.length <= idxDelta || _lastSums[idxDelta] === undefined) {
			_lastSums[idxDelta] = sum;
			_lastIdles[idxDelta] = idle;
			return 0.0;
		}

		const dSum = sum - _lastSums[idxDelta];
		const dIdle = idle - _lastIdles[idxDelta];

		_lastSums[idxDelta] = sum;
		_lastIdles[idxDelta] = idle;

		if (dSum <= 0)
			return 0.0;

		return Math.max(0.0, Math.min(1.0, (dSum - dIdle) / dSum));
	}

	function parseCpu(): void {
		const text = procStat.text();
		if (!text || text.length === 0)
			return;

		const lines = text.trim().split("\n");
		if (lines.length === 0)
			return;

		root.cpuUsage = _getUsage(lines[0], 0);

		for (let i = 1; i < lines.length; i++) {
			if (!lines[i].startsWith("cpu"))
				break;
			const coreIdx = i - 1;
			if (root.coresUsage.length <= coreIdx)
				root.coresUsage.push(0);
			if (root._coresUsage.length <= coreIdx)
				root._coresUsage.push(0);

			root._coresUsage[coreIdx] = Math.sqrt(_getUsage(lines[i], i));
		}

		const temp = root.coresUsage;
		root.coresUsage = root._coresUsage;
		root._coresUsage = temp;
	}

	function parseMem(): void {
		const text = procMeminfo.text();
		if (!text || text.length === 0)
			return;

		const totalMatch = text.match(/MemTotal:\s+(\d+)\s+kB/);
		const availMatch = text.match(/MemAvailable:\s+(\d+)\s+kB/);
		const swapMatch = text.match(/SwapTotal:\s+(\d+)\s+kB/);
		const freeSwapMatch = text.match(/SwapFree:\s+(\d+)\s+kB/);

		if (totalMatch && availMatch) {
			const totalKb = parseInt(totalMatch[1], 10);
			const availKb = parseInt(availMatch[1], 10);
			const usedKb = totalKb - availKb;
			if (totalKb > 0) {
				root.memUsage = Math.max(0.0, Math.min(1.0, usedKb / totalKb));
				root.memTotal = totalKb / 1048576;
			}
		}
		if (swapMatch && freeSwapMatch) {
			const swapKb = parseInt(swapMatch[1], 10);
			const freeSwapKb = parseInt(freeSwapMatch[1], 10);
			const usedSwapKb = swapKb - freeSwapKb;
			if (swapKb > 0) {
				root.swapUsage = Math.max(0.0, Math.min(1.0, usedSwapKb / swapKb));
				root.swapTotal = swapKb / 1048576;
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
