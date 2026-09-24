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
		source: SystemInfoService.userIcon
		fallbackIcon: ""
		minHeight: 48
		maxHeight: 64
		showFallback: true
	}

	ColumnLayout {

		RowLayout {
			Layout.fillWidth: true

			StyledText {
				text: SystemInfoService.realName
				font.bold: true
				font.pixelSize: Config.fontSizeLarge
				color: Theme.colors.accent
			}

			Item {
				Layout.fillWidth: true
			}

			StyledText {
				text: "󱎫"
				color: Theme.colors.comment
				font.pixelSize: Config.fontSizeSmall
			}

			StyledText {
				text: SystemInfoService.uptime
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
				text: SystemInfoService.username
				font.bold: true
				color: Theme.colors.success
			}

			StyledText {
				text: ""
				color: Theme.colors.fg
			}

			StyledText {
				text: SystemInfoService.hostname
				font.bold: true
			}

			Item {
				Layout.fillWidth: true
			}

			StyledText {
				text: TimeService.shortTime
				font.bold: true
			}
		}

		RowLayout {
			Layout.fillWidth: true

			Item {
				Layout.fillWidth: true
			}

			StyledText {
				text: TimeService.formattedTime
			}
		}
	}
}
