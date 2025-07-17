pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "MyShell"

RowLayout {
  id: row

  required property ShellScreen screen

  anchors.margins: Config.margin

  Repeater {
	id: repeater

	model: {
	  return Hyprland.workspaces;
	}

	delegate: StyledButton {
	  id: btn

	  required property HyprlandWorkspace modelData

	  focused: modelData.focused
	  text: modelData.name
	  visible: modelData.monitor.name === row.screen.name

	  onClicked: modelData.activate()
	}
  }
}
