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
	property Item _trackedItem: null
	property var _destructionHandler: null

	onOpenChanged: {
		if (root.open) {
			root.hasOpened = true;
		}
	}

	function _detachTarget(): void {
		if (root._trackedItem && root._destructionHandler) {
			root._trackedItem.Component.destruction.disconnect(root._destructionHandler);
		}
		root._trackedItem = null;
		root._destructionHandler = null;
	}

	function _openTarget(item: Item): void {
		root._detachTarget();
		root.targetItem = item;
		root.open = true;
		if (item) {
			const handler = () => {
				if (root.targetItem === item) {
					root.close();
				}
			};
			root._trackedItem = item;
			root._destructionHandler = handler;
			item.Component.destruction.connect(handler);
		}
	}

	function toggle(item: Item): void {
		if (root.open && root.targetItem === item) {
			root.close();
		} else if (root.open) {
			root.close();
			Qt.callLater(() => {
				if (!root.open) {
					root._openTarget(item);
				}
			});
		} else {
			root._openTarget(item);
		}
	}

	function close(): void {
		root._detachTarget();
		root.open = false;
		root.targetItem = null;
	}
}
