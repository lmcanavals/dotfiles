import QtQuick
import Core

Text {
	id: root

	color: Theme.colors.fg_widget
	font.family: Config.fontFamily
	font.pixelSize: Config.fontSizeBase
	verticalAlignment: Text.AlignVCenter
	horizontalAlignment: Text.AlignHCenter
	renderType: Text.NativeRendering
}
