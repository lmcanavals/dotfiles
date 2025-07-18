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
// vim: set ts=4 sw=4 et sts=0 :
