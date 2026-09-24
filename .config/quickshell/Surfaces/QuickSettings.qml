import QtQuick
import QtQuick.Layouts
import Quickshell
import Core
import Primitives
import Services
import Widgets

PopupWindow {
	id: root

	implicitWidth: 360
	implicitHeight: contentLayout.implicitHeight + Config.padding * 4

	visible: QuickSettingsService.open && QuickSettingsService.targetItem !== null
	grabFocus: true

	onVisibleChanged: {
		if (!visible && QuickSettingsService.open) {
			QuickSettingsService.close();
		} else if (visible) {
			BrightnessService.refresh();
		}
	}

	// qmllint disable missing-type
	anchor {
		item: QuickSettingsService.targetItem
		edges: Edges.Bottom
		gravity: Edges.Bottom
	}

	color: "transparent"

	SurfaceCard {
		id: mainCard
		anchors.fill: parent
		color: Theme.bgSurface
		border.color: Theme.colors.border
		border.width: 1
		radius: Config.radius * 2

		ColumnLayout {
			id: contentLayout
			anchors.fill: parent
			anchors.margins: Config.padding * 2
			spacing: Config.spacing * 2

			HeaderSection {}

			BatterySection {}

			DotfilesCard {}

			MetricsSection {}

			SlidersSection {}

			TogglesSection {}

			NotificationHistorySection {}

			SessionSection {}
		}
	}
}
