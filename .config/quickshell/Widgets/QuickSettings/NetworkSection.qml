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

    // Wi-Fi Dual Action Toggle
    Item {
        Layout.fillWidth: true
        implicitHeight: wifiToggle.implicitHeight

        QuickToggle {
            id: wifiToggle
            anchors.fill: parent
            glyph: NetworkService.glyph
            label: NetworkService.connected ? NetworkService.ssid : (NetworkService.enabled ? "Disconnected" : "Wi-Fi Off")
            active: NetworkService.enabled
            activeColor: Theme.colors.info
            onClicked: NetworkService.toggleWifi()
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            cursorShape: Qt.PointingHandCursor
            onClicked: NetworkService.openPicker()
        }
    }

    // Bluetooth Dual Action Toggle
    Item {
        Layout.fillWidth: true
        implicitHeight: btToggle.implicitHeight

        QuickToggle {
            id: btToggle
            anchors.fill: parent
            glyph: BluetoothService.glyph
            label: BluetoothService.connected ? BluetoothService.connectedDevice : (BluetoothService.enabled ? "Disconnected" : "Bluetooth Off")
            active: BluetoothService.enabled
            activeColor: Theme.colors.accent
            onClicked: BluetoothService.toggleBluetooth()
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            cursorShape: Qt.PointingHandCursor
            onClicked: BluetoothService.openPicker()
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
