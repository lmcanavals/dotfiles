import QtQuick
import Core

SurfaceCard {
    id: root

    property bool focused: false
    property bool active: false
    property bool urgent: false
    property alias text: label.text
    property alias labelItem: label
    property color focusedColor: Theme.colors.accent
    property color activeColor: Theme.colors.accent_dim
    property color urgentColor: Theme.colors.error
    property color hoverColor: Theme.colors.bg_highlight
    property color normalColor: Theme.colors.bg_widget

    signal clicked(var mouse)

    color: {
        if (urgent)
            return urgentColor;
        if (focused)
            return focusedColor;
        if (active)
            return activeColor;
        return mouseArea.containsMouse ? hoverColor : normalColor;
    }

    Behavior on color {
        ColorAnimation {
            duration: 120
        }
    }

    implicitWidth: label.implicitWidth + Config.padding * 2
    implicitHeight: Config.widgetHeight

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => root.clicked(mouse)
    }

    StyledText {
        id: label

        anchors.centerIn: parent
        color: {
            if (root.urgent || root.focused)
                return Theme.colors.fg_widget_r;
            return Theme.colors.fg;
        }
        font.bold: root.focused || root.active
    }
}
// vim: set ts=4 sw=4 et sts=0 :
