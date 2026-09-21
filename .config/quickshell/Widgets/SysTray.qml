pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import Core
import Primitives

SurfaceCard {
	id: root

	required property PanelWindow bar

	implicitWidth: layout.implicitWidth + Config.padding * 2
	implicitHeight: Config.widgetHeight

	RowLayout {
		id: layout

		anchors.centerIn: parent
		spacing: Config.spacing

		Repeater {
			model: SystemTray.items

			delegate: Rectangle {
				id: itemArea

				required property SystemTrayItem modelData

				implicitWidth: Config.widgetHeight - 6
				implicitHeight: Config.widgetHeight - 6
				color: "transparent"

				MouseArea {
					anchors.fill: parent
					acceptedButtons: Qt.LeftButton | Qt.RightButton

					onClicked: event => {
						if (event.button === Qt.LeftButton) {
							itemArea.modelData?.activate();
						} else if (itemArea.modelData?.hasMenu) {
							const globalPos = itemArea.mapToItem(null, 0, 0);
							itemArea.modelData.display(root.bar, globalPos.x, globalPos.y + itemArea.height);
						}
					}
				}

				IconImage {
					anchors.fill: parent
					source: itemArea.modelData ? itemArea.modelData.icon : ""
					asynchronous: false
				}
			}
		}
	}
}
