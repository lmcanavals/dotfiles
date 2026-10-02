import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

RowLayout {
	id: root

	Layout.fillWidth: true
	spacing: Config.spacing

	function trigger(action: var): void {
		QuickSettingsService.close();
		action();
	}

	StyledButton {
		Layout.fillWidth: true
		text: "󰍃"
		fontSize: Config.fontSizeXL
		onClicked: root.trigger(SessionService.logout)
	}

	StyledButton {
		Layout.fillWidth: true
		text: "󰤄"
		fontSize: Config.fontSizeXL
		onClicked: root.trigger(SessionService.suspend)
	}

	StyledButton {
		Layout.fillWidth: true
		text: ""
		fontSize: Config.fontSizeXL
		onClicked: root.trigger(SessionService.hibernate)
	}

	StyledButton {
		Layout.fillWidth: true
		text: "󰜉"
		fontSize: Config.fontSizeXL
		onClicked: root.trigger(SessionService.reboot)
	}

	StyledButton {
		Layout.fillWidth: true
		text: "󰐥"
		fontSize: Config.fontSizeXL
		onClicked: root.trigger(SessionService.poweroff)
	}
}
