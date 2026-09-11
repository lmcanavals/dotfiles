pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Core
import Primitives
import Services

SurfaceCard {
    id: root

    readonly property var batteryList: UPower.devices.values.filter(d => d && d.isPresent && d.type === UPowerDeviceType.Battery)
    visible: batteryList.length > 0

    implicitWidth: layout.implicitWidth + Config.padding * 2
    implicitHeight: Config.widgetHeight

    RowLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Config.spacing

        Repeater {
            model: root.batteryList

            delegate: MouseArea {
                id: itemArea

                required property UPowerDevice modelData

                implicitHeight: Config.widgetHeight
                implicitWidth: label.implicitWidth + 4
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    DashboardService.toggle(itemArea);
                }

                StyledText {
                    id: label

                    anchors.centerIn: parent
                    color: {
                        const pct = itemArea.modelData.percentage ?? 0.0;
                        if (pct < 0.2 && itemArea.modelData.state !== UPowerDeviceState.Charging) {
                            return Theme.colors.error;
                        } else if (pct < 0.4 && itemArea.modelData.state !== UPowerDeviceState.Charging) {
                            return Theme.colors.warning;
                        } else if (itemArea.modelData.state === UPowerDeviceState.Charging) {
                            return Theme.colors.success;
                        }
                        return Theme.colors.fg_widget;
                    }

                    text: {
                        const icons = ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"];
                        let pct = itemArea.modelData.percentage ?? 0.0;
                        pct = Math.max(0.0, Math.min(0.99, pct));
                        const idx = Math.floor(pct * icons.length);
                        let icon = icons[idx] ?? "󰁹";

                        if (itemArea.modelData.state === UPowerDeviceState.Charging) {
                            icon += " 󱐋";
                        }
                        return `${icon} ${Math.round(pct * 100)}%`;
                    }
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
