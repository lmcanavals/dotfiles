pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property string time: ":o"

    Process {
        id: dateProc
        command: ["/home/lmcs/.local/bin/localbaseclock"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.time = this.text
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }
}
