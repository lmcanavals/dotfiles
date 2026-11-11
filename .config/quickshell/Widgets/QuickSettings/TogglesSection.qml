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
		glyph: NetworkService.wifiGlyph
		label: NetworkService.wifiConnected ? NetworkService.ssid : (NetworkService.wifiEnabled ? "Disconnected" : "Wi-Fi Off")
		active: NetworkService.wifiEnabled
		busy: NetworkService.busy
		onClicked: NetworkService.toggleWifi()
		onRightClicked: root.trigger(NetworkService.openPicker)
		onMiddleClicked: NetworkService.refresh()
	}

	// Ethernet Toggle
	QuickToggle {
		visible: NetworkService.hasEthernet
		Layout.fillWidth: true
		glyph: NetworkService.ethernetGlyph
		label: NetworkService.ethernetConnected ? NetworkService.ethernetName : "Disconnected"
		active: NetworkService.ethernetConnected
		busy: NetworkService.ethernetBusy
		onClicked: NetworkService.toggleEthernet()
		onRightClicked: root.trigger(NetworkService.openPicker)
		onMiddleClicked: NetworkService.refresh()
	}

	// Bluetooth Toggle
	QuickToggle {
		Layout.fillWidth: true
		glyph: BluetoothService.glyph
		label: BluetoothService.connected ? BluetoothService.connectedDevice : "No device"
		active: BluetoothService.enabled
		busy: BluetoothService.busy
		onClicked: BluetoothService.toggleBluetooth()
		onRightClicked: root.trigger(BluetoothService.openPicker)
		onMiddleClicked: BluetoothService.refresh()
	}

	QuickToggle {
		Layout.fillWidth: true
		glyph: NotificationService.dndActive ? "󰂛" : "󰂚"
		label: "Do not disturb"
		active: NotificationService.dndActive
		onClicked: NotificationService.toggleDnd()
	}

	QuickToggle {
		Layout.fillWidth: true
		glyph: EnvironmentService.idleInhibited ? "󰒳" : "󰒲"
		label: "Keep awake"
		active: EnvironmentService.idleInhibited
		onClicked: EnvironmentService.toggleIdleInhibit()
	}

	QuickToggle {
		Layout.fillWidth: true
		Layout.columnSpan: !NetworkService.hasEthernet ? 2 : 1
		glyph: EnvironmentService.nightLightActive ? "󰖔" : "󰖙"
		label: "Night shift"
		active: EnvironmentService.nightLightActive
		onClicked: EnvironmentService.toggleNightLight()
	}
}
