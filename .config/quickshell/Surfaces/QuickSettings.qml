import QtQuick
import QtQuick.Layouts
import Quickshell
import Core
import Primitives
import Services
import Widgets

PopupWindow {
	id: root

	implicitWidth: mainCard.implicitWidth
	implicitHeight: mainCard.implicitHeight

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

		implicitHeight: contentLayout.implicitHeight + Config.padding * 3
		implicitWidth: 400
		color: Theme.bgSurface

		ColumnLayout {
			id: contentLayout

			anchors {
				left: parent.left
				right: parent.right
				top: parent.top
				margins: Config.padding * 1.5
			}

			spacing: Config.spacing

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
