import QtQuick
import Quickshell
import Quickshell.Wayland
import Services

/*
 * NOTE: WaylandIntegrations Surface
 * Architectural Note:
 * This headless PanelWindow provides an active Wayland surface (wl_surface)
 * required by Wayland protocols (such as zwp_idle_inhibit_manager_v1 for IdleInhibitor).
 * In accordance with Clean Architecture principles:
 * - Domain services (EnvironmentService) remain purely headless and UI-agnostic.
 * - Wayland protocol objects that require a wl_surface anchor to this dedicated,
 *   transparent, non-interactive integration surface rather than forcing services
 *   to couple directly with visual UI surfaces like Bar.qml.
 */
// qmllint disable uncreatable-type
PanelWindow { // qmllint enable uncreatable-type
	id: root

	WlrLayershell.layer: WlrLayer.Background
	WlrLayershell.namespace: "quickshell:integrations"

	color: "transparent"
	mask: Region {} // Ensures mouse clicks pass straight through

	implicitWidth: 1
	implicitHeight: 1

	IdleInhibitor {
		window: root
		enabled: EnvironmentService.idleInhibited
	}
}
