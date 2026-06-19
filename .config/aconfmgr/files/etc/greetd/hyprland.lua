hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

hl.env("HYPRCURSOR_SIZE", "32")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")

hl.config({
	animations = {
		enabled = false,
	},

	general = {
		allow_tearing = false,
	},

	input = {
		kb_layout = "us,us,latam",
		kb_variant = "altgr-intl,intl,",
		kb_model = "",
		kb_options = "grp:alt_altgr_toggle,caps:escape_shifted_capslock",
		kb_rules = "",
	},
})

hl.on("hyprland.start", function()
	hl.exec_cmd(
		"sleep 1; "
			.. "regreet; "
			.. "command -v hyprshutdown >/dev/null 2>&1 "
			.. "&& hyprshutdown "
			.. "|| hyprctl dispatch 'hl.dsp.exit()'"
	)
end)
