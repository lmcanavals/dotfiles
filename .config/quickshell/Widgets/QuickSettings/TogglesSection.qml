import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

GridLayout {
	id: root

	columns: 2
	columnSpacing: Config.spacing
	rowSpacing: Config.spacing
	Layout.fillWidth: true

	function trigger(action: var): void {
		QuickSettingsService.close();
		action();
	}

	// Wi-Fi Toggle
	QuickToggle {
		Layout.fillWidth: true
		glyph: NetworkService.glyph
		label: NetworkService.connected ? NetworkService.ssid : (NetworkService.enabled ? "Disconnected" : "Wi-Fi Off")
		active: NetworkService.enabled
		onClicked: NetworkService.toggleWifi()
		onRightClicked: root.trigger(NetworkService.openPicker)
		onMiddleClicked: NetworkService.refresh()
	}

	// Bluetooth Toggle
	QuickToggle {
		Layout.fillWidth: true
		glyph: BluetoothService.glyph
		label: BluetoothService.connected ? BluetoothService.connectedDevice : (BluetoothService.enabled ? "Disconnected" : "Bluetooth Off")
		active: BluetoothService.enabled
		onClicked: BluetoothService.toggleBluetooth()
		onRightClicked: root.trigger(BluetoothService.openPicker)
		onMiddleClicked: BluetoothService.refresh()
	}

	QuickToggle {
		Layout.fillWidth: true
		glyph: NotificationService.dndActive ? "󰂛" : "󰂚"
		label: "Do Not Disturb"
		active: NotificationService.dndActive
		onClicked: NotificationService.toggleDnd()
	}

	QuickToggle {
		Layout.fillWidth: true
		glyph: EnvironmentService.idleInhibited ? "󰅶" : "󰾪"
		label: "Keep Awake"
		active: EnvironmentService.idleInhibited
		onClicked: EnvironmentService.toggleIdleInhibit()
	}

	QuickToggle {
		Layout.fillWidth: true
		glyph: EnvironmentService.nightLightActive ? "󰖔" : "󰖙"
		label: "Hyprsunset"
		active: EnvironmentService.nightLightActive
		onClicked: EnvironmentService.toggleNightLight()
	}

	QuickToggle {
		Layout.fillWidth: true
		glyph: "󰌾"
		label: "Lock Screen"
		active: false
		onClicked: root.trigger(SessionService.lock)
	}
}
