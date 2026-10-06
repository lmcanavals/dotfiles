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
	property bool expandable: false
	property bool expanded: false

	signal valueModified(real newValue)
	signal iconClicked
	signal iconRightClicked
	signal chevronClicked

	spacing: Config.spacing

	StyledText {
		text: root.glyph
		color: root.muted ? Theme.colors.comment : root.accentColor
		Layout.minimumWidth: 20

		MouseArea {
			anchors.fill: parent
			cursorShape: Qt.PointingHandCursor
			acceptedButtons: Qt.LeftButton | Qt.RightButton
			onClicked: mouse => {
				if (mouse.button === Qt.LeftButton) {
					root.iconClicked();
				} else if (mouse.button === Qt.RightButton) {
					root.iconRightClicked();
				}
			}
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
		font.pixelSize: Config.fontSizeSmall
		color: root.muted ? Theme.colors.comment : root.accentColor
		Layout.preferredWidth: 38
	}

	StyledText {
		text: root.expanded ? "󰅀" : "󰅂"
		Layout.preferredWidth: 16
		color: chevronMouseArea.containsMouse ? Theme.colors.accent : Theme.colors.comment
		font.pixelSize: Config.fontSizeSmall
		visible: root.expandable

		MouseArea {
			id: chevronMouseArea
			anchors.fill: parent
			hoverEnabled: true
			cursorShape: Qt.PointingHandCursor
			onClicked: root.chevronClicked()
		}
	}
}
