pragma ComponentBehavior: Bound

import QtQuick
import Core

Rectangle {
	id: root

	required property real value
	property real minValue: 0.0
	property real maxValue: 1.0
	property color fillColor: Theme.colors.accent
	property color trackColor: Theme.colors.bg_highlight
	property int fillRadius: Config.radiusSmall
	property bool animated: true

	readonly property real normalized: (root.maxValue > root.minValue) ? Math.max(0.0, Math.min(1.0, (root.value - root.minValue) / (root.maxValue - root.minValue))) : 0.0

	implicitHeight: 6
	implicitWidth: 100
	radius: root.fillRadius
	color: root.trackColor

	Rectangle {
		id: fillBar
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width: parent.width * root.normalized
		radius: root.fillRadius
		color: root.fillColor

		Behavior on width {
			enabled: root.animated
			NumberAnimation {
				duration: Config.animDurationFast
				easing.type: Easing.OutCubic
			}
		}
	}
}
