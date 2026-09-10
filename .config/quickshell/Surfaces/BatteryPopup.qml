import QtQuick
import Quickshell
import Quickshell.Services.UPower
import Core
import Primitives

PopupWindow {
    id: root

    property UPowerDevice currentDevice: null
    property Item targetItem: null

    // qmllint disable missing-type
    anchor {
        item: root.targetItem
        edges: Edges.Bottom
        gravity: Edges.Bottom
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
