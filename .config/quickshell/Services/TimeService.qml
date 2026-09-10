pragma Singleton

import QtQuick
import Quickshell
import Core

QtObject {
    id: root

    readonly property date currentDate: clock.date
    readonly property string formattedTime: Qt.formatDateTime(clock.date, Config.dateFormat)
    readonly property string shortTime: Qt.formatDateTime(clock.date, Config.timeFormat)

    property SystemClock clock: SystemClock {
        precision: SystemClock.Seconds
    }
}
// vim: set ts=4 sw=4 et sts=0 :
