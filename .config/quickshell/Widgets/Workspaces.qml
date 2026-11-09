pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Core
import Services
import Primitives

SurfaceCard {
	id: root

	required property ShellScreen screen

	implicitHeight: Config.widgetHeight
	implicitWidth: layout.implicitWidth

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

				readonly property color bgNormal: isFocused ? Theme.colors.bg_widget_r : isUrgent ? Theme.colors.accent_dim : isActive ? Theme.colors.bg_highlight : Theme.colors.bg_widget
				readonly property color fgNormal: isFocused ? Theme.colors.fg_widget_r : Theme.colors.fg_widget

				color: mouseArea.containsMouse ? (isFocused ? Theme.colors.bg_widget_r : Theme.bgControlHover) : bgNormal
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
						color: mouseArea.containsMouse ? (wsButton.isFocused ? Theme.colors.fg_widget_r : Theme.colors.fg_widget) : wsButton.fgNormal
						font.pixelSize: Config.fontSizeBase
					}

					Repeater {
						model: wsButton.appIcons

						delegate: IconImage {
							required property string modelData

							implicitSize: Config.workspaceAppIconSize
							source: modelData
						}
					}
				}
			}
		}
	}
}
