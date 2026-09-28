import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

RowLayout {
	id: root

	Layout.fillWidth: true
	spacing: Config.spacing

	StyledButton {
		Layout.fillWidth: true
		text: "󰍃"
		fontSize: Config.fontSizeXL
		onClicked: SessionService.logout()
	}

	StyledButton {
		Layout.fillWidth: true
		text: "󰤄"
		fontSize: Config.fontSizeXL
		onClicked: SessionService.suspend()
	}

	StyledButton {
		Layout.fillWidth: true
		text: ""
		fontSize: Config.fontSizeXL
		onClicked: SessionService.hibernate()
	}

	StyledButton {
		Layout.fillWidth: true
		text: "󰜉"
		fontSize: Config.fontSizeXL
		onClicked: SessionService.reboot()
	}

	StyledButton {
		Layout.fillWidth: true
		text: "󰐥"
		fontSize: Config.fontSizeXL
		onClicked: SessionService.poweroff()
	}
}
