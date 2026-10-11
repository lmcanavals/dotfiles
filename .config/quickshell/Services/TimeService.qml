pragma Singleton

import QtQuick
import Quickshell
import Core

QtObject {
	id: root

	property SystemClock clock: SystemClock {
		precision: SystemClock.Seconds
	}

	readonly property date currentDate: clock?.date ?? new Date()
	readonly property string formattedTime: Qt.formatDateTime(currentDate, Config.dateFormat)
	readonly property string shortTime: Qt.formatDateTime(currentDate, Config.timeFormat)

	readonly property string iconZero: ""
	readonly property string iconOne: ""

	readonly property string binaryTime: {
		const d = root.currentDate;
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
}
