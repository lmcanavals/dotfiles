import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

BarPill {
	id: root

	onClicked: UpdatesService.toggle(root)
	onMiddleClicked: UpdatesService.refresh()
	onRightClicked: UpdatesService.checkNow()

	RowLayout {
		id: layout
		anchors.centerIn: parent
		spacing: Config.spacing

		StyledText {
			id: iconGlyph
			text: UpdatesService.count > 0 ? UpdatesService.glyph : Config.osIcon
			font.bold: true
			color: UpdatesService.isChecking ? Theme.colors.info : (UpdatesService.levelCounts.major > 0 ? Theme.colors.error : (UpdatesService.count > 0 ? Theme.colors.warning : Theme.colors.fg_widget))
			opacity: UpdatesService.isChecking ? 0.6 : 1.0

			Behavior on opacity {
				NumberAnimation {
					duration: 200
				}
			}

			Behavior on color {
				ColorAnimation {
					duration: 200
				}
			}
		}

		StyledText {
			visible: UpdatesService.count > 0
			text: `${UpdatesService.count}`
			color: UpdatesService.isChecking ? Theme.colors.info : (UpdatesService.levelCounts.major > 0 ? Theme.colors.error : Theme.colors.warning)
			opacity: UpdatesService.isChecking ? 0.6 : 1.0

			Behavior on opacity {
				NumberAnimation {
					duration: 200
				}
			}

			Behavior on color {
				ColorAnimation {
					duration: 200
				}
			}
		}
	}
}
