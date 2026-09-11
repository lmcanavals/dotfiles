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

            // Header Section: User@Host, System Uptime, TimeDate
            HeaderSection {}

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

            // Volume Control Slider
            RowLayout {
                Layout.fillWidth: true
                spacing: Config.spacing * 2

                MouseArea {
                    implicitWidth: muteIcon.implicitWidth + 4
                    implicitHeight: muteIcon.implicitHeight + 4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: AudioService.toggleMute()

                    StyledText {
                        id: muteIcon

                        text: AudioService.glyph
                        color: AudioService.muted ? Theme.colors.comment : Theme.colors.fg_widget
                    }
                }

                Rectangle {
                    id: track
                    Layout.fillWidth: true
                    implicitHeight: 8
                    radius: 4
                    color: Theme.colors.bg_widget

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width * Math.min(1.0, AudioService.volume)
                        radius: 4
                        color: AudioService.muted ? Theme.colors.comment : Theme.colors.fg_widget
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        function updateVolume(mouseX) {
                            const frac = Math.max(0.0, Math.min(1.0, mouseX / track.width));
                            AudioService.setVolume(frac);
                        }

                        onClicked: mouse => updateVolume(mouse.x)
                        onPositionChanged: mouse => {
                            if (pressed)
                                updateVolume(mouse.x);
                        }
                        onWheel: wheel => {
                            const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
                            AudioService.setVolume(AudioService.volume + delta);
                        }
                    }
                }

                StyledText {
                    text: `${Math.round(AudioService.volume * 100)}%`
                    color: AudioService.muted ? Theme.colors.comment : Theme.colors.fg_widget
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
