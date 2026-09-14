import QtQuick

import QtQuick.Layouts
import Core

Rectangle {
    id: root

    required property string glyph
    required property string label
    property bool active: false
    property color activeColor: Theme.colors.accent

    signal clicked

    implicitWidth: 140
    implicitHeight: 42
    radius: Config.radius

    color: active ? Theme.alpha(activeColor, 0.20) : (mouseArea.containsMouse ? Theme.colors.bg_highlight : Theme.colors.bg_widget)

    border.color: active ? activeColor : Theme.colors.border
    border.width: 1

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 10

        StyledText {
            text: root.glyph
            color: root.active ? root.activeColor : Theme.colors.fg_dark
            font.pixelSize: 16
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            StyledText {
                text: root.label
                color: root.active ? Theme.colors.fg : Theme.colors.fg_dark
                font.bold: root.active
                font.pixelSize: 11
                elide: Text.ElideRight
            }

            StyledText {
                text: root.active ? "On" : "Off"
                color: root.active ? root.activeColor : Theme.colors.comment
                font.pixelSize: 9
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
