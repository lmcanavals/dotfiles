pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives

RowLayout {
	id: root

	required property string glyph
	required property real value
	required property color accentColor
	property bool muted: false

	signal valueModified(real newValue)
	signal iconClicked
	signal iconRightClicked

	spacing: Config.spacing

	MouseArea {
		implicitWidth: 26
		implicitHeight: 26
		cursorShape: Qt.PointingHandCursor
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		onClicked: mouse => {
			if (mouse.button === Qt.LeftButton) {
				root.iconClicked();
			} else if (mouse.button === Qt.RightButton) {
				root.iconRightClicked();
			}
		}

		StyledText {
			anchors.centerIn: parent
			text: root.glyph
			color: root.muted ? Theme.colors.comment : root.accentColor
		}
	}

	TrackSlider {
		Layout.fillWidth: true
		value: root.value
		accentColor: root.accentColor
		muted: root.muted
		onValueModified: val => root.valueModified(val)
	}

	StyledText {
		horizontalAlignment: Text.AlignRight
		text: `${Math.round(root.value * 100)}%`
		color: root.muted ? Theme.colors.comment : root.accentColor
	}
}
