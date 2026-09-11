//@ pragma UseQApplication
import QtQuick
import Quickshell
import Surfaces
import Services

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Component {
            Bar {}
        }
    }

    LazyLoader {
        active: DashboardService.open
        Dashboard {}
    }

    VolumeOsd {}
    SubmapIndicator {}
}
// vim: set ts=4 sw=4 et sts=0 :
