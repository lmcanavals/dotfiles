pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Core
import Primitives
import Services

PopupWindow {
	id: root

	implicitWidth: 440
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
		color: Theme.bgSurface

		ColumnLayout {
			id: contentLayout
			anchors.fill: parent
			anchors.margins: Config.padding * 1.5
			spacing: Config.spacing

			// Header Row
			RowLayout {
				Layout.fillWidth: true
				spacing: Config.spacing

				StyledText {
					text: "System Updates"
					font.bold: true
					font.pixelSize: Config.fontSizeLarge
					color: Theme.colors.accent
				}

				StyledText {
					id: countText
					text: `(${UpdatesService.count})`
					font.pixelSize: Config.fontSizeSmall
					visible: UpdatesService.count > 0
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
					font.pixelSize: Config.fontSizeBase
				}

				ListView {
					id: listView
					anchors.fill: parent
					anchors.rightMargin: scrollbar.visible ? 6 : 0
					visible: UpdatesService.updates.length > 0
					clip: true
					boundsBehavior: Flickable.StopAtBounds
					spacing: 2
					model: UpdatesService.updates

					delegate: Item {
						id: delegateRoot
						required property var modelData
						required property int index

						width: listView.width
						implicitHeight: newVerLabel.implicitHeight + Config.spacing / 2

						StyledText {
							id: nameLabel
							text: delegateRoot.modelData.name
							font.pixelSize: Config.fontSizeBase
							elide: Text.ElideRight
							horizontalAlignment: Text.AlignLeft
							anchors.left: delegateRoot.left
							anchors.right: oldVerLabel.visible ? oldVerLabel.left : arrow.visible ? arrow.left : newVerLabel.visible ? newVerLabel.left : delegateRoot.right
							anchors.rightMargin: Config.spacing
							anchors.verticalCenter: delegateRoot.verticalCenter
						}

						StyledText {
							id: oldVerLabel
							visible: delegateRoot.modelData.oldVer.length > 0
							text: delegateRoot.modelData.oldVer
							font.pixelSize: Config.fontSizeSmall
							color: Theme.colors.comment
							horizontalAlignment: Text.AlignRight
							anchors.right: arrow.left
							anchors.verticalCenter: delegateRoot.verticalCenter
						}

						StyledText {
							id: arrow
							visible: delegateRoot.modelData.newVer.length > 0
							text: ""
							font.pixelSize: Config.fontSizeSmall
							color: Theme.colors.comment
							horizontalAlignment: Text.AlignHCenter
							anchors.right: newVerLabel.left
							anchors.verticalCenter: delegateRoot.verticalCenter
							width: 20
						}

						StyledText {
							id: newVerLabel
							visible: delegateRoot.modelData.newVer.length > 0
							text: delegateRoot.modelData.newVer
							font.bold: true
							font.pixelSize: Config.fontSizeBase
							color: Theme.colors.success
							horizontalAlignment: Text.AlignRight
							width: Math.max(85, implicitWidth)
							anchors.right: delegateRoot.right
							anchors.verticalCenter: delegateRoot.verticalCenter
						}
					}
				}

				Rectangle {
					id: scrollbar
					anchors.right: parent.right
					y: Math.max(0, Math.min(parent.height - height, listView.visibleArea.yPosition * listView.height))
					height: Math.max(16, listView.visibleArea.heightRatio * listView.height)
					width: 3
					radius: 1.5
					color: Theme.colors.border
					visible: listView.visibleArea.heightRatio < 1.0
				}
			}
		}
	}
}
