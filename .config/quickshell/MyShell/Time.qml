pragma Singleton

import Quickshell

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, Config.dateFormat);
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
