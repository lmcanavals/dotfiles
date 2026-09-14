import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

RowLayout {
    id: root

    Layout.fillWidth: true
    spacing: Config.spacing

    SessionButton {
        Layout.fillWidth: true
        glyph: "󰍃"
        hoverColor: Theme.colors.warning
        onClicked: SessionService.logout()
    }

    SessionButton {
        Layout.fillWidth: true
        glyph: "󰤄"
        hoverColor: Theme.colors.accent_alt
        onClicked: SessionService.suspend()
    }

    SessionButton {
        Layout.fillWidth: true
        glyph: ""
        hoverColor: Theme.colors.info
        onClicked: SessionService.hibernate()
    }

    SessionButton {
        Layout.fillWidth: true
        glyph: "󰜉"
        hoverColor: Theme.colors.accent
        onClicked: SessionService.reboot()
    }

    SessionButton {
        Layout.fillWidth: true
        glyph: "󰐥"
        hoverColor: Theme.colors.error
        onClicked: SessionService.poweroff()
    }
}
// vim: set ts=4 sw=4 et sts=0 :
