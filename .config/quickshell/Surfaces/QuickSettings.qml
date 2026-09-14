import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Core
import Primitives
import Services
import Widgets

PopupWindow {
    id: root

    implicitWidth: contentLayout.implicitWidth + Config.padding * 4
    implicitHeight: contentLayout.implicitHeight + Config.padding * 4

    visible: QuickSettingsService.open && QuickSettingsService.targetItem !== null
    grabFocus: true

    onVisibleChanged: {
        if (!visible && QuickSettingsService.open) {
            QuickSettingsService.close();
        }
    }

    // qmllint disable missing-type
    anchor {
        item: QuickSettingsService.targetItem
        edges: Edges.Bottom
        gravity: Edges.Bottom
    }

    color: "transparent"

    SurfaceCard {
        id: mainCard
        anchors.fill: parent
        color: Theme.alpha(Theme.colors.bg_dark, 0.4)
        border.color: Theme.colors.border
        border.width: 1
        radius: Config.radius * 2

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: Config.padding * 2
            spacing: Config.spacing * 2

            HeaderSection {}

            NetworkSection {}

            // Battery Information Card
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 50
                radius: Config.radius
                color: Theme.colors.bg_widget

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 2

                    StyledText {
                        text: {
                            const dev = UPower.displayDevice;
                            if (!dev || !dev.isPresent)
                                return "AC Powered";
                            const state = UPowerDeviceState.toString(dev.state);
                            return `${dev.model || "Battery"}: ${Math.round(dev.percentage * 100)}% (${state})`;
                        }
                    }

                    StyledText {
                        text: {
                            const dev = UPower.displayDevice;
                            if (!dev || !dev.isPresent || dev.timeToEmpty <= 0)
                                return "";
                            const mins = Math.round(dev.timeToEmpty / 60);
                            return `${mins} minutes remaining`;
                        }
                        font.pixelSize: Config.fontSize - 2
                        visible: text.length > 0
                    }
                }
            }

            SlidersSection {}

            TogglesSection {}
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
