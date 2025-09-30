import Quickshell
import Quickshell.Services.UPower
import ".."

PopupWindow {
    id: batteryPopup

    required property PanelWindow anchorWindow
    property UPowerDevice currentDevice: null

    anchor.rect.x: anchorWindow.width / 2 - width / 2
    anchor.rect.y: anchorWindow.height
    anchor.window: anchorWindow
    color: 'transparent'
    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth
    visible: false

    SimpleWidget {
        id: content

        anchors.centerIn: parent
        implicitHeight: text2.paintedHeight + Config.padding
        implicitWidth: text2.paintedWidth + Config.padding * 2

        StyledText {
            id: text2

            text: `${(batteryPopup.currentDevice?.percentage ?? 0) * 100}%`
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
