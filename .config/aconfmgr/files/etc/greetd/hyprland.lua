hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

hl.env("HYPRCURSOR_SIZE", "32")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")

hl.on("hyprland.start", function()
	hl.exec_cmd("regreet; command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
end)

hl.config({
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_guiutils_check = true,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
})

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

hl.config({
	general = {
		gaps_in = 10,
		gaps_out = 20,

		border_size = 3,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 0.95,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = false,
	},
})
