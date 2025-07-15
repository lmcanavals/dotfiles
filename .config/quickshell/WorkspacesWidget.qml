import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland
import "MyShell"

RowLayout {
    id: row

    Repeater {
        id: repeater

        model: {
            return Hyprland.workspaces;
        }
        delegate: Button {
            id: btn

            required property HyprlandWorkspace modelData
            property bool isInMonitor: modelData.monitor.name === scope.modelData.name

            visible: isInMonitor

            background: SimpleWidget {
                textContent: text
                color: btn.modelData.focused ? Config.focusedBackground : Config.itemBackground
            }
            contentItem: StyledText {
                id: text

                color: btn.modelData.focused ? Config.focusedForeground : Config.foreground
                text: btn.isInMonitor ? btn.modelData.name : ''
            }
            onClicked: modelData.activate()
        }
    }
}
