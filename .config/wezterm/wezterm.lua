-- my own cool config
-- @author lmcs

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- color theme stuff
config.color_scheme = "Tokyo Night Moon"
config.set_environment_variables = {
	LCTHEME = "dark", -- set it to have apps match the theme light or dark
}

-- background awesome
local bgfolder = ".local/share/backgrounds/"
local bgsolid = bgfolder .. "bg000000cd.png"
local bg0 = bgfolder .. "bg0b.png"
local bg1 = bgfolder .. "bg1b.png"
local bg2 = bgfolder .. "bg2b.png"
local bg3 = bgfolder .. "bg3b.png"

--config.enable_scroll_bar = true
--config.min_scroll_bar_height = "2cell"
--config.colors = {
--	scrollbar_thumb = "white",
--}
config.background = {
	{
		source = { File = bgsolid },
	},
	{
		attachment = { Parallax = 0.01 },
		hsb = { hue = 0.8, brightness = 0.08 },
		source = { File = bg0 },
	},
	{
		attachment = { Parallax = 0.02 },
		hsb = { hue = 0.6, brightness = 0.07 },
		source = { File = bg1 },
	},
	{
		attachment = { Parallax = 0.03 },
		hsb = { hue = 0.4, brightness = 0.06 },
		source = { File = bg2 },
	},
	{
		attachment = { Parallax = 0.04 },
		hsb = { hue = 0.2, brightness = 0.05 },
		source = { File = bg3 },
	},
}

-- fonts
local base_font = "Iosevka" -- "Monaspace Argon" -- "Maple Mono NF"
local str_font = "Iosevka Slab" -- "Monaspace Xenon" -- "FiraCode Nerd Font"
local cmnt_font = "Monofur Nerd Font" -- "Monaspace Radon" -- "Victor Mono Nerd Font"
local half_font = "Terminus" -- "Monaspace Neon" -- "Fairfax HD"
local diag_font = "Terminus" -- "Monaspace Krypton"

-- local maple_hb = { "cv02", "ss01", "ss02", "ss03", "ss04", "ss05" }
--[[ local monaspace_hb = {
	"calt",
	"ss01",
	"ss02",
	"ss03",
	"ss04",
	"ss05",
	"ss06",
	"ss07",
	"ss08",
	"ss09",
	"liga",
}
--]]
local iosekva_hb = { "dlig", "ss09" }
local no_hb = {}
local base_hb = iosekva_hb -- monaspace_hb
local str_hb = no_hb -- monaspace_hb
local cmnt_hb = no_hb -- monaspace_hb
local half_hb = no_hb -- monaspace_hb
local diag_hb = no_hb -- monaspace_hb

config.font = wezterm.font({
	family = base_font,
	harfbuzz_features = base_hb,
	weight = "Regular",
})
config.font_rules = {
	{
		italic = false,
		intensity = "Bold",
		font = wezterm.font({
			family = str_font,
			harfbuzz_features = str_hb,
			weight = "Bold",
		}),
	},
	{
		italic = true,
		intensity = "Bold",
		font = wezterm.font({
			family = diag_font,
			harfbuzz_features = diag_hb,
			style = "Normal",
			weight = "Light",
		}),
	},
	{
		italic = true,
		intensity = "Half",
		font = wezterm.font({
			family = half_font,
			harfbuzz_features = half_hb,
			weight = "DemiBold",
		}),
	},
	{
		italic = true,
		intensity = "Normal",
		font = wezterm.font({
			family = cmnt_font,
			harfbuzz_features = cmnt_hb,
			style = "Italic",
			weight = "Medium",
		}),
	},
}
config.font_size = 12

-- window
config.initial_rows = 30
config.initial_cols = 120
config.enable_tab_bar = false
config.term = "wezterm"
-- config.window_decorations = "TITLE | RESIZE"
-- config.window_background_opacity = 0.9
function Recompute_padding(window)
	local overrides = window:get_config_overrides() or {}
	local win_dims = window:get_dimensions()
	local pane_dims = window:active_pane():get_dimensions()

	local new_padding = {
		left = math.floor((win_dims.pixel_width - pane_dims.pixel_width) / 2),
		top = math.floor((win_dims.pixel_height - pane_dims.pixel_height) / 2),
	}
	overrides.window_padding = new_padding
	window:set_config_overrides(overrides)
end

wezterm.on("window-resized", function(window, _)
	Recompute_padding(window)
end)

wezterm.on("window-config-reloaded", function(window)
	Recompute_padding(window)
end)

return config
