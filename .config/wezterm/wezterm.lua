-- my own cool config
-- @author lmcs

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- color theme stuff
config.color_scheme = "Catppuccin Mocha"
config.set_environment_variables = {
	LCTHEME = "dark", -- set it to have apps match the theme light or dark
}

-- background awesome
local dimmer = { hue = 0.01, brightness = 0.1 }

local bgfolder = ".local/share/backgrounds/"
local bg0 = bgfolder .. "bg0tr.png"
local bg1 = bgfolder .. "bg1tr.png"
local bg2 = bgfolder .. "bg2tr.png"
local bg3 = bgfolder .. "bg3tr.png"

--config.enable_scroll_bar = true
--config.min_scroll_bar_height = "2cell"
--config.colors = {
--	scrollbar_thumb = "white",
--}
config.background = {
	{
		width = "100%",
		height = "100%",
		hsb = { brightness = 0.05 },
		source = { Color = "darkred" },
	},
	{
		attachment = { Parallax = 0.1 },
		hsb = dimmer,
		source = { File = bg0 },
	},
	{
		attachment = { Parallax = 0.2 },
		hsb = dimmer,
		source = { File = bg1 },
	},
	{
		attachment = { Parallax = 0.3 },
		hsb = dimmer,
		source = { File = bg2 },
	},
	{
		attachment = { Parallax = 0.4 },
		hsb = dimmer,
		source = { File = bg3 },
	},
}

-- fonts
local base_font = "Maple Mono NF"
local str_font = "FiraCode Nerd Font"
local cmnt_font = "Maple Mono NF"
local half_font = "Victor Mono Nerd Font"
local diag_font = "Monaspace Krypton"

local base_hb = { "cv02", "ss01", "ss02", "ss03", "ss04", "ss05" }
local diag_hb = {
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

config.font = wezterm.font({
	family = base_font,
	weight = "Regular",
	harfbuzz_features = base_hb,
})
config.font_rules = {
	{
		italic = false,
		intensity = "Bold",
		font = wezterm.font({
			family = str_font,
			weight = "Regular",
		}),
	},
	{
		italic = true,
		intensity = "Bold",
		font = wezterm.font({
			family = diag_font,
			style = "Normal",
			weight = "Light",
			harfbuzz_features = diag_hb,
		}),
	},
	{
		italic = true,
		intensity = "Half",
		font = wezterm.font({
			family = half_font,
			weight = "DemiBold",
		}),
	},
	{
		italic = true,
		intensity = "Normal",
		font = wezterm.font({
			family = cmnt_font,
			style = "Italic",
			weight = "Light",
		}),
	},
}
config.font_size = 12

-- window
config.initial_rows = 30
config.initial_cols = 120
config.enable_tab_bar = false
-- config.term = 'wezterm'
-- config.window_decorations = "TITLE | RESIZE"
-- config.window_background_opacity = 0.9
config.window_padding = {
	left = 10,
	right = 10,
	top = 20,
	bottom = 10,
}

return config
