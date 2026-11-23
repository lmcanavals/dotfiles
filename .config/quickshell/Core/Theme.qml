pragma Singleton

import QtQuick

QtObject {
	id: root

	function alpha(c: color, a: real): color {
		return Qt.rgba(c.r, c.g, c.b, Math.max(0.0, Math.min(1.0, a)));
	}

	// Private palette delegate
	final readonly property LmcsPalette _palette: LmcsPalette

	// Facade: camelCase properties mapping to LmcsPalette
	final readonly property color bg: root._palette.bg
	final readonly property color bgDark: root._palette.bgDark
	final readonly property color bgHighlight: root._palette.bgHighlight
	final readonly property color fg: root._palette.fg
	final readonly property color fgDark: root._palette.fgDark
	final readonly property color bgWidget: root._palette.bgWidget
	final readonly property color bgWidgetR: root._palette.bgWidgetR
	final readonly property color fgWidget: root._palette.fgWidget
	final readonly property color fgWidgetR: root._palette.fgWidgetR
	final readonly property color comment: root._palette.comment
	final readonly property color accent: root._palette.accent
	final readonly property color accentDim: root._palette.accentDim
	final readonly property color accentAlt: root._palette.accentAlt
	final readonly property color border: root._palette.border
	final readonly property color shadow: root._palette.shadow
	final readonly property color gitAdded: root._palette.gitAdded
	final readonly property color gitModified: root._palette.gitModified
	final readonly property color gitDeleted: root._palette.gitDeleted
	final readonly property color success: root._palette.success
	final readonly property color info: root._palette.info
	final readonly property color warning: root._palette.warning
	final readonly property color error: root._palette.error
	final readonly property color muted: root._palette.muted

	// Semantic background colors with consistent transparency levels
	final readonly property color bgBar: root.alpha(root.bg, 0.85)
	final readonly property color bgSurface: root.alpha(root.bgDark, 0.85)
	final readonly property color bgCard: root.alpha(root.bgWidget, 0.6)
	final readonly property color bgCardHover: root.alpha(root.bgHighlight, 0.4)
	final readonly property color bgControl: root.alpha(root.bgWidget, 0.2)
	final readonly property color bgControlHover: root.alpha(root.bgHighlight, 0.4)
	final readonly property color bgTrack: root.alpha(root.fgDark, 0.2)

	// Semantic state-to-color helpers for decoupled services
	function updateLevelColor(level: string): color {
		switch (level) {
		case "major":
			return root.error;
		case "minor":
			return root.warning;
		case "patch":
			return root.success;
		case "pre":
			return root.info;
		default:
			return root.comment;
		}
	}

	function metricStateColor(state: string): color {
		switch (state) {
		case "critical":
			return root.error;
		case "warning":
			return root.warning;
		default:
			return root.accent;
		}
	}

	function powerStateColor(state: string): color {
		switch (state) {
		case "charging":
			return root.success;
		case "critical":
			return root.error;
		case "warning":
			return root.warning;
		default:
			return root.fgWidget;
		}
	}
}
