import QtQuick
import QtQuick.Layouts
import Core
import Primitives

RowLayout {
    id: root

    required property string glyph
    required property real value
    required property color barColor
    property string valueText: `${Math.round(Math.max(0.0, Math.min(1.0, root.value)) * 100)}%`

    spacing: Config.spacing * 2

    RowLayout {
        Layout.preferredWidth: 26
        spacing: Config.spacing

        StyledText {
            text: root.glyph
            color: root.barColor
        }
    }

    Rectangle {
        id: track
        Layout.fillWidth: true
        implicitHeight: 8
        radius: 4
        color: Theme.colors.bg_highlight

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * Math.max(0.0, Math.min(1.0, root.value))
            radius: 4
            color: root.barColor

            Behavior on width {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    StyledText {
        horizontalAlignment: Text.AlignRight
        text: root.valueText
        font.pixelSize: Config.fontSize - 2
    }
}
// vim: set ts=4 sw=4 et sts=0 :
