import QtQuick
import Quickshell
import "MyShell"
import "MyShell/Widgets"

PanelWindow {
    id: panel

    // set screen when instantiating: Bar { screen: parent.modelData }

    color: Config.background
    implicitHeight: child.implicitHeight

    anchors {
        left: true
        right: true
        top: true
    }
    Item {
        id: child

        implicitHeight: Config.height

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        OsIcon {
            id: osIcon

            anchors.left: parent.left
        }
        Workspaces {
            id: workspaces

            anchors.left: osIcon.right
            screen: panel.screen
        }
        TimeDate {
            id: clock

            anchors.centerIn: parent
        }
        Batteries {
            id: batteries

            anchors.right: sysTray.left
        }
        SysTray {
            id: sysTray

            anchors.right: binClock.left
        }
        BinaryClock {
            id: binClock

            anchors.right: parent.right
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
