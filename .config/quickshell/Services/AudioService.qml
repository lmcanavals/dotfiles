pragma Singleton

import QtQuick
import Quickshell.Services.Pipewire

QtObject {
    id: root
    // 󰍬 󰍭

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: Pipewire.defaultAudioSink?.audio?.volume ?? 0.0
    readonly property bool muted: Pipewire.defaultAudioSink?.audio?.muted ?? false

    readonly property string sinkType: {
        const desc = sink?.description.toLowerCase() ?? "";
        const name = sink?.name.toLowerCase() ?? "";
        if (desc.includes("headphone") || name.includes("headphone") || desc.includes("headset") || name.includes("usb"))
            return "headphone";
        if (desc.includes("hdmi") || desc.includes("displayport"))
            return "hdmi";
        if (desc.includes("bluetooth") || name.includes("bluez"))
            return "bluetooth";
        return "speaker";
    }

    readonly property string glyph: {
        if (root.sinkType === "headphone")
            return root.muted ? "󰟎" : "󰋋";
        if (root.sinkType === "bluetooth")
            return root.muted ? "󰗿" : "󰗾";

        const v = Math.round(root.volume * 100);
        if (v === 0 || root.muted)
            return "󰖁";
        if (v < 30)
            return "󰕿";
        if (v < 70)
            return "󰖀";
        return "󰕾";
    }

    property PwObjectTracker tracker: PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    function setVolume(val: real): void {
        if (sink?.audio) {
            sink.audio.volume = Math.max(0.0, Math.min(1.0, val));
        }
    }

    function toggleMute(): void {
        if (sink?.audio) {
            sink.audio.muted = !sink.audio.muted;
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
