pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

SurfaceCard {
	id: root

	Layout.fillWidth: true
	implicitHeight: 180

	ColumnLayout {
		id: contentLayout
		anchors.fill: parent
		anchors.margins: Config.padding
		spacing: Config.spacing

		// Header row
		RowLayout {
			Layout.fillWidth: true
			spacing: Config.spacing

			StyledText {
				text: "Notifications"
				font.bold: true
				font.pixelSize: Config.fontSizeLarge
				color: Theme.colors.accent
			}

			Rectangle {
				visible: NotificationService.unreadCount > 0
				implicitWidth: countText.implicitWidth + 8
				implicitHeight: 16
				radius: 8
				color: Theme.alpha(Theme.colors.accent, 0.2)
				border.color: Theme.colors.accent
				border.width: 1

				StyledText {
					id: countText
					anchors.centerIn: parent
					text: `${NotificationService.unreadCount}`
					font.bold: true
					font.pixelSize: Config.fontSizeTiny
					color: Theme.colors.accent
				}
			}

			Item {
				Layout.fillWidth: true
			}

			StyledButton {
				visible: NotificationService.historyList.length > 0
				text: "Clear"
				onClicked: NotificationService.clearHistory()
			}
		}

		// Separator
		Rectangle {
			Layout.fillWidth: true
			implicitHeight: 1
			color: Theme.colors.border
		}

		// Empty placeholder
		Item {
			visible: NotificationService.historyList.length === 0
			Layout.fillWidth: true
			Layout.fillHeight: true

			StyledText {
				anchors.centerIn: parent
				text: "No notifications"
				color: Theme.colors.comment
				font.pixelSize: Config.fontSizeSmall
			}
		}

		// ListView with history items
		ListView {
			id: listView
			visible: NotificationService.historyList.length > 0
			Layout.fillWidth: true
			Layout.fillHeight: true
			clip: true
			spacing: 4
			boundsBehavior: Flickable.StopAtBounds
			model: NotificationService.historyList

			delegate: Rectangle {
				id: itemCard
				required property var modelData
				required property int index

				width: ListView.view ? ListView.view.width : 300
				implicitHeight: rowLayout.implicitHeight + 8
				radius: Config.radius
				color: itemMouseArea.containsMouse ? Theme.bgControlHover : Theme.bgControl

				MouseArea {
					id: itemMouseArea
					anchors.fill: parent
					hoverEnabled: true
				}

				RowLayout {
					id: rowLayout
					anchors.fill: parent
					anchors.leftMargin: Config.padding
					anchors.rightMargin: Config.padding
					spacing: Config.spacing

					ThumbnailImage {
						source: itemCard.modelData ? (itemCard.modelData.appIcon || "") : ""
						minHeight: 32
						maxHeight: 32
						radius: Config.radiusSmall
						showFallback: false
						Layout.alignment: Qt.AlignVCenter
					}

					ColumnLayout {
						Layout.fillWidth: true
						spacing: 2

						RowLayout {
							Layout.fillWidth: true
							spacing: Config.spacing

							StyledText {
								text: itemCard.modelData.appName || "Notification"
								font.bold: true
								font.pixelSize: Config.fontSizeSmall
								color: Theme.colors.accent
								elide: Text.ElideRight
							}

							StyledText {
								text: itemCard.modelData.time || ""
								font.pixelSize: Config.fontSizeTiny
								color: Theme.colors.comment
							}
						}

						StyledText {
							text: itemCard.modelData.summary || ""
							font.pixelSize: Config.fontSizeSmall
							color: Theme.colors.fg
							elide: Text.ElideRight
							Layout.fillWidth: true
						}

						ProgressBar {
							visible: itemCard.modelData && itemCard.modelData.value !== undefined && itemCard.modelData.value >= 0
							Layout.fillWidth: true
							Layout.topMargin: 2
							implicitHeight: 3
							fillRadius: 1
							fillColor: Theme.colors.accent
							trackColor: Theme.bgTrack
							value: (itemCard.modelData && itemCard.modelData.value !== undefined) ? (Number(itemCard.modelData.value) / 100.0) : 0.0
						}
					}

					StyledText {
						text: "󰅖"
						font.pixelSize: Config.fontSizeSmall
						color: Theme.colors.fg_dark

						MouseArea {
							anchors.fill: parent
							cursorShape: Qt.PointingHandCursor
							onClicked: NotificationService.removeHistory(itemCard.modelData.id)
						}
					}
				}
			}
		}
	}
}
