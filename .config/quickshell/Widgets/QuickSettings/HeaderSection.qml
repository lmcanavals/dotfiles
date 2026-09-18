import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

ColumnLayout {
	id: root

	Layout.fillWidth: true
	spacing: Config.spacing

	// Account and uptime
	RowLayout {
		Layout.fillWidth: true

		StyledText {
			text: ` ${SystemInfoService.username}@${SystemInfoService.hostname}`
			font.bold: true
			color: Theme.colors.accent
		}

		Item {
			Layout.fillWidth: true
		}

		StyledText {
			text: `󱎫 ${SystemInfoService.uptime}`
			color: Theme.colors.comment
			font.pixelSize: Config.fontSize - 2
		}

		StyledButton {
			text: "󰅖"
			onClicked: QuickSettingsService.close()
		}
	}

	// Date and time
	RowLayout {
		Layout.fillWidth: true

		StyledText {
			text: `󰃭 ${TimeService.formattedTime}`
		}

		Item {
			Layout.fillWidth: true
		}

		StyledText {
			text: `󰥔 ${TimeService.shortTime}`
			font.bold: true
		}
	}
}
