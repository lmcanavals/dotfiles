import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

SurfaceCard {
	id: root

	Layout.fillWidth: true
	implicitHeight: 40

	color: mouseArea.containsMouse ? Theme.bgControlHover : Theme.bgControl
	border.color: mouseArea.containsMouse ? Theme.colors.accent : Theme.colors.border
	border.width: 1
	radius: Config.radius

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: DotfilesService.openLazygit()
	}

	RowLayout {
		anchors.fill: parent
		anchors.leftMargin: Config.padding * 2
		anchors.rightMargin: Config.padding * 2
		spacing: Config.spacing * 2

		// Left: Branch icon & Dotfiles title
		RowLayout {
			spacing: Config.spacing

			StyledText {
				text: `󱁻 ${DotfilesService.branch}`
				font.bold: true
				font.pixelSize: Config.fontSizeLarge
				color: Theme.colors.accent
			}
		}

		Item {
			Layout.fillWidth: true
		}

		// Center / Right: Synced status or metric counts (only > 0)
		RowLayout {
			spacing: Config.spacing * 2

			StyledText {
				visible: DotfilesService.isClean
				text: "󰄬 synced"
				color: Theme.colors.success
				font.bold: true
				font.pixelSize: Config.fontSizeSmall
			}

			StyledText {
				visible: DotfilesService.isDiverged
				text: ""
				color: Theme.colors.error
				font.pixelSize: Config.fontSizeSmall
			}

			StyledText {
				visible: DotfilesService.ahead > 0 && !DotfilesService.isDiverged
				text: ` ${DotfilesService.ahead}`
				color: Theme.colors.info
				font.pixelSize: Config.fontSizeSmall
			}

			StyledText {
				visible: DotfilesService.behind > 0 && !DotfilesService.isDiverged
				text: ` ${DotfilesService.behind}`
				color: Theme.colors.warning
				font.pixelSize: Config.fontSizeSmall
			}

			StyledText {
				visible: DotfilesService.staged > 0
				text: ` ${DotfilesService.staged}`
				color: Theme.colors.success
				font.pixelSize: Config.fontSizeSmall
			}

			StyledText {
				visible: DotfilesService.modified > 0
				text: ` ${DotfilesService.modified}`
				color: Theme.colors.warning
				font.pixelSize: Config.fontSizeSmall
			}

			StyledText {
				visible: DotfilesService.untracked > 0
				text: ` ${DotfilesService.untracked}`
				color: Theme.colors.comment
				font.pixelSize: Config.fontSizeSmall
			}
		}

		// Right edge: Launch lazygit glyph
		StyledText {
			text: "󰁔"
			font.pixelSize: Config.fontSizeSmall
			color: mouseArea.containsMouse ? Theme.colors.accent : Theme.colors.fg_dark
		}
	}
}
