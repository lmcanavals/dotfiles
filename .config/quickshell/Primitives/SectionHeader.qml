pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Core
import Primitives

ColumnLayout {
	id: root

	property string title: ""
	property int count: -1
	property bool showCount: root.count > 0
	property string countText: `(${root.count})`

	property int titleSize: Config.fontSizeLarge
	property int countSize: Config.fontSizeSmall
	property color titleColor: Theme.colors.accent
	property color countColor: Theme.colors.comment

	property bool showSeparator: true

	default property alias actions: actionRow.data

	Layout.fillWidth: true
	spacing: Config.spacing

	RowLayout {
		Layout.fillWidth: true
		spacing: Config.spacing

		StyledText {
			text: root.title
			font.bold: true
			font.pixelSize: root.titleSize
			color: root.titleColor
		}

		StyledText {
			text: root.countText
			font.pixelSize: root.countSize
			color: root.countColor
			visible: root.showCount
		}

		Item {
			Layout.fillWidth: true
		}

		RowLayout {
			id: actionRow
			spacing: Config.spacing
		}
	}

	Rectangle {
		Layout.fillWidth: true
		implicitHeight: 1
		color: Theme.colors.border
		visible: root.showSeparator
	}
}
