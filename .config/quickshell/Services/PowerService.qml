pragma Singleton

import QtQuick
import Quickshell.Services.UPower
import Core

QtObject {
	id: root

	readonly property UPowerDevice displayDevice: UPower.displayDevice
	readonly property bool hasBattery: displayDevice !== null && displayDevice.isPresent

	// Primary device properties
	readonly property string primaryGlyph: glyphForDevice(root.displayDevice)
	readonly property color primaryColor: colorForDevice(root.displayDevice)
	readonly property string primaryName: deviceName(root.displayDevice)
	readonly property string primaryTimeEstimate: timeEstimate(root.displayDevice)
	readonly property string primaryPercentText: percentText(root.displayDevice)
	readonly property bool primaryShowPercent: showPercent(root.displayDevice)

	// Peripheral devices collection
	readonly property var peripheralDevices: {
		if (!UPower.devices || !UPower.devices.values)
			return [];
		const list = [];
		for (let i = 0; i < UPower.devices.values.length; i++) {
			const dev = UPower.devices.values[i];
			if (dev && dev.isPresent && dev.type !== UPowerDeviceType.LinePower && dev !== root.displayDevice) {
				list.push(dev);
			}
		}
		return list;
	}

	readonly property int peripheralCount: peripheralDevices.length

	// Domain Helpers
	function glyphForDevice(dev: UPowerDevice): string {
		if (!dev || !dev.isPresent)
			return "󰚥";

		if (dev.type === UPowerDeviceType.Mouse)
			return "󰍽";
		if (dev.type === UPowerDeviceType.Keyboard)
			return "󰌌";
		if (dev.type === UPowerDeviceType.Headphones || dev.type === UPowerDeviceType.Headset)
			return "󰋋";

		const pct = Math.max(0.0, Math.min(1.0, dev.percentage ?? 0.0));
		const isCharging = dev.state === UPowerDeviceState.Charging;

		if (isCharging) {
			const chargingIcons = ["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"];
			const cIdx = Math.floor(pct * (chargingIcons.length - 1));
			return chargingIcons[cIdx];
		}

		const dischargingIcons = ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"];
		const dIdx = Math.floor(pct * (dischargingIcons.length - 1));
		return dischargingIcons[dIdx];
	}

	function colorForDevice(dev: UPowerDevice): color {
		if (!dev || !dev.isPresent)
			return Theme.colors.fg_widget;
		if (dev.state === UPowerDeviceState.Charging)
			return Theme.colors.success;
		if (dev.percentage < 0.20)
			return Theme.colors.error;
		if (dev.percentage < 0.40)
			return Theme.colors.warning;
		return Theme.colors.fg_widget;
	}

	function _decodeHexAscii(str) {
		// Match sequences like: 0x4C 0x31 0x39 ...
		const regex = /(0x[0-9A-Fa-f]{2})/g;
		const matches = str.match(regex);
		if (!matches)
			return str;

		let out = "";
		for (const m of matches) {
			const byte = parseInt(m.slice(2), 16);
			if (byte === 0)
				out += " ";
			out += String.fromCharCode(byte);
		}
		return out.trim();
	}
	function deviceName(dev: UPowerDevice): string {
		if (!dev || !dev.model || dev.model.length === 0)
			return "Battery";
		return _decodeHexAscii(dev.model);
	}

	function deviceLabelWithState(dev: UPowerDevice): string {
		if (!dev)
			return "Battery";
		const name = deviceName(dev);
		const state = UPowerDeviceState.toString(dev.state);
		return `${name} (${state})`;
	}

	function timeEstimate(dev: UPowerDevice): string {
		if (!dev || !dev.isPresent)
			return "";
		if (dev.state === UPowerDeviceState.Charging && dev.timeToFull > 0) {
			return `${Math.round(dev.timeToFull / 60)}m left`;
		}
		if (dev.timeToEmpty > 0) {
			return `${Math.round(dev.timeToEmpty / 60)}m left`;
		}
		return "";
	}

	function percentText(dev: UPowerDevice): string {
		if (!dev)
			return "0%";
		return `${Math.round((dev.percentage ?? 0.0) * 100)}%`;
	}

	function showPercent(dev: UPowerDevice): bool {
		if (!dev || !dev.isPresent) {
			return false;
		}
		if (dev.state === UPowerDeviceState.FullyCharged || dev.state === UPowerDeviceState.PendingCharge) {
			return false;
		}
		return true;
	}
}
