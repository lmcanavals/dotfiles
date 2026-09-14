import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

GridLayout {
    id: root

    columns: 2
    columnSpacing: Config.spacing
    rowSpacing: Config.spacing
    Layout.fillWidth: true

    QuickToggle {
        Layout.fillWidth: true
        glyph: EnvironmentService.dndActive ? "󰂛" : "󰂚"
        label: "Do Not Disturb"
        active: EnvironmentService.dndActive
        activeColor: Theme.colors.warning
        onClicked: EnvironmentService.toggleDnd()
    }

    QuickToggle {
        Layout.fillWidth: true
        glyph: EnvironmentService.idleInhibited ? "󰅶" : "󰾪"
        label: "Keep Awake"
        active: EnvironmentService.idleInhibited
        activeColor: Theme.colors.accent
        onClicked: EnvironmentService.toggleIdleInhibit()
    }

    QuickToggle {
        Layout.fillWidth: true
        glyph: EnvironmentService.nightLightActive ? "󰖔" : "󰖙"
        label: "Hyprsunset"
        active: EnvironmentService.nightLightActive
        activeColor: Theme.colors.accent_alt
        onClicked: EnvironmentService.toggleNightLight()
    }

    QuickToggle {
        Layout.fillWidth: true
        glyph: "󰌾"
        label: "Lock Screen"
        active: false
        activeColor: Theme.colors.info
        onClicked: {
            QuickSettingsService.close();
            EnvironmentService.lockSession();
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
