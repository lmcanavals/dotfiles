pragma ComponentBehavior: Bound

import QtQuick
import Core

Rectangle {
	id: root

	required property real value
	property real minValue: 0.0
	property real maxValue: 1.0
	property color accentColor: Theme.colors.accent
	property color trackColor: Theme.colors.bg_highlight
	property bool muted: false
	property real stepSize: 0.05

	signal valueModified(real newValue)

	readonly property real normalized: (root.maxValue > root.minValue) ? Math.max(0.0, Math.min(1.0, (root.value - root.minValue) / (root.maxValue - root.minValue))) : 0.0

	implicitHeight: 8
	radius: Config.radiusSmall
	color: root.trackColor
	clip: true

	Rectangle {
		id: fillBar
		anchors {
			left: parent.left
			top: parent.top
			bottom: parent.bottom
		}
		width: root.width * root.normalized
		radius: root.radius
		color: root.muted ? Theme.colors.muted : root.accentColor

		Behavior on width {
			enabled: !mouseArea.pressed
			NumberAnimation {
				duration: Config.animDurationFast
				easing.type: Easing.OutCubic
			}
		}
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor

		function applyPosition(mouseX: real): void {
			if (root.width <= 0)
				return;
			const ratio = Math.max(0.0, Math.min(1.0, mouseX / root.width));
			const mapped = root.minValue + ratio * (root.maxValue - root.minValue);
			root.valueModified(mapped);
		}

		onClicked: mouse => applyPosition(mouse.x)
		onPositionChanged: mouse => {
			if (pressed) {
				applyPosition(mouse.x);
			}
		}
		onWheel: wheel => {
			wheel.accepted = true;
			const delta = wheel.angleDelta.y > 0 ? root.stepSize : -root.stepSize;
			const clamped = Math.max(root.minValue, Math.min(root.maxValue, root.value + delta));
			root.valueModified(clamped);
		}
	}
}
