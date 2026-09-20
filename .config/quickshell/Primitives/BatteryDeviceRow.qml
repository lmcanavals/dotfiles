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

	ProgressBar {
		implicitWidth: 70
		implicitHeight: 6
		fillRadius: 3
		fillColor: PowerService.colorForDevice(root.device)
		value: root.device?.percentage ?? 0.0
	}

	StyledText {
		text: PowerService.percentText(root.device)
		font.pixelSize: 10
		horizontalAlignment: Text.AlignRight
		color: Theme.colors.fg_dark
	}
}
