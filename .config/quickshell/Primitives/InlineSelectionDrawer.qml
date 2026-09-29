pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives

SurfaceCard {
	id: root

	required property string title
	required property var modelList
	property var selectedItem: null
	property var itemLabelFunc: null
	property real maxListHeight: 65

	signal itemSelected(var item)

	color: Theme.bgCard
	radius: Config.radius
	implicitHeight: contentLayout.implicitHeight + Config.padding * 2

	ColumnLayout {
		id: contentLayout
		anchors.fill: parent
		anchors.margins: Config.padding
		spacing: Config.spacing

		StyledText {
			text: root.title
			font.bold: true
			font.pixelSize: Config.fontSizeSmall
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

		Item {
			visible: root.modelList?.length > 0
			Layout.fillWidth: true
			implicitHeight: Math.min(root.maxListHeight, Math.max(26, listView.contentHeight))

			ListView {
				id: listView
				anchors.fill: parent
				anchors.rightMargin: scrollbar.visible ? 6 : 0
				clip: true
				boundsBehavior: Flickable.StopAtBounds
				spacing: 4
				model: root.modelList

				delegate: Rectangle {
					id: itemRect
					required property var modelData

					readonly property bool isSelected: {
						if (!itemRect.modelData || !root.selectedItem)
							return false;
						return itemRect.modelData === root.selectedItem || (itemRect.modelData.id !== undefined && itemRect.modelData.id === root.selectedItem.id);
					}

					width: listView.width
					implicitHeight: 22
					radius: Config.radiusSmall
					color: itemMouseArea.containsMouse ? Theme.bgControlHover : "transparent"

					MouseArea {
						id: itemMouseArea
						anchors.fill: parent
						hoverEnabled: true
						cursorShape: Qt.PointingHandCursor

						onClicked: root.itemSelected(itemRect.modelData)
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
							text: root.itemLabelFunc ? root.itemLabelFunc(itemRect.modelData) : (itemRect.modelData?.name || itemRect.modelData?.description || String(itemRect.modelData))
							color: itemRect.isSelected ? Theme.colors.fg : Theme.colors.fg_dark
							font.bold: itemRect.isSelected
							font.pixelSize: Config.fontSizeSmall
							elide: Text.ElideRight
							Layout.fillWidth: true
						}
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
