pragma Singleton

import QtQuick
import Quickshell
import Core

QtObject {
	id: root

	readonly property date currentDate: clock.date
	readonly property string formattedTime: Qt.formatDateTime(clock.date, Config.dateFormat)
	readonly property string shortTime: Qt.formatDateTime(clock.date, Config.timeFormat)

	readonly property string iconZero: "\uf4c3"
	readonly property string iconOne: "\uf444"

	readonly property string binaryTime: {
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
		precision: SystemClock.Seconds
	}
}
