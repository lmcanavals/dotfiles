pragma Singleton

import QtQuick
import Quickshell.Services.UPower

QtObject {
    id: root

    readonly property UPowerDevice displayDevice: UPower.displayDevice
    readonly property bool hasBattery: displayDevice !== null && displayDevice.isPresent

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

    readonly property string primaryGlyph: glyphForDevice(root.displayDevice)
}
// vim: set ts=4 sw=4 et sts=0 :
