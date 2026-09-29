//@ pragma UseQApplication
import QtQuick
import Quickshell
import Surfaces
import Services

ShellRoot {
	Variants {
		model: Quickshell.screens
		delegate: Component {
			Bar {}
		}
	}

	LazyLoader {
		active: QuickSettingsService.hasOpened
		QuickSettings {}
	}

	LazyLoader {
		active: UpdatesService.open
		UpdatesPopup {}
	}

	LazyLoader {
		active: MediaService.hasOpened
		MediaPopup {}
	}

	SystemOsd {}

	SubmapIndicator {}

	NotificationOsd {}
}
