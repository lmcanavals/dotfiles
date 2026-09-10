pragma Singleton

import QtQuick
import Quickshell.Services.Pipewire

QtObject {
    id: root

    readonly property real volume: Pipewire.defaultAudioSink?.audio?.volume ?? 0.0
    readonly property bool muted: Pipewire.defaultAudioSink?.audio?.muted ?? false
    readonly property string sinkName: Pipewire.defaultAudioSink?.description ?? "Default Audio"

    property PwObjectTracker tracker: PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    function setVolume(val) {
        if (Pipewire.defaultAudioSink?.audio) {
            Pipewire.defaultAudioSink.audio.volume = Math.max(0.0, Math.min(1.5, val));
        }
    }

    function toggleMute() {
        if (Pipewire.defaultAudioSink?.audio) {
            Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
