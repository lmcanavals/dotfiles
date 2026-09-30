pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

BarPill {
	id: root

	onClicked: KeyboardService.nextLayout()

	RowLayout {
		id: layout
		anchors.centerIn: parent
		spacing: Config.spacing

		StyledText {
			text: "󰌌"
			font.bold: true
		}

		StyledText {
			text: KeyboardService.shortLayout
			font.bold: true
		}
	}
}
