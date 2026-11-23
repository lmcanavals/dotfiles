pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Core
import Services
import Primitives

ClippingRectangle {
	id: root

	required property ShellScreen screen

	antialiasing: true
	border.color: Theme.border
	border.width: 1
	color: Theme.bgCard
	implicitHeight: Config.widgetHeight
	implicitWidth: layout.implicitWidth
	radius: Config.radius

	RowLayout {
		id: layout

		anchors.centerIn: parent
		spacing: 0

		Repeater {
			model: HyprlandService.workspacesForScreen(root.screen)

			delegate: Rectangle {
				id: wsButton

				required property HyprlandWorkspace modelData

				readonly property var appIcons: HyprlandService.appIconsForWorkspace(modelData)
				readonly property bool isFocused: modelData?.focused ?? false
				readonly property bool isUrgent: modelData?.urgent ?? false
				readonly property bool isActive: modelData?.active ?? false

				readonly property color bgNormal: isFocused ? Theme.bgWidgetR : isUrgent ? Theme.accentDim : isActive ? Theme.bgHighlight : Theme.bgWidget
				readonly property color fgNormal: isFocused ? Theme.fgWidgetR : Theme.fgWidget

				color: mouseArea.containsMouse ? (isFocused ? Theme.bgWidgetR : Theme.bgControlHover) : bgNormal
				radius: 0

				Behavior on color {
					ColorAnimation {
						duration: 120
					}
				}

				implicitHeight: Config.widgetHeight
				implicitWidth: Math.max(Config.workspaceButtonWidth, btnContent.implicitWidth + Config.padding)

				MouseArea {
					id: mouseArea

					anchors.fill: parent
					hoverEnabled: true
					cursorShape: Qt.PointingHandCursor
					onClicked: !wsButton.modelData?.focused && wsButton.modelData?.activate()
				}

				RowLayout {
					id: btnContent

					anchors.centerIn: parent
					spacing: 4

					StyledText {
						text: {
							if (!wsButton.modelData)
								return "";
							const name = wsButton.modelData.name ?? `${wsButton.modelData.id ?? ""}`;
							return name.replace(/^special:/, "");
						}
						color: mouseArea.containsMouse ? (wsButton.isFocused ? Theme.fgWidgetR : Theme.fgWidget) : wsButton.fgNormal
						font.pixelSize: Config.fontSizeBase
					}

					Repeater {
						model: wsButton.appIcons

						delegate: IconImage {
							required property string modelData

							asynchronous: true
							implicitSize: Config.workspaceAppIconSize
							source: modelData
						}
					}
				}
			}
		}
	}
}
