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
		top: Config.barHeight + Config.padding
		right: Config.padding
	}
	// qmllint enable unqualified unresolved-type

	implicitWidth: Config.popupWidth
	implicitHeight: notifColumn.implicitHeight
	color: "transparent"

	property Item focusedReplyInput: null
	readonly property bool hasActiveReplyFocus: focusedReplyInput !== null && focusedReplyInput.activeFocus

	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.namespace: "quickshell:notifications"
	WlrLayershell.keyboardFocus: root.hasActiveReplyFocus ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

	ColumnLayout {
		id: notifColumn
		spacing: 8
		width: parent.width

		Repeater {
			model: NotificationService.activeList

			delegate: SurfaceCard {
				id: card
				required property var modelData

				readonly property bool isActionable: Boolean(card.modelData && card.modelData.hasDefaultAction)

				color: Theme.bgSurface
				border.color: (card.isActionable && cardMouseArea.containsMouse) ? Theme.colors.accent : Theme.colors.border
				Layout.fillWidth: true
				implicitHeight: innerLayout.implicitHeight + (Config.padding * 2)

				Timer {
					id: dismissTimer
					interval: 5000
					running: !(replyRow.visible && replyInput.activeFocus)
					onTriggered: NotificationService.expireActive(card.modelData.id)
				}

				property double lastTimestamp: (card.modelData && card.modelData.timestamp) ? card.modelData.timestamp : 0
				onLastTimestampChanged: dismissTimer.restart()

				// Card-level click for default action
				MouseArea {
					id: cardMouseArea
					anchors.fill: parent
					hoverEnabled: true
					cursorShape: card.isActionable ? Qt.PointingHandCursor : Qt.ArrowCursor
					enabled: card.isActionable
					onClicked: {
						NotificationService.invokeDefault(card.modelData.id);
					}
				}

				ColumnLayout {
					id: innerLayout
					anchors.fill: parent
					anchors.margins: Config.padding
					spacing: Config.spacing

					// 1. App Header Row
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
							visible: card.isActionable
							text: "󰌹"
							font.pixelSize: Config.fontSizeSmall
							color: cardMouseArea.containsMouse ? Theme.colors.accent : Theme.colors.comment
						}

						StyledButton {
							text: "󰅖"
							onClicked: NotificationService.dismissActive(card.modelData.id)
						}
					}

					// 2. Main Content Row: Thumbnail + Text
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
								textFormat: Text.StyledText
								onLinkActivated: link => Qt.openUrlExternally(link)
								Layout.fillWidth: true
								elide: Text.ElideRight
							}

							StyledText {
								visible: card.modelData.body.length > 0
								text: card.modelData.body
								font.pixelSize: Config.fontSizeSmall
								color: Theme.colors.fg_dark
								textFormat: Text.StyledText
								onLinkActivated: link => Qt.openUrlExternally(link)
								wrapMode: Text.Wrap
								Layout.fillWidth: true
							}
						}
					}

					// 3. Interactive Action Buttons Row
					RowLayout {
						visible: card.modelData && card.modelData.actions && card.modelData.actions.length > 0
						Layout.fillWidth: true
						spacing: Config.spacing

						Repeater {
							model: card.modelData ? (card.modelData.actions || []) : []

							delegate: StyledButton {
								id: actionBtn
								required property var modelData

								text: actionBtn.modelData.text
								onClicked: {
									NotificationService.invokeAction(card.modelData.id, actionBtn.modelData.id);
								}
							}
						}
					}

					// 4. Inline Reply Input Field
					RowLayout {
						id: replyRow
						visible: card.modelData && card.modelData.hasInlineReply
						Layout.fillWidth: true
						spacing: Config.spacing

						Rectangle {
							Layout.fillWidth: true
							implicitHeight: 28
							radius: Config.radiusSmall
							color: Theme.colors.bg_dark
							border.color: replyInput.activeFocus ? Theme.colors.accent : Theme.colors.border
							border.width: 1

							TextInput {
								id: replyInput
								anchors.fill: parent
								anchors.leftMargin: Config.padding
								anchors.rightMargin: Config.padding
								verticalAlignment: TextInput.AlignVCenter
								color: Theme.colors.fg
								font.family: Config.fontFamily
								font.pixelSize: Config.fontSizeSmall
								clip: true

								onActiveFocusChanged: {
									if (replyInput.activeFocus) {
										root.focusedReplyInput = replyInput;
									} else if (root.focusedReplyInput === replyInput) {
										root.focusedReplyInput = null;
									}
								}

								Component.onDestruction: {
									if (root.focusedReplyInput === replyInput) {
										root.focusedReplyInput = null;
									}
								}

								Keys.onEscapePressed: event => {
									replyInput.focus = false;
									event.accepted = true;
								}

								StyledText {
									anchors.fill: parent
									verticalAlignment: Text.AlignVCenter
									text: (card.modelData && card.modelData.replyPlaceholder) ? card.modelData.replyPlaceholder : "Type a reply..."
									font.pixelSize: Config.fontSizeSmall
									color: Theme.colors.comment
									visible: replyInput.text.length === 0
								}

								onAccepted: {
									const text = replyInput.text.trim();
									replyInput.focus = false;
									if (text.length > 0) {
										NotificationService.sendReply(card.modelData.id, text);
									}
								}
							}
						}

						StyledButton {
							text: "󰒊"
							implicitHeight: 28
							onClicked: {
								const text = replyInput.text.trim();
								replyInput.focus = false;
								if (text.length > 0) {
									NotificationService.sendReply(card.modelData.id, text);
								}
							}
						}
					}

					// 5. Progress Bar
					ProgressBar {
						id: progressBar
						visible: card.modelData && card.modelData.value !== undefined && card.modelData.value >= 0
						Layout.fillWidth: true
						Layout.topMargin: 2
						implicitHeight: 4
						fillRadius: 2
						fillColor: Theme.colors.accent
						trackColor: Theme.bgTrack
						value: (card.modelData && card.modelData.value !== undefined) ? (Number(card.modelData.value) / 100.0) : 0.0
					}
				}
			}
		}
	}
}
