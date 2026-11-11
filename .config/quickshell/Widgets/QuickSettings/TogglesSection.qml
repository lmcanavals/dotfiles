import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

GridLayout {
	id: root

	Layout.fillWidth: true
	columnSpacing: Config.spacing
	columns: 3
	rowSpacing: Config.spacing

	function trigger(action: var): void {
		QuickSettingsService.close();
		action();
	}

	// Wi-Fi Toggle
	QuickToggle {
		Layout.fillWidth: true
		active: NetworkService.wifiEnabled
		busy: NetworkService.busy
		glyph: NetworkService.wifiGlyph
		label: NetworkService.wifiConnected ? NetworkService.ssid : (NetworkService.wifiEnabled ? "Disconnected" : "None")
		onClicked: NetworkService.toggleWifi()
		onMiddleClicked: NetworkService.refresh()
		onRightClicked: root.trigger(NetworkService.openPicker)
	}

	// Ethernet Toggle
	QuickToggle {
		Layout.fillWidth: true
		active: NetworkService.ethernetConnected
		busy: NetworkService.ethernetBusy
		glyph: NetworkService.ethernetGlyph
		label: NetworkService.ethernetConnected ? NetworkService.ethernetName : "Disconnected"
		onClicked: NetworkService.toggleEthernet()
		onMiddleClicked: NetworkService.refresh()
		onRightClicked: root.trigger(NetworkService.openPicker)
		visible: NetworkService.hasEthernet
	}

	// Bluetooth Toggle
	QuickToggle {
		Layout.fillWidth: true
		active: BluetoothService.enabled
		busy: BluetoothService.busy
		glyph: BluetoothService.glyph
		label: BluetoothService.connected ? BluetoothService.connectedDevice : "None"
		onClicked: BluetoothService.toggleBluetooth()
		onMiddleClicked: BluetoothService.refresh()
		onRightClicked: root.trigger(BluetoothService.openPicker)
	}

	QuickToggle {
		Layout.fillWidth: true
		active: EnvironmentService.nightLightActive
		glyph: EnvironmentService.nightLightActive ? "󰖔" : "󰖙"
		label: "Hyprsunset"
		onClicked: EnvironmentService.toggleNightLight()
	}

	QuickToggle {
		Layout.fillWidth: true
		active: NotificationService.dndActive
		glyph: NotificationService.dndActive ? "󰂛" : "󰂚"
		label: "DND"
		onClicked: NotificationService.toggleDnd()
	}

	QuickToggle {
		Layout.fillWidth: true
		active: EnvironmentService.idleInhibited
		glyph: EnvironmentService.idleInhibited ? "󰒳" : "󰒲"
		label: "Inhibit"
		onClicked: EnvironmentService.toggleIdleInhibit()
	}
}
