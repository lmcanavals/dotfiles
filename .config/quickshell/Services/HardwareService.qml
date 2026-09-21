pragma Singleton

import QtQuick
import Quickshell.Io
import Core
import Services

QtObject {
	id: root

	property real cpuUsage: 0.0
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

	property real _prevTotal: 0.0
	property real _prevIdle: 0.0

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

	function parseCpu(): void {
		const text = procStat.text();
		if (!text || text.length === 0)
			return;

		const firstLine = text.split("\n")[0] || "";
		if (!firstLine.startsWith("cpu "))
			return;

		const parts = firstLine.trim().split(/\s+/).slice(1).map(Number);
		if (parts.length < 8)
			return;

		const user = parts[0];
		const nice = parts[1];
		const system = parts[2];
		const idle = parts[3];
		const iowait = parts[4];
		const irq = parts[5];
		const softirq = parts[6];
		const steal = parts[7];

		const total = user + nice + system + idle + iowait + irq + softirq + steal;
		const idle_all = idle + iowait;

		if (root._prevTotal > 0) {
			const deltaTotal = total - root._prevTotal;
			const deltaIdle = idle_all - root._prevIdle;
			if (deltaTotal > 0) {
				root.cpuUsage = Math.max(0.0, Math.min(1.0, (deltaTotal - deltaIdle) / deltaTotal));
			}
		}

		root._prevTotal = total;
		root._prevIdle = idle_all;
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
