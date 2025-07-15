pragma Singleton

import Quickshell

Singleton {
    readonly property int height: 28
    readonly property int padding: 10
    readonly property int radius: 5

    // data stuff
    readonly property string dateFormat: "HH:mm:ss, dddd d of MMMM"
    readonly property string osIcon: "  btw"

    // colors
    readonly property string foreground: "white"
    readonly property string background: "#991e1e2e"
    readonly property string focusedBackground: "#ccfab387"
    readonly property string focusedForeground: "black"
    readonly property string itemBackground: "#88444444"
    readonly property string shadow: "crimson"
}
