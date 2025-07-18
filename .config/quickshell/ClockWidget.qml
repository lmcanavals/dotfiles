import "MyShell"

SimpleWidget {
    implicitWidth: text.paintedWidth + Config.padding * 2

    StyledText {
        id: text

        text: Time.time
    }
}
// vim: set ts=4 sw=4 et sts=0 :
