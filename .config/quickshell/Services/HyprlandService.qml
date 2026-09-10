pragma Singleton

import QtQuick
import Quickshell.Hyprland

QtObject {
    id: root

    readonly property string activeTitle: Hyprland.activeToplevel?.title ?? ""
    property string currentSubmap: ""

    property Connections ipcConn: Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "submap") {
                const parts = event.parse(1);
                root.currentSubmap = (parts && parts.length > 0) ? parts[0].trim() : "";
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
