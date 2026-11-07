pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

BarPill {
	id: root

	clickable: true
	onClicked: QuickSettingsService.toggle(root)

	readonly property bool alertMic: AudioService.isMicUnmuted
	readonly property bool alertNetwork: NetworkService.isDisconnected
	readonly property bool alertTemp: HardwareService.isTempUrgent
	readonly property bool alertMem: HardwareService.isMemUrgent
	readonly property bool alertDisk: HardwareService.isDiskUrgent

	readonly property bool hasErrorAlert: alertNetwork || alertTemp || alertMem || alertDisk || PowerService.isCritical
	readonly property bool hasWarningAlert: alertMic || PowerService.isWarning
	readonly property bool hasAlerts: alertMic || alertNetwork || alertTemp || alertMem || alertDisk

	border.color: hasErrorAlert ? Theme.colors.error : (hasWarningAlert ? Theme.colors.warning : Theme.colors.border)

	RowLayout {
		id: layout
		anchors.centerIn: parent
		spacing: Config.spacing

		// Alert badges container
		RowLayout {
			id: alertsRow
			spacing: Config.spacing
			visible: root.hasAlerts

			// Mic unmuted privacy indicator
			StyledText {
				visible: root.alertMic
				text: "󰍬"
				color: Theme.colors.warning
				font.pixelSize: Config.fontSizeSmall
			}

			// Network down indicator
			StyledText {
				visible: root.alertNetwork
				text: "󰤮"
				color: Theme.colors.error
				font.pixelSize: Config.fontSizeSmall
			}

			// Critical temperature warning
			StyledText {
				visible: root.alertTemp
				text: "󰔏"
				color: Theme.colors.error
				font.pixelSize: Config.fontSizeSmall
			}

			// Memory / Swap pressure warning
			StyledText {
				visible: root.alertMem
				text: HardwareService.memUsage >= 0.90 ? "󰍛" : "󰾴"
				color: Theme.colors.error
				font.pixelSize: Config.fontSizeSmall
			}

			// Low disk space warning
			StyledText {
				visible: root.alertDisk
				text: "󰋊"
				color: Theme.colors.error
				font.pixelSize: Config.fontSizeSmall
			}
		}

		// Battery / Power telemetry
		StyledText {
			text: PowerService.primaryGlyph
			color: PowerService.primaryColor
		}

		StyledText {
			text: PowerService.primaryPercentText
			color: PowerService.primaryColor
			visible: PowerService.primaryShowPercent
		}
	}
}
