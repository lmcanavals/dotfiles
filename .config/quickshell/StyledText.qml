import QtQuick
import QtQuick.Effects

Text {
    id: text
    anchors.centerIn: parent
    color: Config.foreground
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "red"
    }
}
