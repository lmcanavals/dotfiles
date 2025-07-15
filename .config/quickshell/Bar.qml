import QtQuick
import Quickshell
import "MyShell"

PanelWindow {
    // set screen when instantiating: Bar { screen: parent.modelData }

    color: Config.background

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: child.implicitHeight

    Item {
        id: child

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        implicitHeight: Config.height

        OsIconWidget {
            id: osIcon

            anchors.left: parent.left
        }

        WorkspacesWidget {
            id: workspaces

            anchors.left: osIcon.right
        }

        ClockWidget {
            id: clock

            anchors.centerIn: parent
        }

        BinaryClockWidget {
            id: binClock

            anchors.right: parent.right
        }
    }
}
