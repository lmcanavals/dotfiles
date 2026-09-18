pragma ComponentBehavior: Bound
import Core
import Primitives

import QtQuick
import QtQuick.Layouts
import Services

SurfaceCard {
	id: root

	Layout.fillWidth: true
	Layout.minimumWidth: 60
	implicitHeight: Config.widgetHeight
	visible: MediaService.hasPlayer

	MouseArea {
		id: mouseArea

		acceptedButtons: Qt.LeftButton | Qt.MiddleButton
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		hoverEnabled: true

		onClicked: mouse => {
			if (mouse.button === Qt.LeftButton) {
				MediaService.toggle(root);
			} else if (mouse.button === Qt.MiddleButton) {
				MediaService.playPause();
			}
		}
		onWheel: wheel => {
			wheel.accepted = true;
			const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
			MediaService.adjustVolume(step);
		}
	}
	RowLayout {
		id: layout

		anchors.fill: parent
		anchors.leftMargin: Config.padding
		anchors.rightMargin: Config.padding
		spacing: Config.spacing

		StyledText {
			color: MediaService.isPlaying ? Theme.colors.accent : Theme.colors.fg_widget
			text: MediaService.isPlaying ? "󰏤" : "󰐊"
		}
		StyledText {
			readonly property string trackLabel: {
				if (MediaService.artist.length > 0 && MediaService.title.length > 0)
					return `${MediaService.artist} - ${MediaService.title}`;
				return MediaService.title.length > 0 ? MediaService.title : MediaService.artist;
			}

			Layout.fillWidth: true
			color: MediaService.isPlaying ? Theme.colors.fg_widget : Theme.colors.comment
			elide: Text.ElideRight
			text: trackLabel
		}
	}
}
