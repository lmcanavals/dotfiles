pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Core
import Primitives
import Services

// qmllint disable uncreatable-type
PanelWindow { // qmllint enable uncreatable-type
	id: root

	visible: NotificationService.activeList.count > 0

	anchors {
		top: true
		right: true
	}

	// qmllint disable missing-property
	margins {
		top: Config.padding
		right: Config.padding
	} // qmllint enable missing-property

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
		spacing: Config.spacing
		width: parent.width

		Repeater {
			model: NotificationService.activeList

			delegate: SurfaceCard {
				id: card

				property double lastTimestamp: (card.model && card.model.timestamp) ? card.model.timestamp : 0
				required property var model
				readonly property bool isActionable: Boolean(card.model && card.model.hasDefaultAction)
				readonly property string defaultActionLabel: (card.model && card.model.defaultActionText) ? card.model.defaultActionText : ""
				readonly property bool hasInputFocus: Boolean(replyRow.visible && replyInput.activeFocus)
				readonly property bool isHovered: cardHoverArea.containsMouse

				Layout.fillWidth: true
				color: card.isHovered ? Theme.bgCardHover : Theme.bgCard
				implicitHeight: innerLayout.implicitHeight + (Config.padding * 2)
				onLastTimestampChanged: dismissTimer.restart()

				Timer {
					id: dismissTimer

					interval: 5000
					onTriggered: NotificationService.expireActive(card.model.id)
					running: !card.isHovered && !card.hasInputFocus
				}

				// Restart countdown whenever user unhovers or finishes typing
				Connections {
					target: card
					function onIsHoveredChanged() {
						if (!card.isHovered && !card.hasInputFocus) {
							dismissTimer.restart();
						}
					}
					function onHasInputFocusChanged() {
						if (!card.isHovered && !card.hasInputFocus) {
							dismissTimer.restart();
						}
					}
				}

				// Card-level hover tracking (always active)
				MouseArea {
					id: cardHoverArea

					anchors.fill: parent
					hoverEnabled: true
					acceptedButtons: Qt.NoButton
				}

				// Card-level click for default action (underneath interactive buttons)
				MouseArea {
					id: cardClickArea

					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					enabled: card.isActionable
					onClicked: NotificationService.invokeDefault(card.model.id)
				}

				RowLayout {
					id: innerLayout
					anchors.fill: parent
					anchors.margins: Config.padding
					spacing: Config.spacing

					ThumbnailImage {
						source: card.model?.appIcon ?? ""
					}

					ColumnLayout {
						Layout.alignment: Qt.AlignTop
						// 1. App Header Row
						RowLayout {
							Layout.fillWidth: true
							spacing: Config.spacing

							StyledText {
								text: card.model.appName || "Notification"
								Layout.fillWidth: true
								color: Theme.colors.comment
								font.bold: true
								font.pixelSize: Config.fontSizeTiny
								horizontalAlignment: Text.AlignLeft
							}

							StyledText {
								text: "󰝁"
								color: card.isHovered ? Theme.colors.accent : Theme.colors.comment
								visible: card.isHovered && card.defaultActionLabel.length > 0
							}

							StyledText {
								text: card.defaultActionLabel
								color: card.isHovered ? Theme.colors.accent : Theme.colors.comment
								font.pixelSize: Config.fontSizeTiny
								visible: card.isHovered && card.defaultActionLabel.length > 0
							}

							Item {
								Layout.fillWidth: true
							}

							StyledButton {
								text: Config.iconClose
								onClicked: NotificationService.dismissActive(card.model.id)
							}
						}

						// 2. Main Content Row
						RowLayout {
							Layout.fillWidth: true

							ColumnLayout {
								Layout.fillWidth: true

								StyledText {
									text: card.model.summary
									Layout.fillWidth: true
									font.bold: true
									onLinkActivated: link => Qt.openUrlExternally(link)
									textFormat: Text.StyledText
								}

								StyledText {
									text: card.model.body
									Layout.fillWidth: true
									color: Theme.colors.fg
									font.pixelSize: Config.fontSizeSmall
									onLinkActivated: link => Qt.openUrlExternally(link)
									textFormat: Text.StyledText
									visible: card.model.body.length > 0
									wrapMode: Text.Wrap
								}
							}
						}

						// 3. Interactive Action Buttons Row
						RowLayout {
							Layout.fillWidth: true
							spacing: Config.spacing
							visible: card.model?.actions.count > 0

							Repeater {
								model: card.model?.actions

								delegate: StyledButton {
									id: actionBtn

									required property var model

									text: actionBtn.model.text
									onClicked: NotificationService.invokeAction(card.model.id, actionBtn.model.id)
								}
							}
						}

						// 4. Inline Reply Input Field
						RowLayout {
							id: replyRow

							Layout.fillWidth: true
							spacing: Config.spacing
							visible: card.model && card.model.hasInlineReply

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
										text: card.model?.replyPlaceholder ? card.model.replyPlaceholder : "Type a reply..."
										anchors.fill: parent
										color: Theme.colors.comment
										font.pixelSize: Config.fontSizeSmall
										visible: replyInput.text.length === 0
									}

									onAccepted: {
										const text = replyInput.text.trim();
										replyInput.focus = false;
										if (text.length > 0) {
											NotificationService.sendReply(card.model.id, text);
										}
									}
								}
							}

							StyledButton {
								text: Config.iconSend
								onClicked: {
									const text = replyInput.text.trim();
									replyInput.focus = false;
									if (text.length > 0) {
										NotificationService.sendReply(card.model.id, text);
									}
								}
							}
						}

						ProgressBar {
							id: progressBar

							Layout.fillWidth: true
							value: (card.model && card.model.value !== undefined) ? (Number(card.model.value) / 100.0) : 0.0
							visible: card.model && card.model.value !== undefined && card.model.value >= 0
						}
					}
				}
			}
		}
	}
}
