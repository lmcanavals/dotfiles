import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    id: row

    Repeater {
        model: {
            return Hyprland.workspaces;
        }
        delegate: Button {
            property bool isInMonitor: modelData.monitor.name === panel.screen.name

            visible: isInMonitor

            background: SimpleWidget {
                color: modelData.focused ? Config.focusedBackground : Config.itemBackground
            }
            contentItem: StyledText {
                id: text

                color: modelData.focused ? Config.focusedForeground : Config.foreground
                text: isInMonitor ? modelData.name : ''
            }
            onClicked: modelData.activate()
        }
    }
}
