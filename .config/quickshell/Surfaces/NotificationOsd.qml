pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Core
import Primitives
import Services

// qmllint disable uncreatable-type
PanelWindow {
	id: root

	visible: NotificationService.activeList.length > 0

	anchors {
		top: true
		right: true
	}

	// qmllint disable unqualified unresolved-type
	margins {
		top: Config.barHeight + 12
		right: 12
	}
	// qmllint enable unqualified unresolved-type

	implicitWidth: Config.popupWidth
	implicitHeight: notifColumn.implicitHeight
	color: "transparent"

	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.namespace: "quickshell:notifications"

	ColumnLayout {
		id: notifColumn
		spacing: 8
		width: parent.width

		Repeater {
			model: NotificationService.activeList

			delegate: SurfaceCard {
				id: card
				required property var modelData

				Layout.fillWidth: true
				implicitHeight: innerLayout.implicitHeight + (Config.padding * 2)

				Timer {
					id: dismissTimer
					interval: 5000
					running: true
					onTriggered: NotificationService.dismissActive(card.modelData.id)
				}

				property double lastTimestamp: (card.modelData && card.modelData.timestamp) ? card.modelData.timestamp : 0
				onLastTimestampChanged: dismissTimer.restart()

				ColumnLayout {
					id: innerLayout
					anchors.fill: parent
					anchors.margins: Config.padding
					spacing: 4

					RowLayout {
						Layout.fillWidth: true

						StyledText {
							text: "󰂚 " + (card.modelData.appName || "Notification")
							font.bold: true
							font.pixelSize: Config.fontSizeTiny
							color: Theme.colors.comment
							Layout.fillWidth: true
							elide: Text.ElideRight
						}

						StyledText {
							text: "󰅖"
							font.pixelSize: Config.fontSizeSmall
							color: Theme.colors.fg_dark

							MouseArea {
								anchors.fill: parent
								cursorShape: Qt.PointingHandCursor
								onClicked: NotificationService.dismissActive(card.modelData.id)
							}
						}
					}

					RowLayout {
						Layout.fillWidth: true
						spacing: Config.spacing

						ThumbnailImage {
							id: notifThumb
							source: card.modelData ? (card.modelData.appIcon || "") : ""
							minHeight: 64
							maxHeight: 80
							showFallback: false
							Layout.alignment: Qt.AlignTop
						}

						ColumnLayout {
							Layout.fillWidth: true
							Layout.alignment: Qt.AlignVCenter
							spacing: 2

							StyledText {
								text: card.modelData.summary
								font.bold: true
								font.pixelSize: Config.fontSizeLarge
								color: Theme.colors.fg
								Layout.fillWidth: true
								elide: Text.ElideRight
							}

							StyledText {
								visible: card.modelData.body.length > 0
								text: card.modelData.body
								font.pixelSize: Config.fontSizeSmall
								color: Theme.colors.fg_dark
								wrapMode: Text.Wrap
								Layout.fillWidth: true
							}
						}
					}

					ProgressBar {
						id: progressBar
						visible: card.modelData && card.modelData.value !== undefined && card.modelData.value >= 0
						Layout.fillWidth: true
						Layout.topMargin: 2
						implicitHeight: 4
						fillRadius: 2
						fillColor: Theme.colors.accent
						trackColor: Theme.alpha(Theme.colors.fg_dark, 0.25)
						value: (card.modelData && card.modelData.value !== undefined) ? (Number(card.modelData.value) / 100.0) : 0.0
					}
				}
			}
		}
	}
}
