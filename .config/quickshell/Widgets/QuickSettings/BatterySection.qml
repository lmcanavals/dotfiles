pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

SurfaceCard {
	id: root

	Layout.fillWidth: true
	implicitHeight: contentLayout.implicitHeight + Config.padding * 2

	ColumnLayout {
		id: contentLayout
		anchors.fill: parent
		anchors.margins: Config.padding
		spacing: Config.spacing

		// Primary Laptop Battery row
		RowLayout {
			visible: PowerService.hasBattery
			Layout.fillWidth: true
			spacing: Config.spacing

			StyledText {
				text: PowerService.primaryGlyph
				color: PowerService.primaryColor
			}

			StyledText {
				text: PowerService.deviceLabelWithState(PowerService.displayDevice)
				font.bold: true
				font.pixelSize: Config.fontSizeLarge
				color: PowerService.primaryColor
				Layout.fillWidth: true
			}

			StyledText {
				visible: PowerService.primaryTimeEstimate.length > 0
				text: PowerService.primaryTimeEstimate
				font.pixelSize: Config.fontSizeTiny
				color: Theme.colors.comment
			}

			StyledText {
				text: PowerService.primaryPercentText
				font.bold: true
				font.pixelSize: Config.fontSizeSmall
				color: PowerService.primaryColor
			}
		}

		// Fallback for AC powered desktop with no battery & no peripherals
		RowLayout {
			visible: !PowerService.hasBattery && PowerService.peripheralCount === 0
			Layout.fillWidth: true
			spacing: Config.spacing

			StyledText {
				text: "󰚥"
				color: Theme.colors.fg_dark
			}

			StyledText {
				text: "AC Powered"
				font.bold: true
				font.pixelSize: Config.fontSizeLarge
				color: Theme.colors.fg_dark
				Layout.fillWidth: true
			}
		}

		// Subtle separator line between primary battery and peripherals
		Rectangle {
			visible: PowerService.hasBattery && PowerService.peripheralCount > 0
			Layout.fillWidth: true
			implicitHeight: 1
			color: Theme.colors.border
		}

		// Peripherals list
		Repeater {
			model: PowerService.peripheralDevices

			delegate: RowLayout {
				id: deviceDelegate
				required property var modelData

				Layout.fillWidth: true
				spacing: Config.spacing

				StyledText {
					text: PowerService.glyphForDevice(deviceDelegate.modelData)
					color: PowerService.colorForDevice(deviceDelegate.modelData)
				}

				StyledText {
					text: PowerService.deviceName(deviceDelegate.modelData)
					font.pixelSize: Config.fontSizeSmall
					Layout.fillWidth: true
					color: Theme.colors.fg
				}

				ProgressBar {
					implicitWidth: 120
					implicitHeight: 6
					fillRadius: 3
					fillColor: PowerService.colorForDevice(deviceDelegate.modelData)
					value: deviceDelegate.modelData?.percentage ?? 0.0
				}

				StyledText {
					text: PowerService.percentText(deviceDelegate.modelData)
					font.pixelSize: Config.fontSizeTiny
					horizontalAlignment: Text.AlignRight
					color: Theme.colors.fg_dark
				}
			}
		}
	}
}
