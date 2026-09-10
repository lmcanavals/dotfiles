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

        // qmllint disable unqualified uncreatable-type
        PanelWindow {
            anchors.top: true
            // qmllint disable unqualified unresolved-type
            margins.top: 48
            exclusiveZone: 0

            implicitWidth: content.implicitWidth
            implicitHeight: content.implicitHeight
            color: "transparent"

            mask: Region {}

            SurfaceCard {
                id: content

                color: Theme.colors.error
                radius: Config.radius
                implicitWidth: label.implicitWidth + Config.padding * 3
                implicitHeight: Config.widgetHeight + 4

                StyledText {
                    id: label

                    anchors.centerIn: parent
                    text: `MODE: ${root.submap.toUpperCase()}`
                    color: Theme.colors.fg_widget_r
                    font.bold: true
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
