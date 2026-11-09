pragma Singleton

import QtQuick

// Coordinator singleton for QuickSettings popup surface lifecycle (anchoring and open state).
// Domain services (HardwareService, NetworkService, etc.) manage their own activation state
// driven declaratively by the consuming surface (Surfaces/QuickSettings.qml) to maintain zero service-to-service coupling.
QtObject {
	id: root

	property bool open: false
	property bool hasOpened: false
	property Item targetItem: null

	onOpenChanged: {
		if (root.open) {
			root.hasOpened = true;
		}
	}

	function toggle(item: Item): void {
		if (root.open && root.targetItem === item) {
			root.close();
		} else {
			root.targetItem = item;
			root.open = true;
		}
	}

	function close(): void {
		root.open = false;
	}
}
