pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
	id: root

	property Process actionProc: Process {
		running: false
	}

	function execute(cmd: list<string>): void {
		actionProc.command = cmd;
		actionProc.startDetached();
	}

	function lock(): void {
		execute(["loginctl", "lock-session"]);
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
