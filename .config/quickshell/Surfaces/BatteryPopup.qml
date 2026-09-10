import QtQuick
import Quickshell
import Quickshell.Services.UPower
import Core
import Primitives

PopupWindow {
    id: root

    property UPowerDevice currentDevice: null
    property Item targetItem: null

    anchor.window: targetItem ? targetItem.Window.window : null
    anchor.rect: {
        if (!targetItem) {
            return Qt.rect(0, 0, 0, 0);
        }
        const pos = targetItem.mapToItem(null, 0, 0);
        const win = targetItem.Window.window;
        const barH = win ? win.height : 0;
        return Qt.rect(pos.x, barH + 2, targetItem.width, targetItem.height);
    }

    color: "transparent"
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    SurfaceCard {
        id: content

        anchors.centerIn: parent
        implicitWidth: textLabel.implicitWidth + Config.padding * 2
        implicitHeight: textLabel.implicitHeight + Config.padding

        StyledText {
            id: textLabel

            anchors.centerIn: parent
            text: {
                if (!root.currentDevice)
                    return "No battery detected";
                const pct = Math.round((root.currentDevice.percentage ?? 0) * 100);
                const stateStr = UPowerDeviceState.toString(root.currentDevice.state);
                return `${root.currentDevice.model || "Battery"}: ${pct}% (${stateStr})`;
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
