pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Core
import Primitives
import Services

PopupWindow {
	id: root

	required property var modelList
	required property var activeNode
	required property Item anchorItem
	property bool isSourcePicker: false

	visible: false

	implicitWidth: 280
	implicitHeight: contentLayout.implicitHeight + Config.padding * 4

	// qmllint disable missing-type
	anchor {
		item: root.anchorItem
		edges: Edges.Bottom
		gravity: Edges.Bottom
	}
	// qmllint enable missing-type

	color: "transparent"

	SurfaceCard {
		id: mainCard
		anchors.fill: parent
		color: Theme.bgSurface
		border.color: Theme.colors.border
		border.width: 1
		radius: Config.radius * 2

		ColumnLayout {
			id: contentLayout
			anchors.fill: parent
			anchors.margins: Config.padding * 2
			spacing: Config.spacing

			StyledText {
				text: root.isSourcePicker ? "Audio Inputs" : "Audio Outputs"
				font.bold: true
				font.pixelSize: Config.fontSizeLarge
				color: Theme.colors.accent
			}

			Rectangle {
				Layout.fillWidth: true
				implicitHeight: 1
				color: Theme.colors.border
			}

			StyledText {
				visible: !root.modelList || root.modelList.length === 0
				text: "No devices found"
				color: Theme.colors.comment
				font.pixelSize: Config.fontSizeSmall
			}

			Repeater {
				model: root.modelList

				delegate: Rectangle {
					id: itemRect
					required property var modelData

					readonly property bool isSelected: {
						if (!itemRect.modelData || !root.activeNode)
							return false;
						return itemRect.modelData === root.activeNode || (itemRect.modelData.id !== undefined && itemRect.modelData.id === root.activeNode.id);
					}

					Layout.fillWidth: true
					implicitHeight: 26
					radius: Config.radius
					color: itemMouseArea.containsMouse ? Theme.bgControlHover : "transparent"

					MouseArea {
						id: itemMouseArea
						anchors.fill: parent
						hoverEnabled: true
						cursorShape: Qt.PointingHandCursor

						onClicked: {
							if (root.isSourcePicker) {
								AudioService.setSource(itemRect.modelData);
							} else {
								AudioService.setSink(itemRect.modelData);
							}
							root.visible = false;
						}
					}

					RowLayout {
						anchors.fill: parent
						anchors.leftMargin: Config.padding
						anchors.rightMargin: Config.padding
						spacing: Config.spacing

						StyledText {
							text: itemRect.isSelected ? "󰄬" : ""
							color: Theme.colors.accent
							font.bold: true
							font.pixelSize: Config.fontSizeSmall
							Layout.preferredWidth: 16
						}

						StyledText {
							text: AudioService.nodeLabel(itemRect.modelData)
							color: itemRect.isSelected ? Theme.colors.fg : Theme.colors.fg_dark
							font.bold: itemRect.isSelected
							font.pixelSize: Config.fontSizeSmall
							elide: Text.ElideRight
							Layout.fillWidth: true
						}
					}
				}
			}
		}
	}
}
