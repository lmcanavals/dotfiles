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
	color: Theme.bgBar
	implicitHeight: Config.barHeight
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

		OsIcon {}

		Workspaces {
			screen: panel.screen
		}

		ActiveWindow {
			id: activeWindow

			Layout.fillWidth: true
			screen: panel.screen
		}

		Item {
			Layout.fillWidth: true
			visible: !activeWindow.visible
		}

		MediaPill {}

		KeyboardLayout {}

		Batteries {}

		BinaryClock {}

		SysTray {
			bar: panel
		}
	}
}
