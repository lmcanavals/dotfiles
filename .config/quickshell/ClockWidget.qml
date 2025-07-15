import "MyShell"

SimpleWidget {
    textContent: text

    StyledText {
        id: text

        text: Time.time
    }
}
