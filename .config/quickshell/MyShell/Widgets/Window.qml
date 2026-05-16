import QtQuick
import Quickshell
import Quickshell.Hyprland

import ".."

SimpleWidget {
	implicitWidth: text.paintedWidth + Config.padding * 2
	Connections {
		target: Hyprland

		function onRawEvent(event) {
			if (event.name === "activewindow") {
				text.text = event.parse(2)[1]
			}
		}
	}
	StyledText {
		id: text

		text: ""
	}
}
