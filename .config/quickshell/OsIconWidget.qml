import "MyShell"

SimpleWidget {
    implicitWidth: text.paintedWidth + Config.padding * 2

    StyledText {
        id: text

        anchors.centerIn: parent
        text: Config.osIcon
    }
}
// vim: set ts=4 sw=4 et sts=0 :
