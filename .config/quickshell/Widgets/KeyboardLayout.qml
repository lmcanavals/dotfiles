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

	MouseArea {
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		onClicked: KeyboardService.nextLayout()
	}

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
// vim: set ts=4 sw=4 et sts=0 :
