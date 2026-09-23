import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

RowLayout {
	id: root

	Layout.fillWidth: true
	spacing: Config.spacing

	ThumbnailImage {
		id: artContainer
		source: "file:///home/lmcs/.face"
		fallbackIcon: ""
		minHeight: 48
		maxHeight: 64
		showFallback: true
	}
	ColumnLayout {

		RowLayout {
			Layout.fillWidth: true

			StyledText {
				text: SystemInfoService.username
				font.bold: true
				font.pixelSize: Config.fontSizeLarge
				color: Theme.colors.accent
			}

			StyledText {
				text: ""
				font.pixelSize: Config.fontSizeLarge
			}

			StyledText {
				text: SystemInfoService.hostname
				font.bold: true
				font.pixelSize: Config.fontSizeLarge
				color: Theme.colors.accent
			}

			Item {
				Layout.fillWidth: true
			}

			StyledText {
				text: `󱎫 ${SystemInfoService.uptime}`
				color: Theme.colors.comment
				font.pixelSize: Config.fontSizeSmall
			}

			StyledButton {
				text: "󰅖"
				onClicked: QuickSettingsService.close()
			}
		}

		RowLayout {
			Layout.fillWidth: true

			StyledText {
				text: TimeService.formattedTime
			}

			Item {
				Layout.fillWidth: true
			}

			StyledText {
				text: TimeService.shortTime
				font.bold: true
			}
		}
	}
}
