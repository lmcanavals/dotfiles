import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Core
import Primitives
import Services

PopupWindow {
    id: root

    implicitWidth: 340
    implicitHeight: contentLayout.implicitHeight + Config.padding * 4

    visible: DashboardService.open && DashboardService.targetItem !== null
    grabFocus: true

    onVisibleChanged: {
        if (!visible && DashboardService.open) {
            DashboardService.close();
        }
    }

    // qmllint disable missing-type
    anchor {
        item: DashboardService.targetItem
        edges: Edges.Bottom
        gravity: Edges.Bottom
    }

    color: "transparent"

    SurfaceCard {
        id: mainCard
        anchors.fill: parent
        color: Theme.colors.bg_dark
        border.color: Theme.colors.border
        border.width: 1
        radius: Config.radius * 2

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: Config.padding * 2
            spacing: Config.spacing * 2

            // Header: Title & Close Action
            RowLayout {
                Layout.fillWidth: true

                StyledText {
                    text: "Quick Controls"
                    color: Theme.colors.fg
                    font.bold: true
                }

                Item {
                    Layout.fillWidth: true
                }

                StyledButton {
                    text: "󰅖"
                    onClicked: DashboardService.close()
                }
            }

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
                        color: Theme.colors.fg
                    }

                    StyledText {
                        text: {
                            const dev = UPower.displayDevice;
                            if (!dev || !dev.isPresent || dev.timeToEmpty <= 0)
                                return "";
                            const mins = Math.round(dev.timeToEmpty / 60);
                            return `${mins} minutes remaining`;
                        }
                        color: Theme.colors.fg_dark
                        font.pixelSize: 10
                        visible: text.length > 0
                    }
                }
            }

            // Volume Control Slider
            RowLayout {
                Layout.fillWidth: true
                spacing: Config.spacing

                MouseArea {
                    implicitWidth: muteIcon.implicitWidth + 4
                    implicitHeight: muteIcon.implicitHeight + 4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: AudioService.toggleMute()

                    StyledText {
                        id: muteIcon
                        anchors.centerIn: parent
                        text: AudioService.muted ? "󰝟" : "󰕾"
                        color: AudioService.muted ? Theme.colors.comment : Theme.colors.accent
                    }
                }

                Rectangle {
                    id: track
                    Layout.fillWidth: true
                    implicitHeight: 8
                    radius: 4
                    color: Theme.colors.bg_highlight

                    Rectangle {
                        width: parent.width * Math.min(1.0, AudioService.volume)
                        height: parent.height
                        radius: 4
                        color: AudioService.muted ? Theme.colors.comment : Theme.colors.accent
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
                    color: Theme.colors.fg_dark
                    font.pixelSize: 11
                    Layout.preferredWidth: 32
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
