pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Core
import Services
import Primitives

// qmllint disable uncreatable-type
PanelWindow { // qmllint enable uncreatable-type
	id: root

	readonly property string submap: HyprlandService.currentSubmap

	visible: root.submap !== ""

	anchors.bottom: true
	// qmllint disable unqualified unresolved-type
	margins.bottom: (screen?.height ?? 1080) / 6 // qmllint enable unqualified unresolved-type
	exclusiveZone: 0

	implicitWidth: content.implicitWidth + Config.padding
	implicitHeight: content.implicitHeight
	color: "transparent"

	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.namespace: "quickshell:osd"

	mask: Region {}

	SurfaceCard {
		id: content

		implicitWidth: label.implicitWidth + Config.padding * 3
		implicitHeight: label.implicitHeight + Config.padding * 2

		StyledText {
			id: label

			anchors.centerIn: parent
			text: root.submap
			font.pixelSize: Config.fontSizeLarge
			color: Theme.colors.fg_widget
		}
	}
}
