import QtQuick
import Core

Rectangle {
	id: root

	required property Flickable target

	property int minHeight: 16
	property int thickness: 3
	property real barRadius: 1.5
	property color barColor: Theme.colors.border

	anchors.left: target?.right
	width: thickness
	radius: barRadius
	color: barColor

	visible: target ? target.visibleArea.heightRatio < 1.0 : false

	readonly property real trackHeight: target?.height ?? 0
	readonly property real computedHeight: Math.max(minHeight, (target?.visibleArea.heightRatio ?? 1) * trackHeight)

	height: computedHeight
	y: Math.max(0, Math.min(trackHeight - height, (target?.visibleArea.yPosition ?? 1) * trackHeight))
}
