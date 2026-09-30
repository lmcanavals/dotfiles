pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Core
import Services
import Primitives

BarPill {
	id: root

	clickable: false

	property ShellScreen screen: null
	readonly property string titleText: HyprlandService.titleForScreen(screen)

	visible: titleText.length > 0

	StyledText {
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: Config.padding
		width: Math.max(0, parent.width - Config.padding * 2)
		text: root.titleText
		elide: Text.ElideRight
	}
}
