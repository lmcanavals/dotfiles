pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives

RowLayout {
	id: root

	required property string glyph
	required property real value
	required property color barColor
	property string valueText: `${Math.round(Math.max(0.0, Math.min(1.0, root.value)) * 100)}%`

	spacing: Config.spacing * 2

	RowLayout {
		Layout.preferredWidth: 26
		spacing: Config.spacing

		StyledText {
			text: root.glyph
			color: root.barColor
		}
	}

	ProgressBar {
		Layout.fillWidth: true
		implicitHeight: 8
		fillRadius: 4
		fillColor: root.barColor
		value: root.value
	}

	StyledText {
		horizontalAlignment: Text.AlignRight
		text: root.valueText
		font.pixelSize: Config.fontSize - 2
	}
}
