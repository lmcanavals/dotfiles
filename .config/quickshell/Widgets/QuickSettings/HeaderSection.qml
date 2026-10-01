import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

RowLayout {
	Layout.fillWidth: true
	spacing: Config.spacing

	ThumbnailImage {
		source: SystemInfoService.userIcon
		fallbackIcon: ""
		minHeight: 64
		maxHeight: 96
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
				visible: SystemInfoService.realName !== ""
			}

			StyledText {
				Layout.fillWidth: true
				text: "󱎫"
				color: Theme.colors.comment
				font.pixelSize: Config.fontSizeSmall
				horizontalAlignment: Text.AlignRight
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

			StyledText {
				Layout.fillWidth: true
				text: TimeService.shortTime
				font.bold: true
				horizontalAlignment: Text.AlignRight
			}
		}

		StyledText {
			Layout.fillWidth: true
			text: TimeService.formattedTime
			horizontalAlignment: Text.AlignRight
		}
	}
}
