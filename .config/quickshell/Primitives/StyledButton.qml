import QtQuick
import Core

SurfaceCard {
    id: root

    property bool active: false
    property alias text: label.text
    property alias labelItem: label
    property color activeColor: Theme.colors.accent
    property color hoverColor: Theme.colors.bg_highlight
    property color normalColor: Theme.colors.bg_widget

    signal clicked(var mouse)

    color: active ? activeColor : (mouseArea.containsMouse ? hoverColor : normalColor)

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
        color: root.active ? Theme.colors.fg_widget_r : Theme.colors.fg
        font.bold: root.active
    }
}
// vim: set ts=4 sw=4 et sts=0 :
