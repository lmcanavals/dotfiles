import Quickshell
import "MyShell/Popups"

Variants {
    model: Quickshell.screens

    Scope {
        id: scope

        required property ShellScreen modelData

        Bar {
            screen: scope.modelData
        }
        Volume {
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
