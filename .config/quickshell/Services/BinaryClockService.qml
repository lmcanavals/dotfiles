pragma Singleton

import QtQuick
import Quickshell

QtObject {
    id: root

    readonly property string iconZero: "\uf4c3"
    readonly property string iconOne: "\uf444"

    readonly property string timeString: {
        const d = clock.date;
        const hr = d.getHours();
        const min = d.getMinutes();

        let hStr = "";
        for (let i = 4; i >= 0; i--) {
            hStr += ((hr >> i) & 1) ? iconOne : iconZero;
        }

        let mStr = "";
        for (let i = 5; i >= 0; i--) {
            mStr += ((min >> i) & 1) ? iconOne : iconZero;
        }

        return `${hStr} : ${mStr}`;
    }

    property SystemClock clock: SystemClock {
        precision: SystemClock.Minutes
    }
}
// vim: set ts=4 sw=4 et sts=0 :
