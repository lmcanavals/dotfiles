import Core
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Widgets

// qmllint disable uncreatable-type
PanelWindow {
	id: panel

	property var modelData: null

	WlrLayershell.layer: WlrLayer.Top
	WlrLayershell.namespace: "quickshell:topbar"
	color: Theme.alpha(Theme.colors.bg, 0.4)
	implicitHeight: Config.barHeight + Config.margin * 2
	screen: modelData

	anchors {
		left: true
		right: true
		top: true
	}
	RowLayout {
		anchors.fill: parent
		anchors.margins: Config.margin
		spacing: Config.spacing

		OsIcon {
			id: osIcon

			Layout.alignment: Qt.AlignVCenter
			Layout.fillWidth: false
		}
		Workspaces {
			id: workspaces

			Layout.alignment: Qt.AlignVCenter
			Layout.fillWidth: false
			screen: panel.screen
		}
		ActiveWindow {
			id: activeWindow

			Layout.alignment: Qt.AlignVCenter
			screen: panel.screen
		}
		MediaPill {
			id: mediaPill

			Layout.alignment: Qt.AlignVCenter
		}
		Item {
			Layout.fillWidth: true
			Layout.minimumWidth: 0
		}
		Batteries {
			id: batteries

			Layout.alignment: Qt.AlignVCenter
			Layout.fillWidth: false
		}
		BinaryClock {
			id: binaryClock

			Layout.alignment: Qt.AlignVCenter
			Layout.fillWidth: false
		}
		SysTray {
			id: sysTray

			Layout.alignment: Qt.AlignVCenter
			Layout.fillWidth: false
			bar: panel
		}
	}
}
