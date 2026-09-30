pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

BarPill {
	id: root

	clickable: false

	RowLayout {
		id: layout
		anchors.centerIn: parent
		spacing: Config.spacing

		StyledText {
			text: PowerService.primaryGlyph
			color: PowerService.primaryColor
		}

		StyledText {
			text: PowerService.primaryPercentText
			color: PowerService.primaryColor
			visible: PowerService.primaryShowPercent
		}
	}
}
