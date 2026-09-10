pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import Core
import Primitives

SurfaceCard {
    id: root

    required property PanelWindow bar

    implicitWidth: layout.implicitWidth + Config.padding * 2
    implicitHeight: Config.widgetHeight

    RowLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Config.spacing

        Repeater {
            model: SystemTray.items

            delegate: MouseArea {
                id: itemArea

                required property SystemTrayItem modelData

                acceptedButtons: Qt.LeftButton | Qt.RightButton
                implicitWidth: Config.widgetHeight - 6
                implicitHeight: Config.widgetHeight - 6

                onClicked: event => {
                    if (event.button === Qt.LeftButton) {
                        modelData?.activate();
                    } else if (modelData?.hasMenu) {
                        const globalPos = itemArea.mapToItem(null, 0, 0);
                        modelData.display(root.bar, globalPos.x, globalPos.y + itemArea.height);
                    }
                }

                IconImage {
                    anchors.fill: parent
                    source: itemArea.modelData ? itemArea.modelData.icon : ""
                    asynchronous: true
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
