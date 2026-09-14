pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell.Wayland

QtObject {
    id: root

    // --- Idle Inhibitor (Wayland Protocol Native) ---
    property bool idleInhibited: false
    property IdleInhibitor inhibitor: IdleInhibitor {
        enabled: root.idleInhibited
    }

    function toggleIdleInhibit(): void {
        root.idleInhibited = !root.idleInhibited;
    }

    // --- Do Not Disturb (Dunstctl IPC) ---
    property bool dndActive: false

    property Process dndChecker: Process {
        command: ["dunstctl", "is-paused"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.dndActive = (this.text.trim() === "true");
            }
        }
    }

    property Process dndSetter: Process {
        running: false
        // qmllint disable signal-handler-parameters
        onExited: exitCode => {
            root.dndChecker.running = true;
        }
        // qmllint enable signal-handler-parameters
    }

    function toggleDnd(): void {
        root.dndActive = !root.dndActive;
        dndSetter.command = ["dunstctl", "set-paused", "toggle"];
        dndSetter.running = true;
    }

    // --- Night Light Hyprsunset IPC ---
    // TODO: figure out a way to detect if this thing is on
    property bool nightLightActive: true

    property Process nightLightSetter: Process {
        running: false
    }

    function toggleNightLight(): void {
        root.nightLightActive = !root.nightLightActive;
        if (root.nightLightActive) {
            nightLightSetter.command = ["hyprctl", "hyprsunset", "reset"];
        } else {
            nightLightSetter.command = ["hyprctl", "hyprsunset", "identity"];
        }
        nightLightSetter.running = true;
    }

    // --- Session Lock Execution ---
    property Process lockProc: Process {
        command: ["loginctl", "lock-session"]
        running: false
    }

    function lockSession(): void {
        if (!lockProc.running) {
            lockProc.running = true;
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
