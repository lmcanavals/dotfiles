import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Core
import Services
import Primitives

Scope {
    id: root

    property bool showOsd: false

    Connections {
        target: AudioService

        function onVolumeChanged() {
            root.showOsd = true;
            hideTimer.restart();
        }

        function onMutedChanged() {
            root.showOsd = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer

        interval: 1500
        onTriggered: root.showOsd = false
    }

    LazyLoader {
        active: root.showOsd

        // qmllint disable uncreatable-type
        PanelWindow {
            anchors.bottom: true
            // qmllint disable unqualified unresolved-type
            margins.bottom: (screen?.height ?? 1080) / 6
            exclusiveZone: 0

            implicitWidth: 320
            implicitHeight: 46
            color: "transparent"

            mask: Region {}

            SurfaceCard {
                anchors.fill: parent
                color: Theme.colors.bg_dark
                radius: Config.radius

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: Config.spacing * 2

                    IconImage {
                        implicitSize: 22
                        source: Quickshell.iconPath(AudioService.muted ? "audio-volume-muted-symbolic" : "audio-volume-high-symbolic")
                    }

                    Rectangle {
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
                            color: AudioService.muted ? Theme.colors.comment : Theme.colors.accent
                        }
                    }

                    StyledText {
                        text: `${Math.round(AudioService.volume * 100)}%`
                        color: Theme.colors.fg_widget
                    }
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
