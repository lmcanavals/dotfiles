pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Core
import Primitives
import Services

PopupWindow {
	id: root

	implicitWidth: 380
	implicitHeight: 440

	visible: UpdatesService.open && UpdatesService.targetItem !== null
	grabFocus: true

	onVisibleChanged: {
		if (!visible && UpdatesService.open) {
			UpdatesService.close();
		}
	}

	// qmllint disable missing-type
	anchor {
		item: UpdatesService.targetItem
		edges: Edges.Bottom
		gravity: Edges.Bottom
	}
	// qmllint enable missing-type

	color: "transparent"

	SurfaceCard {
		id: mainCard
		anchors.fill: parent
		color: Theme.alpha(Theme.colors.bg_dark, 0.4)
		border.color: Theme.colors.border
		border.width: 1
		radius: Config.radius * 2

		ColumnLayout {
			id: contentLayout
			anchors.fill: parent
			anchors.margins: Config.padding * 2
			spacing: Config.spacing * 2

			// Header Row
			RowLayout {
				Layout.fillWidth: true
				spacing: Config.spacing

				StyledText {
					text: "System Updates"
					font.bold: true
				}

				Rectangle {
					visible: UpdatesService.count > 0
					implicitWidth: countText.implicitWidth + Config.padding * 2
					implicitHeight: 26
					radius: Config.radius
					color: Theme.alpha(Theme.colors.warning, 0.2)
					border.color: Theme.colors.warning
					border.width: 1

					StyledText {
						id: countText
						anchors.centerIn: parent
						text: `${UpdatesService.count}`
						color: Theme.colors.warning
					}
				}

				Item {
					Layout.fillWidth: true
				}

				StyledButton {
					visible: UpdatesService.count > 0
					text: " Upgrade"
					onClicked: UpdatesService.triggerUpgrade()
				}

				StyledButton {
					text: "󰅖"
					onClicked: UpdatesService.close()
				}
			}

			// Separator
			Rectangle {
				Layout.fillWidth: true
				implicitHeight: 1
				color: Theme.colors.border
			}

			// Updates List or Empty placeholder
			Item {
				Layout.fillWidth: true
				Layout.fillHeight: true

				StyledText {
					anchors.centerIn: parent
					visible: UpdatesService.updates.length === 0
					text: "System is up to date"
					color: Theme.colors.success
					font.bold: true
				}

				ListView {
					id: listView
					anchors.fill: parent
					visible: UpdatesService.updates.length > 0
					clip: true
					boundsBehavior: Flickable.StopAtBounds
					spacing: 2
					model: UpdatesService.updates

					delegate: Item {
						id: delegateRoot
						required property string modelData
						required property int index

						width: listView.width
						implicitHeight: 28

						Rectangle {
							anchors.fill: parent
							color: delegateRoot.index % 2 === 0 ? Theme.alpha(Theme.colors.bg_highlight, 0.2) : "transparent"
							radius: Config.radius

							RowLayout {
								id: rowLayout
								anchors.fill: parent
								anchors.leftMargin: Config.padding
								anchors.rightMargin: Config.padding
								spacing: Config.spacing

								readonly property var parts: {
									const m = delegateRoot.modelData.match(/^(\S+)\s+(.+?)\s+->\s+(\S+)$/);
									if (m) {
										return {
											name: m[1],
											oldVer: m[2],
											newVer: m[3]
										};
									}
									return {
										name: delegateRoot.modelData,
										oldVer: "",
										newVer: ""
									};
								}

								StyledText {
									text: rowLayout.parts.name
									font.pixelSize: Config.fontSize - 4
									color: Theme.colors.fg
									elide: Text.ElideRight
									Layout.fillWidth: true
								}

								StyledText {
									visible: rowLayout.parts.oldVer.length > 0
									text: rowLayout.parts.oldVer
									font.pixelSize: Config.fontSize - 4
									color: Theme.colors.fg
									horizontalAlignment: Text.AlignRight
								}

								StyledText {
									visible: rowLayout.parts.newVer.length > 0
									text: ""
									font.pixelSize: Config.fontSize - 4
									color: Theme.colors.fg
									horizontalAlignment: Text.AlignHCenter
								}

								StyledText {
									visible: rowLayout.parts.newVer.length > 0
									text: rowLayout.parts.newVer
									font.bold: true
									font.pixelSize: Config.fontSize - 2
									color: Theme.colors.accent
									horizontalAlignment: Text.AlignRight
									Layout.preferredWidth: 80
								}
							}
						}
					}
				}

				// Subtle scrollbar indicator
				Rectangle {
					anchors.right: parent.right
					y: listView.visibleArea.yPosition * listView.height
					height: Math.max(16, listView.visibleArea.heightRatio * listView.height)
					width: 3
					radius: 1.5
					color: Theme.colors.border
					visible: listView.visibleArea.heightRatio < 1.0 && UpdatesService.updates.length > 0
				}
			}
		}
	}
}
