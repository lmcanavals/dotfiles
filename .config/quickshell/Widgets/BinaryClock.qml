import QtQuick
import Core
import Services
import Primitives

SurfaceCard {
	id: root

	implicitWidth: label.implicitWidth + Config.padding * 2
	implicitHeight: Config.widgetHeight

	MouseArea {
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		onClicked: QuickSettingsService.toggle(root)
	}

	StyledText {
		id: label

		anchors.centerIn: parent
		text: BinaryClockService.timeString
	}
}
