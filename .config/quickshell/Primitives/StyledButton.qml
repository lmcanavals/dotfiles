import QtQuick
import Core

Rectangle {
	id: root

	property string text: "Btn"
	property int minWidth: 20
	property color bg: Theme.bgControl
	property color bgHover: Theme.bgControlHover
	property color fg: Theme.colors.fg
	property color fgHover: Theme.colors.fg_widget
	property int fontSize: Config.fontSizeBase

	signal clicked

	color: mouseArea.containsMouse ? bgHover : bg

	Behavior on color {
		ColorAnimation {
			duration: 120
		}
	}

	implicitWidth: Math.max(minWidth, label.implicitWidth + Config.padding * 2)
	implicitHeight: Math.max(Config.widgetHeight, label.implicitHeight + Config.padding)

	MouseArea {
		id: mouseArea

		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: mouse => root.clicked()
	}

	StyledText {
		id: label

		anchors.centerIn: parent
		anchors.fill: parent
		text: root.text
		color: mouseArea.containsMouse ? root.fgHover : root.fg
	}
}
