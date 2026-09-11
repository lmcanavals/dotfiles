import QtQuick
import Quickshell
import Core
import Services
import Primitives

Scope {
    id: root
    readonly property string submap: HyprlandService.currentSubmap
    readonly property bool active: submap.length > 0

    LazyLoader {
        active: root.active

        // qmllint disable uncreatable-type
        PanelWindow {
            anchors.bottom: true
            // qmllint disable unqualified unresolved-type
            margins.bottom: (screen?.height ?? 1080) / 6
            exclusiveZone: 0

            implicitWidth: content.implicitWidth
            implicitHeight: content.implicitHeight
            color: "transparent"

            mask: Region {}

            SurfaceCard {
                id: content

                color: Theme.alpha(Theme.colors.bg_widget_r, 0.7)
                radius: Config.radius
                implicitWidth: label.implicitWidth + Config.padding * 3
                implicitHeight: Config.widgetHeight + 4

                StyledText {
                    id: label

                    anchors.centerIn: parent
                    text: root.submap
                    color: Theme.colors.fg_widget_r
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
