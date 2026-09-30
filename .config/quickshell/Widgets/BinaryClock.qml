import QtQuick
import Services
import Primitives

BarPill {
	id: root

	onClicked: QuickSettingsService.toggle(root)

	StyledText {
		id: label

		anchors.centerIn: parent
		text: TimeService.binaryTime
	}
}
