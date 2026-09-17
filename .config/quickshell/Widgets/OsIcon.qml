import QtQuick
import QtQuick.Layouts
import Core
import Primitives
import Services

SurfaceCard {
    id: root

    implicitWidth: layout.implicitWidth + Config.padding * 2
    implicitHeight: Config.widgetHeight

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                UpdatesService.toggle(root);
            } else if (mouse.button === Qt.MiddleButton || mouse.button === Qt.RightButton) {
                UpdatesService.refresh();
            }
        }
    }

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: Config.spacing

        StyledText {
            text: UpdatesService.count > 0 ? UpdatesService.glyph : Config.osIcon
            font.bold: true
            color: UpdatesService.count > 0 ? Theme.colors.warning : Theme.colors.fg_widget
        }

        StyledText {
            visible: UpdatesService.count > 0
            text: `${UpdatesService.count}`
            color: Theme.colors.warning
        }
    }
}
