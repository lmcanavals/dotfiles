pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    readonly property string configPath: {
        const xdg = Quickshell.env("XDG_CONFIG_HOME");
        const base = (xdg && xdg.length > 0) ? xdg : (Quickshell.env("HOME") + "/.config");
        return base + "/lmcscolors.json";
    }

    // Concrete typed palette component so qmllint has full visibility into properties
    component Palette: QtObject {
        property color bg: "#32302f"
        property color bg_dark: "#1d2021"
        property color bg_highlight: "#504945"
        property color fg: "#d5c4a1"
        property color fg_dark: "#bdae93"
        property color bg_widget: "#282828"
        property color bg_widget_r: "#d79921"
        property color fg_widget: "#fabd2f"
        property color fg_widget_r: "#32302f"
        property color comment: "#7c6f64"
        property color accent: "#83a598"
        property color accent_dim: "#458588"
        property color accent_alt: "#fe8019"
        property color border: "#504945"
        property color shadow: "#504945"
        property color success: "#b8bb26"
        property color info: "#458588"
        property color warning: "#fe8019"
        property color error: "#cc241d"
    }

    readonly property Palette colors: Palette {
        id: paletteInstance
    }

    property FileView fileView: FileView {
        path: root.configPath
        watchChanges: true
        blockLoading: true

        onLoaded: root.reload()
        onFileChanged: {
            this.reload();
            root.reload();
        }
    }

    function isValidColor(val) {
        if (typeof val !== "string")
            return false;
        const trimmed = val.trim();
        if (trimmed.length === 0)
            return false;
        return trimmed.startsWith("#") || /^[a-zA-Z]+$/.test(trimmed);
    }

    function reload() {
        try {
            const raw = fileView.text();
            if (!raw || raw.trim().length === 0)
                return;
            const parsed = JSON.parse(raw);
            if (!parsed || typeof parsed !== "object" || Array.isArray(parsed))
                return;

            for (const key in parsed) {
                if (paletteInstance.hasOwnProperty(key) && root.isValidColor(parsed[key])) {
                    paletteInstance[key] = parsed[key].trim();
                }
            }
        } catch (e) {
            // Retain fallback state on corrupted/partial file writes
        }
    }

    Component.onCompleted: root.reload()
}
// vim: set ts=4 sw=4 et sts=0 :
