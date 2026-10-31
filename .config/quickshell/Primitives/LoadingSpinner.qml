import QtQuick
import Core

Item {
	id: root

	property bool running: true
	property string glyph: Config.iconSpinner
	property color color: Theme.colors.info
	property int fontSize: Config.fontSizeBase
	property int duration: 1000

	implicitWidth: Math.max(label.implicitWidth, label.implicitHeight)
	implicitHeight: Math.max(label.implicitWidth, label.implicitHeight)

	StyledText {
		id: label
		anchors.centerIn: parent
		text: root.glyph
		color: root.color
		font.pixelSize: root.fontSize

		NumberAnimation on rotation {
			loops: Animation.Infinite
			from: 0
			to: 360
			duration: root.duration
			running: root.running
		}
	}
}
