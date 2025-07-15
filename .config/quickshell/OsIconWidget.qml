import "MyShell"

SimpleWidget {
    textContent: text

    StyledText {
        id: text

        anchors.centerIn: parent
        text: Config.osIcon
    }
}
