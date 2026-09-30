import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

BarPill {
	id: root

	onClicked: UpdatesService.toggle(root)
	onMiddleClicked: UpdatesService.refresh()
	onRightClicked: UpdatesService.refresh()

	RowLayout {
		id: layout
		anchors.centerIn: parent
		spacing: Config.spacing

		StyledText {
			text: UpdatesService.count > 0 ? UpdatesService.glyph : Config.osIcon
			font.bold: true
			color: UpdatesService.count > 0 ? Theme.colors.warning : Theme.colors.fg_widget
		}

		StyledText {
			visible: UpdatesService.count > 0
			text: `${UpdatesService.count}`
			color: Theme.colors.warning
		}
	}
}
