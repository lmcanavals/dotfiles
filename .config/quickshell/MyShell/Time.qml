pragma Singleton

import Quickshell

Singleton {
    readonly property string time: {
        Qt.formatDateTime(clock.date, Config.dateFormat);
    }

    SystemClock {
        id: clock

        precision: SystemClock.Seconds
    }
}
