pragma Singleton

import QtQuick
import Quickshell.Io
import Core

QtObject {
	id: root

	property real cpuUsage: 0.0
	property var coresUsage: []
	property var _coresUsage: []
	property real memTotal: 0.0
	property real memUsage: 0.0
	property real swapTotal: 0.0
	property real swapUsage: 0.0
	property real diskTotal: 0.0
	property real diskUsed: 0.0
	property real diskUsage: 0.0
	property real diskFreePercent: 0.0
	property int temperature: 0

	readonly property color cpuColor: colorForUsage(cpuUsage)
	readonly property color memColor: colorForUsage(memUsage)
	readonly property color swapColor: colorForUsage(swapUsage)
	readonly property color diskColor: colorForDisk(diskUsage)
	readonly property color tempColor: colorForTemp(temperature)

	function colorForUsage(ratio: real): color {
		if (ratio >= 0.80)
			return Theme.colors.error;
		if (ratio >= 0.60)
			return Theme.colors.warning;
		return Theme.colors.accent;
	}

	function colorForDisk(ratio: real): color {
		if (ratio >= 0.85)
			return Theme.colors.error;
		if (ratio >= 0.75)
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
		onLoaded: root.parseCpu()
	}

	property FileView memFile: FileView {
		id: procMeminfo
		path: "/proc/meminfo"
		onLoaded: root.parseMem()
	}

	property FileView tempFile: FileView {
		id: thermalTemp
		path: "/sys/class/thermal/thermal_zone0/temp"
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

			root._coresUsage[coreIdx] = _getUsage(lines[i], i);
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

	property Process diskProc: Process {
		id: diskProcess
		command: ["df", "-P", "-k", "/"]
		running: false

		stdout: StdioCollector {
			onStreamFinished: root.parseDisk(this.text)
		}
	}

	function parseDisk(text: string): void {
		if (!text || text.length === 0)
			return;

		const lines = text.trim().split("\n");
		if (lines.length < 2)
			return;

		const parts = lines[1].trim().split(/\s+/);
		if (parts.length < 4)
			return;

		const totalKb = parseInt(parts[1], 10);
		const usedKb = parseInt(parts[2], 10);
		const availKb = parseInt(parts[3], 10);

		if (!isNaN(totalKb) && totalKb > 0 && !isNaN(usedKb) && !isNaN(availKb)) {
			root.diskTotal = totalKb / 1048576;
			root.diskUsed = usedKb / 1048576;
			root.diskUsage = Math.max(0.0, Math.min(1.0, usedKb / totalKb));
			root.diskFreePercent = Math.max(0.0, Math.min(100.0, (availKb / totalKb) * 100));
		}
	}

	function refreshDisk(): void {
		if (!diskProcess.running) {
			diskProcess.running = true;
		}
	}

	function refresh(): void {
		procStat.reload();
		procMeminfo.reload();
		thermalTemp.reload();
		refreshDisk();
	}

	property bool active: false
	property bool statusAwareness: true

	readonly property bool isTempUrgent: root.temperature >= 80
	readonly property bool isCpuUrgent: isTempUrgent || root.cpuUsage >= 0.80
	readonly property bool isMemUrgent: root.memUsage >= 0.90 || root.swapUsage >= 0.75
	readonly property bool isDiskUrgent: root.diskUsage >= 0.85 || (root.diskFreePercent > 0 && root.diskFreePercent < 15)
	readonly property bool hasUrgentHardwareState: isCpuUrgent || isMemUrgent || isDiskUrgent

	readonly property int cpuTempInterval: isCpuUrgent ? 500 : (root.active ? 2000 : 5000)
	readonly property int memInterval: isMemUrgent ? 2000 : (root.active ? 5000 : 10000)
	readonly property int diskInterval: isDiskUrgent ? 10000 : 60000

	onIsCpuUrgentChanged: if (cpuTimer.running)
		cpuTimer.restart()
	onIsMemUrgentChanged: if (memoryTimer.running)
		memoryTimer.restart()
	onIsDiskUrgentChanged: if (storageTimer.running)
		storageTimer.restart()
	onActiveChanged: {
		if (cpuTimer.running)
			cpuTimer.restart();
		if (memoryTimer.running)
			memoryTimer.restart();
	}

	property Timer cpuTempTimer: Timer {
		id: cpuTimer
		interval: root.cpuTempInterval
		repeat: true
		running: root.active || root.statusAwareness
		triggeredOnStart: true
		onTriggered: {
			procStat.reload();
			thermalTemp.reload();
		}
	}

	property Timer memTimer: Timer {
		id: memoryTimer
		interval: root.memInterval
		repeat: true
		running: root.active || root.statusAwareness
		triggeredOnStart: true
		onTriggered: procMeminfo.reload()
	}

	property Timer diskTimer: Timer {
		id: storageTimer
		interval: root.diskInterval
		repeat: true
		running: root.active || root.statusAwareness
		triggeredOnStart: true
		onTriggered: root.refreshDisk()
	}

	readonly property alias pollTimer: cpuTimer
}
