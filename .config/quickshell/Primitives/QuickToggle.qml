import QtQuick

import QtQuick.Layouts
import Core

Rectangle {
	id: root

	required property string glyph
	required property string label
	property bool active: false
	property bool busy: false

	signal clicked
	signal rightClicked
	signal middleClicked

	implicitWidth: 140
	implicitHeight: 42
	radius: Config.radius

	color: active ? Theme.colors.bg_widget_r : (mouseArea.containsMouse ? Theme.bgControlHover : Theme.bgControl)
	border.color: Theme.colors.border
	border.width: 1
	opacity: root.busy ? 0.7 : 1.0

	Behavior on opacity {
		NumberAnimation {
			duration: Config.animDurationFast
		}
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: root.busy ? Qt.BusyCursor : Qt.PointingHandCursor
		acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
		onClicked: mouse => {
			if (root.busy)
				return;
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

		LoadingSpinner {
			visible: root.busy
			running: root.busy
			fontSize: Config.fontSizeXL
			color: root.active ? Theme.colors.fg_widget_r : Theme.colors.info
			Layout.preferredWidth: 24
		}

		StyledText {
			visible: !root.busy
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
				Layout.fillWidth: true
				horizontalAlignment: Text.AlignLeft
			}

			StyledText {
				text: root.busy ? "Pending..." : (root.active ? "On" : "Off")
				color: root.busy ? Theme.colors.info : Theme.colors.comment
				font.pixelSize: Config.fontSizeTiny
				Layout.fillWidth: true
				horizontalAlignment: Text.AlignLeft
			}
		}
	}
}
