pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

RowLayout {
	id: root

	required property var device

	spacing: Config.spacing

	StyledText {
		text: PowerService.glyphForDevice(root.device)
		font.pixelSize: 14
		color: PowerService.colorForDevice(root.device)
	}

	StyledText {
		text: PowerService.deviceName(root.device)
		font.pixelSize: 11
		Layout.fillWidth: true
		elide: Text.ElideRight
		color: Theme.colors.fg
	}

	Rectangle {
		implicitWidth: 70
		implicitHeight: 6
		radius: 3
		color: Theme.colors.bg_highlight

		Rectangle {
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			width: parent.width * Math.max(0.0, Math.min(1.0, root.device?.percentage ?? 0.0))
			radius: 3
			color: PowerService.colorForDevice(root.device)
		}
	}

	StyledText {
		text: PowerService.percentText(root.device)
		font.pixelSize: 10
		horizontalAlignment: Text.AlignRight
		color: Theme.colors.fg_dark
	}
}
