import QtQuick
import Core

Text {
	id: root

	color: Theme.fgWidget
	elide: Text.ElideRight
	font.family: Config.fontFamily
	font.pixelSize: Config.fontSizeBase
	horizontalAlignment: Text.AlignHCenter
	renderType: Text.NativeRendering
	verticalAlignment: Text.AlignVCenter
}
