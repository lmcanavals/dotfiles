import QtQuick
import QtQuick.Layouts
import Core

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

	Rectangle {
		id: track
		Layout.fillWidth: true
		implicitHeight: 8
		radius: 4
		color: Theme.colors.bg_highlight

		Rectangle {
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			width: parent.width * Math.max(0.0, Math.min(1.0, root.value))
			radius: 4
			color: root.muted ? Theme.colors.comment : root.accentColor

			Behavior on width {
				NumberAnimation {
					duration: 250
					easing.type: Easing.OutCubic
				}
			}
		}

		MouseArea {
			anchors.fill: parent
			cursorShape: Qt.PointingHandCursor

			function applyPosition(mouseX: real): void {
				const ratio = Math.max(0.0, Math.min(1.0, mouseX / track.width));
				root.valueModified(ratio);
			}

			onClicked: mouse => applyPosition(mouse.x)
			onPositionChanged: mouse => {
				if (pressed)
					applyPosition(mouse.x);
			}
			onWheel: wheel => {
				wheel.accepted = true;
				const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
				root.valueModified(Math.max(0.0, Math.min(1.0, root.value + step)));
			}
		}
	}

	StyledText {
		horizontalAlignment: Text.AlignRight
		text: `${Math.round(root.value * 100)}%`
		color: root.muted ? Theme.colors.comment : root.accentColor
	}
}
