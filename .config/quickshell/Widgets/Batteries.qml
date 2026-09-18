pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

SurfaceCard {
	id: root

	implicitWidth: layout.implicitWidth + Config.padding * 2
	implicitHeight: Config.widgetHeight

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
