pragma Singleton

import QtQuick
import Quickshell.Io
import Services

QtObject {
    id: root

    property Process actionProc: Process {
        running: false
    }

    function execute(cmd: list<string>): void {
        QuickSettingsService.close();
        actionProc.command = cmd;
        actionProc.running = true;
    }

    function logout(): void {
        execute(["uwsm", "stop"]);
    }

    function suspend(): void {
        execute(["systemctl", "suspend"]);
    }

    function hibernate(): void {
        execute(["systemctl", "hibernate"]);
    }

    function reboot(): void {
        execute(["systemctl", "reboot"]);
    }

    function poweroff(): void {
        execute(["systemctl", "poweroff"]);
    }
}
// vim: set ts=4 sw=4 et sts=0 :
