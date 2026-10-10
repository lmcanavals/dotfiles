pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Core
import Primitives
import Services

PopupWindow {
	id: root

	implicitWidth: 480
	implicitHeight: 460

	visible: UpdatesService.open && UpdatesService.targetItem !== null
	grabFocus: true

	onVisibleChanged: {
		if (!visible && UpdatesService.open) {
			UpdatesService.close();
		}
	}

	// qmllint disable missing-property
	anchor {
		item: UpdatesService.targetItem
		edges: Edges.Bottom
		gravity: Edges.Bottom
	}
	// qmllint enable missing-property

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

			SectionHeader {
				title: "System Updates"
				count: UpdatesService.count

				StyledButton {
					visible: UpdatesService.count > 0
					text: " Upgrade"
					onClicked: UpdatesService.triggerUpgrade()
				}

				StyledButton {
					text: "󰑮"
					enabled: !UpdatesService.isChecking
					opacity: UpdatesService.isChecking ? 0.5 : 1.0
					onClicked: UpdatesService.checkNow()
				}

				StyledButton {
					text: "󰅖"
					onClicked: UpdatesService.close()
				}
			}

			// Updates List or Empty placeholder
			Item {
				Layout.fillWidth: true
				Layout.fillHeight: true

				StyledText {
					anchors.centerIn: parent
					visible: UpdatesService.updates.length === 0
					text: UpdatesService.isChecking ? "Checking for updates..." : "System is up to date"
					color: UpdatesService.isChecking ? Theme.colors.info : Theme.colors.success
					font.bold: true
				}

				ListView {
					id: listView
					anchors.fill: parent
					anchors.rightMargin: scrollbar.visible ? 6 : 0
					visible: UpdatesService.updates.length > 0
					clip: true
					boundsBehavior: Flickable.StopAtBounds
					spacing: Config.spacing
					model: UpdatesService.updates

					delegate: RowLayout {
						id: delegateRoot
						required property var modelData
						required property int index
						spacing: 0

						width: listView.width
						implicitHeight: newVerChanged.implicitHeight

						StyledText {
							text: {
								const source = delegateRoot.modelData.source || "pacman";
								return source === "pacman" ? "󰮯" : source === "aur" ? "󰢚" : "?";
							}
							Layout.minimumWidth: 20
							color: delegateRoot.modelData.source === "aur" ? Theme.colors.warning : Theme.colors.accent
							font.bold: true
							font.pixelSize: Config.fontSizeTiny
						}

						StyledText {
							text: delegateRoot.modelData.name
							Layout.fillWidth: true
							horizontalAlignment: Text.AlignLeft
						}

						StyledText {
							text: delegateRoot.modelData.old || "?"
							color: Theme.colors.fg
							font.pixelSize: Config.fontSizeSmall
						}

						StyledText {
							text: ""
							Layout.minimumWidth: 20
							color: Theme.colors.fg
							font.pixelSize: Config.fontSizeSmall
						}

						StyledText {
							text: delegateRoot.modelData.unchanged || ""
							Layout.minimumWidth: 85 - newVerChanged.implicitWidth
							color: Theme.colors.fg
							font.pixelSize: Config.fontSizeSmall
							horizontalAlignment: Text.AlignRight
						}

						StyledText {
							id: newVerChanged

							text: delegateRoot.modelData.changed || delegateRoot.modelData.newVer || "?"
							color: UpdatesService.levelColor(delegateRoot.modelData.level)
							font.bold: true
						}
					}
				}

				Rectangle {
					id: scrollbar

					anchors.right: parent.right
					color: Theme.colors.border
					height: Math.max(16, listView.visibleArea.heightRatio * listView.height)
					radius: 1.5
					visible: listView.visibleArea.heightRatio < 1.0
					width: 3
					y: Math.max(0, Math.min(parent.height - height, listView.visibleArea.yPosition * listView.height))
				}
			}

			// Counts and timestamp row
			RowLayout {
				visible: UpdatesService.count > 0
				Layout.fillWidth: true
				spacing: Config.spacing

				StyledText {
					text: `${UpdatesService.levelCounts.major} major`
					color: UpdatesService.levelColor("major")
					font.bold: true
					font.pixelSize: Config.fontSizeTiny
				}

				StyledText {
					text: `${UpdatesService.levelCounts.minor} minor`
					color: UpdatesService.levelColor("minor")
					font.bold: true
					font.pixelSize: Config.fontSizeTiny
				}

				StyledText {
					text: `${UpdatesService.levelCounts.patch} patch`
					color: UpdatesService.levelColor("patch")
					font.bold: true
					font.pixelSize: Config.fontSizeTiny
				}

				StyledText {
					text: `${UpdatesService.levelCounts.pre} pkg release`
					color: UpdatesService.levelColor("pre")
					font.bold: true
					font.pixelSize: Config.fontSizeTiny
				}

				StyledText {
					text: `${UpdatesService.levelCounts.other} other`
					color: UpdatesService.levelColor("other")
					font.bold: true
					font.pixelSize: Config.fontSizeTiny
				}

				Item {
					Layout.fillWidth: true
				}

				StyledText {
					visible: UpdatesService.lastUpdated.length > 0
					text: UpdatesService.lastUpdated.replace("T", " ").substring(0, 19)
					font.pixelSize: Config.fontSizeSmall
					color: Theme.colors.comment
				}
			}
		}
	}
}
