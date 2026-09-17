pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property int count: 0
    property var updates: []
    property string lastUpdated: ""
    property bool isChecking: false
    readonly property string glyph: "󰮯"

    property bool open: false
    property Item targetItem: null

    function toggle(item: Item): void {
        if (root.open && root.targetItem === item) {
            root.close();
        } else {
            root.targetItem = item;
            root.open = true;
        }
    }

    function close(): void {
        root.open = false;
    }

    property Process busctlProc: Process {
        id: busctlProcess
        command: ["busctl", "--user", "call", "org.lmcs.DBus.UpdatesBtw", "/org/lmcs/DBus/UpdatesBtw/GetUpdates", "org.lmcs.DBus.UpdatesBtw.UpdatesInterface", "GetUpdates", "x", "0", "--json=short"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const raw = this.text.trim();
                    if (raw.length > 0) {
                        const parsed = JSON.parse(raw);
                        if (parsed && Array.isArray(parsed.data) && parsed.data.length > 0) {
                            const inner = JSON.parse(parsed.data[0]);
                            if (inner) {
                                root.count = (typeof inner.count === "number") ? inner.count : (inner.updates ? inner.updates.length : 0);
                                root.updates = Array.isArray(inner.updates) ? inner.updates : [];
                                root.lastUpdated = inner.timestamp || "";
                            }
                        }
                    }
                } catch (e) {
                    // Ignore parse errors silently
                }
                root.isChecking = false;
            }
        }

        // qmllint disable signal-handler-parameters
        onExited: exitCode => {
            root.isChecking = false;
        }
        // qmllint enable signal-handler-parameters
    }

    property Process upgradeProc: Process {
        id: upgradeProcess
        running: false
    }

    function refresh(): void {
        if (busctlProcess.running)
            return;
        root.isChecking = true;
        busctlProcess.running = true;
    }

    function triggerUpgrade(): void {
        root.close();
        upgradeProcess.command = ["kitty", "--title", "  System Upgrade", "sh", "-c", "yay; echo 'Press enter to exit'; read"];
        upgradeProcess.startDetached();
    }

    property Timer pollTimer: Timer {
        interval: 60000
        repeat: true
        running: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()
}
// vim: set ts=4 sw=4 et sts=0 :
