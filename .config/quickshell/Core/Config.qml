pragma Singleton

import QtQuick

QtObject {
	readonly property int barHeight: 32
	readonly property int widgetHeight: 26
	readonly property int workspaceButtonWidth: 28
	readonly property int radiusSmall: 4
	readonly property int radius: 8
	readonly property int radiusLarge: 12
	readonly property int padding: 10
	readonly property int margin: 2
	readonly property int spacing: 8
	readonly property int popupWidth: 360
	readonly property int animDurationFast: 150
	readonly property int animDurationMedium: 250
	readonly property int animDurationSlow: 400
	readonly property string dateFormat: "dddd, d MMMM yyyy"
	readonly property string timeFormat: "HH:mm"
	readonly property string fontFamily: "sans-serif, Font Awesome 7 Free, Symbols Nerd Font"

	// Central Typography Scale
	readonly property int fontSize: 14
	readonly property int fontSizeTiny: fontSize - 4
	readonly property int fontSizeSmall: fontSize - 2
	readonly property int fontSizeBase: fontSize
	readonly property int fontSizeLarge: fontSize + 2
	readonly property int fontSizeXL: fontSize + 10

	readonly property string iconClose: ""
	readonly property string iconOs: "󰣇"
	readonly property string iconSend: "󰒊"
	readonly property string iconSpinner: "󱑊"

	// Workspace Application Icons
	readonly property bool workspaceAppIconDeduplicate: false
	readonly property string workspaceFallbackAppIcon: "application-x-executable"
	readonly property int workspaceAppIconSize: fontSize
	readonly property var workspaceAppIconOverrides: ({
			"battle.net.exe": "lutris_battlenet",
			"warcraft iii.exe": "lutris_warcraft-iii-reforged"
		})
}
