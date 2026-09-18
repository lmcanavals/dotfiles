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
		active: QuickSettingsService.open
		QuickSettings {}
	}

	LazyLoader {
		active: UpdatesService.open
		UpdatesPopup {}
	}

	LazyLoader {
		active: MediaService.open
		MediaPopup {}
	}

	VolumeOsd {}

	SubmapIndicator {}
}
