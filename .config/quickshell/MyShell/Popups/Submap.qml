import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

import ".."

Scope {
    id: root

    property bool shouldShowOsd: false

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    Connections {
        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }

        target: Pipewire.defaultAudioSink?.audio
    }
    Timer {
        id: hideTimer

        interval: 1000

        onTriggered: root.shouldShowOsd = false
    }
    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors.bottom: true
            color: "transparent"
            exclusiveZone: 0
            implicitHeight: 50
            implicitWidth: 400
            margins.bottom: screen.height / 5

            // An empty click mask prevents the window from blocking mouse events.
            mask: Region {
            }

            Rectangle {
                anchors.fill: parent
                color: Config.background
                radius: height / 2

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 15
                    }
                    IconImage {
                        implicitSize: 30
                        source: Quickshell.iconPath("audio-volume-high-symbolic")
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        color: Config.itemBackground
                        implicitHeight: 10
                        radius: 20

                        Rectangle {
                            implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
                            radius: parent.radius

                            anchors {
                                bottom: parent.bottom
                                left: parent.left
                                top: parent.top
                            }
                        }
                    }
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
