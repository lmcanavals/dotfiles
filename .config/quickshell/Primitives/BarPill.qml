pragma ComponentBehavior: Bound

import QtQuick
import Core
import Primitives

SurfaceCard {
	id: root

	property bool clickable: true
	property color bg: Theme.bgCard
	property color bgHover: Theme.bgCardHover

	property int horizontalPadding: Config.padding * 2

	signal clicked
	signal rightClicked
	signal middleClicked
	signal wheel(var wheel)

	color: (clickable && mouseArea.containsMouse) ? bgHover : bg

	Behavior on color {
		ColorAnimation {
			duration: 120
		}
	}

	implicitHeight: Config.widgetHeight
	implicitWidth: {
		for (let i = 0; i < children.length; i++) {
			const child = children[i];
			if (child !== mouseArea && child.implicitWidth > 0) {
				return child.implicitWidth + horizontalPadding;
			}
		}
		return Config.widgetHeight;
	}

	MouseArea {
		id: mouseArea

		anchors.fill: parent
		acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
		cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
		hoverEnabled: root.clickable

		onClicked: mouse => {
			if (!root.clickable)
				return;
			if (mouse.button === Qt.LeftButton) {
				root.clicked();
			} else if (mouse.button === Qt.RightButton) {
				root.rightClicked();
			} else if (mouse.button === Qt.MiddleButton) {
				root.middleClicked();
			}
		}

		onWheel: wheel => {
			if (root.clickable) {
				root.wheel(wheel);
			}
		}
	}
}
