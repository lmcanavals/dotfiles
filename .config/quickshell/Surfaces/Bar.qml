import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Core
import Widgets

// qmllint disable uncreatable-type
PanelWindow {
    id: panel

    property var modelData: null
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Config.barHeight + Config.margin * 2
    color: Theme.alpha(Theme.colors.bg, 0.4)

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell:topbar"

    RowLayout {
        anchors.fill: parent
        anchors.margins: Config.margin
        spacing: Config.spacing

        OsIcon {
            id: osIcon
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignVCenter
        }

        Workspaces {
            id: workspaces
            screen: panel.screen
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignVCenter
        }

        ActiveWindow {
            id: activeWindow
            Layout.alignment: Qt.AlignVCenter
        }

        Item {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
        }

        Batteries {
            id: batteries
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignVCenter
        }

        BinaryClock {
            id: binaryClock
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignVCenter
        }

        SysTray {
            id: sysTray
            bar: panel
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
