-- Well it's obvious what this file is
-- author: Luis Canaval Sánchez
-- created: 2026-05-11

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

--------------------
---- The colors ----
--------------------

local c = require("colors")

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

local function load_fonts(filepath)
	local myfonts = {}

	filepath = filepath:gsub("%$([%w_]+)", function(var)
		return os.getenv(var) or ""
	end)

	if filepath:sub(1, 1) == "~" then
		filepath = os.getenv("HOME") .. filepath:sub(2)
	end

	local file = io.open(filepath, "r")
	if not file then
		print("Error: Could not open font configuration file at " .. filepath)
		return nil
	end

	for line1 in file:lines() do
		local line = line1:match("^%s*(.-)%s*$")

		if line ~= "" and not line:match("^#") then
			local key, value = line:match("^([^=]+)%s*=%s*(.+)$")
			if key and value then
				key = key:match("^%s*(.-)%s*$")
				value = value:match("^%s*(.-)%s*$"):gsub("%s*,%s*", " ")
				myfonts[key] = value
			end
		end
	end
	file:close()
	return myfonts
end

hl.on("hyprland.start", function()
	hl.exec_cmd("mplayer $XDG_DATA_HOME/sounds/Smooth/stereo/desktop-login.oga")

	hl.exec_cmd("systemctl --user is-enabled hypridle || systemctl --user enable --now hypridle")
	hl.exec_cmd("systemctl --user is-enabled hyprpaper || systemctl --user enable --now hyprpaper")
	hl.exec_cmd("systemctl --user is-enabled hyprpolkitagent || systemctl --user enable --now hyprpolkitagent")
	hl.exec_cmd("systemctl --user is-enabled hyprsunset || systemctl --user enable --now hyprsunset")
	hl.exec_cmd("systemctl --user is-enabled waybar || systemctl --user enable --now waybar")
	hl.exec_cmd("systemctl --user is-enabled lbatfyi || systemctl --user enable --now lbatfyi")

	hl.exec_cmd("uwsm-app -- wl-paste --watch cliphist store")
	hl.exec_cmd('rm "$HOME/.cache/cliphist/db"')

	local myfonts = load_fonts("$XDG_CONFIG_HOME/myfonts.conf")
	if myfonts then
		hl.exec_cmd("gsettings set org.gnome.desktop.interface font-name '" .. myfonts["sans-serif"] .. "'")
		hl.exec_cmd("gsettings set org.gnome.desktop.interface monospace-font-name '" .. myfonts["monospace"] .. "'")
	end
	hl.exec_cmd("systemd-analyze >> .startup_time")
end)

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

hl.config({ ecosystem = { enforce_permissions = true } })

hl.permission({ binary = "/usr/(bin|local/bin)/(grim|hyprlock|wf-recorder)", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
-- hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 4,

		border_size = 2,

		col = {
			active_border = { colors = { "rgba(" .. c.accent .. "80)", "rgba(" .. c.border .. "80)" }, angle = 45 },
			inactive_border = { colors = { "rgba(" .. c.accent .. "40)", "rgba(" .. c.border .. "40)" }, angle = 45 },
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "scrolling",

		snap = {
			enabled = true,
			border_overlap = true,
		},
	},

	decoration = {
		rounding = 5,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 0.95,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(" .. c.shadow .. "40)",
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "master",
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us,us,latam",
		kb_variant = "altgr-intl,intl,",
		kb_model = "",
		kb_options = "grp:alt_altgr_toggle,caps:escape_shifted_capslock",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
			--clickfinger_behaviour = true,
		},

		tablet = {
			output = "current",
		},
	},
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", mods = "ALT", action = "close" })
hl.gesture({ fingers = 3, direction = "up", mods = "SUPER", scale = 1.5, action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "down", scale = 1.5, action = "float" })

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
-- hl.device({
-- 	name = "epic-mouse-v1",
-- 	sensitivity = -0.5,
-- })

---------------------
---- KEYBINDINGS ----
---------------------

require("binds")

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.layer_rule({
	name = "blur-layer",
	match = { namespace = "(?:waybar|launcher|notifications)" },

	blur = true,
	blur_popups = true,
	ignore_alpha = 0.1,
	animation = "popin 50%",
})

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
	name = "no-gaps-wtv1",
	match = { float = false, workspace = "w[tv1]" },
	border_size = 0,
	rounding = 0,
})
hl.window_rule({
	name = "no-gaps-f1",
	match = { float = false, workspace = "f[1]" },
	border_size = 0,
	rounding = 0,
})

hl.window_rule({
	name = "float-qt-dev",
	match = { class = "^.*(?:appqml|appqt|prog.app).*$" },
	float = true,
})

hl.window_rule({
	name = "float-applications",
	match = {
		class = "^.*(?:ark|blueman-manager|dolphin|hyprpwcenter|keepassxc|kvantum|nm-connection-editor|nwg-look|pavucontrol|qalculate|qpwgraph|qt6ct).*$",
	},

	center = true,
	float = true,
	size = "monitor_w/2 monitor_h/2",
})

hl.window_rule({
	name = "float-file-dialog",
	match = { title = "^(?:Open|Save|Select).+(?:[Ff]iles?|[Ff]older|[Aa]s).*$" },

	center = true,
	float = true,
	size = "monitor_w/2 monitor_h/2",
})

hl.window_rule({
	name = "float-bw",
	match = { title = "^(?:Bitwarden).*$" },

	center = true,
	float = true,
	size = "monitor_w/4 monitor_h*2/3",
})

hl.window_rule({
	name = "float-pp",
	match = { title = "^.*(?:Picture in picture).*$" },

	float = true,
	pin = true,
	size = "window_w*1.5 window_h*1.5",
})

-- Example windowrules that are useful

-- local suppressMaximizeRule = hl.window_rule({
hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- Workspace names

hl.workspace_rule({ workspace = "1", default_name = "󰼏", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "2", default_name = "󰼐", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", default_name = "󰼑", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", default_name = "󰼒", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", default_name = "󰼓", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "6", default_name = "󰼔", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "7", default_name = "󰼕", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", default_name = "󰼖", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "9", default_name = "󰼗", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "10", default_name = "󰼎", monitor = "HDMI-A-1" })
