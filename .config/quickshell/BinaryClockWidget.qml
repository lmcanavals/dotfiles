import "MyShell"

SimpleWidget {
    textContent: text

    StyledText {
        id: text

        text: BinaryTime.time
    }
}
