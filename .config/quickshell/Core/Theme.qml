pragma Singleton

import QtQuick

QtObject {
	id: root

	function alpha(c: color, a: real): color {
		return Qt.rgba(c.r, c.g, c.b, Math.max(0.0, Math.min(1.0, a)));
	}

	// Private palette delegate
	readonly property LmcsPalette _palette: LmcsPalette

	// Deprecated backwards-compatibility alias for legacy Theme.colors.* access
	readonly property LmcsPalette colors: root._palette

	// Facade: camelCase aliases mapping to LmcsPalette snake_case properties
	readonly property color bg: root._palette.bg
	readonly property color bgDark: root._palette.bg_dark
	readonly property color bgHighlight: root._palette.bg_highlight
	readonly property color fg: root._palette.fg
	readonly property color fgDark: root._palette.fg_dark
	readonly property color bgWidget: root._palette.bg_widget
	readonly property color bgWidgetR: root._palette.bg_widget_r
	readonly property color fgWidget: root._palette.fg_widget
	readonly property color fgWidgetR: root._palette.fg_widget_r
	readonly property color comment: root._palette.comment
	readonly property color accent: root._palette.accent
	readonly property color accentDim: root._palette.accent_dim
	readonly property color accentAlt: root._palette.accent_alt
	readonly property color border: root._palette.border
	readonly property color shadow: root._palette.shadow
	readonly property color gitAdded: root._palette.git_added
	readonly property color gitModified: root._palette.git_modified
	readonly property color gitDeleted: root._palette.git_deleted
	readonly property color success: root._palette.success
	readonly property color info: root._palette.info
	readonly property color warning: root._palette.warning
	readonly property color error: root._palette.error
	readonly property color muted: root._palette.muted

	// Semantic background colors with consistent transparency levels
	readonly property color bgBar: root.alpha(root.bg, 0.85)
	readonly property color bgSurface: root.alpha(root.bgDark, 0.85)
	readonly property color bgCard: root.alpha(root.bgWidget, 0.6)
	readonly property color bgCardHover: root.alpha(root.bgHighlight, 0.4)
	readonly property color bgControl: root.alpha(root.bgWidget, 0.2)
	readonly property color bgControlHover: root.alpha(root.bgHighlight, 0.4)
	readonly property color bgTrack: root.alpha(root.fgDark, 0.2)
}
