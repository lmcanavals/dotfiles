import QtQuick

import QtQuick.Layouts
import Core

Rectangle {
	id: root

	required property string glyph
	required property string label
	property bool active: false

	signal clicked
	signal rightClicked
	signal middleClicked

	implicitWidth: 140
	implicitHeight: 42
	radius: Config.radius

	color: active ? Theme.colors.bg_widget_r : (mouseArea.containsMouse ? Theme.bgControlHover : Theme.bgControl)
	border.color: Theme.colors.border
	border.width: 1

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
		onClicked: mouse => {
			if (mouse.button === Qt.RightButton) {
				root.rightClicked();
			} else if (mouse.button === Qt.MiddleButton) {
				root.middleClicked();
			} else {
				root.clicked();
			}
		}
	}

	RowLayout {
		anchors.fill: parent
		anchors.leftMargin: Config.padding
		anchors.rightMargin: Config.padding

		StyledText {
			text: root.glyph
			color: root.active ? Theme.colors.fg_widget_r : Theme.colors.comment
			font.pixelSize: Config.fontSizeXL
			Layout.preferredWidth: 24
		}

		ColumnLayout {
			Layout.fillWidth: true
			spacing: 0

			StyledText {
				text: root.label
				color: root.active ? Theme.colors.fg_widget_r : Theme.colors.comment
				font.bold: root.active
				font.pixelSize: Config.fontSizeSmall
			}

			StyledText {
				text: root.active ? "On" : "Off"
				color: Theme.colors.comment
				font.pixelSize: Config.fontSizeTiny
			}
		}

		Item {
			Layout.fillWidth: true
		}
	}
}
