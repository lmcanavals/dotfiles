pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property real brightness: 1.0
    property bool ready: false

    // Pending percentage buffer to prevent dropped Process executions
    property int _targetPct: -1

    readonly property string glyph: {
        const b = Math.round(root.brightness * 100);
        if (b < 20)
            return "󰃞";
        if (b < 60)
            return "󰃟";
        return "󰃠";
    }

    // Machine-readable reader: brightnessctl -m returns comma-separated fields
    // e.g.: intel_backlight,backlight,950,95%,1000
    property Process readProc: Process {
        id: reader
        command: ["brightnessctl", "-m", "info"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const out = this.text.trim();
                if (out.length > 0) {
                    const parts = out.split(",");
                    if (parts.length >= 4) {
                        const pctStr = parts[3].replace("%", "").trim();
                        const val = parseInt(pctStr, 10);
                        if (!isNaN(val)) {
                            root.brightness = Math.max(0.01, Math.min(1.0, val / 100.0));
                            root.ready = true;
                        }
                    }
                }
            }
        }
    }

    // Serialized setter process
    property Process writeProc: Process {
        id: writer
        running: false
        // qmllint disable signal-handler-parameters
        onExited: exitCode => {
            if (root._targetPct >= 0) {
                const next = root._targetPct;
                root._targetPct = -1;
                writer.command = ["brightnessctl", "set", `${next}%`, "-q"];
                writer.running = true;
            }
        }
    }

    function setBrightness(pct: real): void {
        const clamped = Math.max(0.01, Math.min(1.0, pct));
        root.brightness = clamped; // Immediate local update: never snapped back by stale cache

        const target = Math.round(clamped * 100);

        if (writer.running) {
            root._targetPct = target;
        } else {
            root._targetPct = -1;
            writer.command = ["brightnessctl", "set", `${target}%`, "-q"];
            writer.running = true;
        }
    }

    function adjust(delta: real): void {
        setBrightness(root.brightness + delta);
    }
}
// vim: set ts=4 sw=4 et sts=0 :
