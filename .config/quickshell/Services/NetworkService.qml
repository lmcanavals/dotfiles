pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property bool enabled: false
    property bool connected: false
    property string ssid: ""
    property string glyph: "󰤮"

    // Primary poller for NetworkManager radio and active Wi-Fi connection
    property Process statusProc: Process {
        id: poller
        command: ["sh", "-c", "wifi_status=$(nmcli -t -f WIFI g); " + "active_conn=$(nmcli -t -f TYPE,STATE,CONNECTION dev | grep -E '^wifi:connected' | head -n1 | cut -d: -f3); " + "echo \"$wifi_status|$active_conn\""]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const out = this.text.trim();
                if (!out)
                    return;

                const parts = out.split("|");
                const wifiPower = parts[0] || "disabled";
                const activeSsid = parts[1] || "";

                root.enabled = (wifiPower === "enabled");
                root.ssid = activeSsid;
                root.connected = (activeSsid.length > 0);

                if (!root.enabled) {
                    root.glyph = "󰤮";
                } else if (!root.connected) {
                    root.glyph = "󰤫";
                } else {
                    root.glyph = "󰤨";
                }
            }
        }
    }

    // Setter for Wi-Fi radio state
    property Process toggleProc: Process {
        running: false
        // qmllint disable signal-handler-parameters
        onExited: exitCode => {
            root.refresh();
        }
        // qmllint enable signal-handler-parameters
    }

    // Launch external helper (networkmanager-dmenu)
    property Process dmenuProc: Process {
        command: ["networkmanager_dmenu"]
        running: false
    }

    property Timer pollTimer: Timer {
        interval: 4000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    function refresh(): void {
        if (!poller.running) {
            poller.running = true;
        }
    }

    function toggleWifi(): void {
        const next = !root.enabled;
        root.enabled = next; // Optimistic update
        toggleProc.command = ["nmcli", "radio", "wifi", next ? "on" : "off"];
        toggleProc.running = true;
    }

    function openPicker(): void {
        QuickSettingsService.close();
        if (!dmenuProc.running) {
            dmenuProc.running = true;
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
