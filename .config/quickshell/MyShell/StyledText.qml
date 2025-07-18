import QtQuick
import QtQuick.Effects
import "."

Text {
    anchors.centerIn: parent
    color: Config.foreground
    font.pixelSize: Config.height - 10
    layer.enabled: true

    layer.effect: MultiEffect {
        shadowColor: Config.shadow
        shadowEnabled: true
    }
}
// vim: set ts=4 sw=4 et sts=0 :
