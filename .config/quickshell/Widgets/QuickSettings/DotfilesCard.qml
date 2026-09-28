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

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: DotfilesService.openLazygit()
	}

	RowLayout {
		anchors.fill: parent
		anchors.leftMargin: Config.padding
		anchors.rightMargin: Config.padding
		spacing: Config.spacing

		StyledText {
			text: `󱁻 ${DotfilesService.branch} `
			font.bold: true
			font.pixelSize: Config.fontSizeLarge
			color: Theme.colors.accent
		}

		Item {
			Layout.fillWidth: true
		}

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

		StyledText {
			text: "󰁔"
			font.pixelSize: Config.fontSizeSmall
			color: mouseArea.containsMouse ? Theme.colors.accent : Theme.colors.fg_dark
		}
	}
}
