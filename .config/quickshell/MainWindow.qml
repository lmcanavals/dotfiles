import Quickshell

Variants {
    model: Quickshell.screens

    Scope {
        id: scope

        required property ShellScreen modelData

        Bar {
            screen: scope.modelData
        }
    }
}
