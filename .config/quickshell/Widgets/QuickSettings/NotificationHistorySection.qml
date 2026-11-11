pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

SurfaceCard {
	id: root

	Layout.fillWidth: true
	Layout.fillHeight: true

	ColumnLayout {
		id: contentLayout
		anchors.fill: parent
		anchors.margins: Config.padding
		spacing: Config.spacing

		SectionHeader {
			title: "Notifications"
			count: NotificationService.unreadCount

			StyledButton {
				visible: NotificationService.historyList.count > 0
				text: "Clear"
				onClicked: NotificationService.clearHistory()
			}
		}

		Item {
			Layout.fillWidth: true
			Layout.fillHeight: true

			StyledText {
				text: "No notifications"
				anchors.centerIn: parent
				color: Theme.colors.comment
				font.pixelSize: Config.fontSizeSmall
				visible: NotificationService.historyList.count === 0
			}

			ListView {
				id: listView
				anchors.fill: parent
				anchors.rightMargin: scrollbar.visible ? scrollbar.width : 0
				clip: true
				spacing: 4
				boundsBehavior: Flickable.StopAtBounds
				model: NotificationService.historyList
				visible: NotificationService.historyList.count > 0

				delegate: Rectangle {
					id: itemCard
					required property var model
					required property int index

					readonly property bool isExpanded: Boolean(itemCard.model && itemCard.model.expanded)

					width: ListView.view ? ListView.view.width : 300
					implicitHeight: rowLayout.implicitHeight + 8
					radius: Config.radius
					color: itemMouseArea.containsMouse ? Theme.bgControlHover : Theme.bgControl

					MouseArea {
						id: itemMouseArea
						anchors.fill: parent
						hoverEnabled: true
						cursorShape: (itemCard.model && itemCard.model.body && itemCard.model.body.length > 0) ? Qt.PointingHandCursor : Qt.ArrowCursor
						onClicked: NotificationService.toggleHistoryExpanded(itemCard.index)
					}

					RowLayout {
						id: rowLayout
						anchors.fill: parent
						anchors.leftMargin: Config.padding
						anchors.rightMargin: Config.padding
						spacing: Config.spacing

						ThumbnailImage {
							source: itemCard.model ? (itemCard.model.appIcon || "") : ""
							minHeight: 32
							maxHeight: 32
							radius: Config.radiusSmall
							showFallback: false
						}

						ColumnLayout {
							Layout.fillWidth: true
							spacing: 2

							RowLayout {
								Layout.fillWidth: true
								spacing: Config.spacing

								StyledText {
									text: (itemCard.model && itemCard.model.appName) ? itemCard.model.appName : "Notification"
									color: (itemCard.model && itemCard.model.urgency === "critical") ? Theme.colors.error : Theme.colors.accent
									font.bold: true
									font.pixelSize: Config.fontSizeSmall
								}

								StyledText {
									visible: itemCard.model && itemCard.model.urgency === "critical"
									text: "󰀦 CRITICAL"
									color: Theme.colors.error
									font.bold: true
									font.pixelSize: Config.fontSizeTiny
								}

								Item {
									Layout.fillWidth: true
								}

								StyledText {
									text: (itemCard.model && itemCard.model.time) ? itemCard.model.time : ""
									font.pixelSize: Config.fontSizeTiny
									color: Theme.colors.comment
								}
							}

							StyledText {
								text: (itemCard.model && itemCard.model.summary) ? itemCard.model.summary : ""
								Layout.fillWidth: true
								color: Theme.colors.fg
								elide: itemCard.isExpanded ? Text.ElideNone : Text.ElideRight
								font.pixelSize: Config.fontSizeSmall
								wrapMode: itemCard.isExpanded ? Text.Wrap : Text.NoWrap
							}

							StyledText {
								visible: itemCard.isExpanded && itemCard.model && itemCard.model.body && itemCard.model.body.length > 0
								text: itemCard.model ? (itemCard.model.body || "") : ""
								font.pixelSize: Config.fontSizeTiny
								color: Theme.colors.fg_dark
								wrapMode: Text.Wrap
								Layout.fillWidth: true
							}

							ProgressBar {
								visible: itemCard.model && itemCard.model.value !== undefined && itemCard.model.value >= 0
								Layout.fillWidth: true
								Layout.topMargin: 2
								implicitHeight: 3
								fillRadius: 1
								fillColor: Theme.colors.accent
								trackColor: Theme.bgTrack
								value: (itemCard.model && itemCard.model.value !== undefined) ? (Number(itemCard.model.value) / 100.0) : 0.0
							}
						}

						StyledButton {
							text: Config.iconClose
							onClicked: NotificationService.removeHistory(itemCard.model.id)
						}
					}
				}
			}

			CustomScrollbar {
				id: scrollbar
				target: listView
			}
		}
	}
}
