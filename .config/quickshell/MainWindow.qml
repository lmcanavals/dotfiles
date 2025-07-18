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
// vim: set ts=4 sw=4 et sts=0 :
