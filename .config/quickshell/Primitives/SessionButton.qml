import QtQuick
import Core
import Primitives

Rectangle {
	id: root

	required property string glyph
	property color hoverColor: Theme.colors.accent
	property color glyphColor: Theme.colors.fg_dark

	signal clicked

	implicitWidth: 36
	implicitHeight: 36
	radius: Config.radius
	color: mouseArea.containsMouse ? Theme.alpha(hoverColor, 0.5) : Theme.alpha(Theme.colors.bg_widget, 0.2)
	border.color: mouseArea.containsMouse ? hoverColor : Theme.colors.border
	border.width: 1

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: root.clicked()
	}

	StyledText {
		anchors.centerIn: parent
		text: root.glyph
		color: mouseArea.containsMouse ? root.hoverColor : root.glyphColor
		font.pixelSize: Config.fontSize + 4
	}
}
