pragma Singleton

import QtQuick

QtObject {
	id: root

	function alpha(c: color, a: real): color {
		return Qt.rgba(c.r, c.g, c.b, Math.max(0.0, Math.min(1.0, a)));
	}

	readonly property LmcsPalette colors: LmcsPalette

	// Semantic background colors with consistent transparency levels
	readonly property color bgBar: root.alpha(root.colors.bg, 0.85)
	readonly property color bgSurface: root.alpha(root.colors.bg_dark, 0.85)
	readonly property color bgCard: root.alpha(root.colors.bg_widget, 0.6)
	readonly property color bgCardHover: root.alpha(root.colors.bg_highlight, 0.4)
	readonly property color bgControl: root.alpha(root.colors.bg_widget, 0.2)
	readonly property color bgControlHover: root.alpha(root.colors.bg_highlight, 0.4)
	readonly property color bgTrack: root.alpha(root.colors.fg_dark, 0.2)
}
