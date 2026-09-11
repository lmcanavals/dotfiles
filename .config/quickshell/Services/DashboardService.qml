pragma Singleton

import QtQuick

QtObject {
    id: root

    property bool open: false
    property Item targetItem: null

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
// vim: set ts=4 sw=4 et sts=0 :
