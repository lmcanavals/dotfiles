import QtQuick
import Quickshell.Widgets
import Core

ClippingRectangle {
	id: root

	color: Theme.alpha(Theme.colors.bg_widget, 0.6)
	radius: Config.radius
	border.color: Theme.colors.border
	border.width: 1
}
