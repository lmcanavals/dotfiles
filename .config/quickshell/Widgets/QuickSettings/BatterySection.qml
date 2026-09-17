pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

SurfaceCard {
    id: root

    Layout.fillWidth: true
    implicitHeight: contentLayout.implicitHeight + Config.padding * 2

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: Config.padding
        spacing: Config.spacing

        // Primary Laptop Battery row
        ColumnLayout {
            visible: PowerService.hasBattery
            Layout.fillWidth: true
            spacing: 2

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.spacing

                StyledText {
                    text: PowerService.primaryGlyph
                    font.pixelSize: 14
                    color: PowerService.primaryColor
                }

                StyledText {
                    text: PowerService.deviceLabelWithState(PowerService.displayDevice)
                    font.bold: true
                    font.pixelSize: 11
                    color: Theme.colors.fg
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                StyledText {
                    visible: PowerService.primaryTimeEstimate.length > 0
                    text: PowerService.primaryTimeEstimate
                    font.pixelSize: 10
                    color: Theme.colors.comment
                }

                StyledText {
                    text: PowerService.primaryPercentText
                    font.bold: true
                    font.pixelSize: 11
                    color: Theme.colors.fg
                }
            }
        }

        // Fallback for AC powered desktop with no battery & no peripherals
        RowLayout {
            visible: !PowerService.hasBattery && PowerService.peripheralCount === 0
            Layout.fillWidth: true
            spacing: Config.spacing

            StyledText {
                text: "󰚥"
                font.pixelSize: 14
                color: Theme.colors.fg_dark
            }

            StyledText {
                text: "AC Powered"
                font.bold: true
                font.pixelSize: 11
                color: Theme.colors.fg_dark
                Layout.fillWidth: true
            }
        }

        // Subtle separator line between primary battery and peripherals
        Rectangle {
            visible: PowerService.hasBattery && PowerService.peripheralCount > 0
            Layout.fillWidth: true
            implicitHeight: 1
            color: Theme.colors.border
        }

        // Peripherals list
        Repeater {
            model: PowerService.peripheralDevices

            delegate: BatteryDeviceRow {
                id: deviceDelegate
                required property var modelData

                Layout.fillWidth: true
                device: deviceDelegate.modelData
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
