import QtQuick
import QtQuick.Effects
import "."

Text {
    anchors.centerIn: parent
    color: Config.foreground
    font.pixelSize: Config.height - 10
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Config.shadow
    }
}
