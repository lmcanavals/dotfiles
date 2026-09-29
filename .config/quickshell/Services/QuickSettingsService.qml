pragma Singleton

import QtQuick

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

	function toggle(item: Item) {
		if (root.open && root.targetItem === item) {
			root.close();
		} else {
			root.targetItem = item;
			root.open = true;
		}
	}

	function close() {
		root.open = false;
	}
}
