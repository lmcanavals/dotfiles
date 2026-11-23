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
	implicitWidth: 300

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
					required property int id
					required property bool expanded
					required property string body
					required property string appIcon
					required property string appName
					required property string urgency
					required property string time
					required property string summary
					required property double value

					readonly property bool isExpanded: itemCard.expanded

					width: ListView.view ? ListView.view.width : 300
					implicitHeight: rowLayout.implicitHeight + 8
					radius: Config.radius
					color: itemMouseArea.containsMouse ? Theme.bgControlHover : Theme.bgControl

					MouseArea {
						id: itemMouseArea
						anchors.fill: parent
						hoverEnabled: true
						cursorShape: itemCard.body.length > 0 ? Qt.PointingHandCursor : Qt.ArrowCursor
						onClicked: NotificationService.toggleHistoryExpanded(itemCard.id)
					}

					RowLayout {
						id: rowLayout
						anchors.fill: parent
						anchors.leftMargin: Config.padding
						anchors.rightMargin: Config.padding
						spacing: Config.spacing

						ThumbnailImage {
							source: itemCard.appIcon
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
									text: itemCard.appName || "Notification"
									color: itemCard.urgency === "critical" ? Theme.colors.error : Theme.colors.accent
									font.bold: true
									font.pixelSize: Config.fontSizeSmall
								}

								StyledText {
									visible: itemCard.urgency === "critical"
									text: "󰀦 CRITICAL"
									color: Theme.colors.error
									font.bold: true
									font.pixelSize: Config.fontSizeTiny
								}

								Item {
									Layout.fillWidth: true
								}

								StyledText {
									text: itemCard.time
									font.pixelSize: Config.fontSizeTiny
									color: Theme.colors.comment
								}
							}

							StyledText {
								text: itemCard.summary
								Layout.fillWidth: true
								color: Theme.colors.fg
								elide: itemCard.isExpanded ? Text.ElideNone : Text.ElideRight
								font.pixelSize: Config.fontSizeSmall
								onLinkActivated: link => NotificationService.openSafeLink(link)
								textFormat: Text.StyledText
								wrapMode: itemCard.isExpanded ? Text.Wrap : Text.NoWrap
							}

							StyledText {
								visible: itemCard.isExpanded && itemCard.body.length > 0
								text: itemCard.body
								font.pixelSize: Config.fontSizeTiny
								color: Theme.colors.fg_dark
								onLinkActivated: link => NotificationService.openSafeLink(link)
								textFormat: Text.StyledText
								wrapMode: Text.Wrap
								Layout.fillWidth: true
							}

							ProgressBar {
								visible: itemCard.value >= 0
								Layout.fillWidth: true
								Layout.topMargin: 2
								implicitHeight: 3
								fillRadius: 1
								fillColor: Theme.colors.accent
								trackColor: Theme.bgTrack
								value: Number(itemCard.value) / 100.0
							}
						}

						StyledButton {
							text: Config.iconClose
							onClicked: NotificationService.removeHistory(itemCard.id)
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
