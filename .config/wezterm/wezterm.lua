-- my own cool config
-- @author lmcs

local wezterm = require 'wezterm'

local base_font = 'Maple Mono'
local string_font = 'FiraCode Nerd Font'
local comment_font = 'Maple Mono'
local diagnostics_font = 'Monaspace Krypton'

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end
-- Regular
config.color_scheme = 'BlulocoDark'
config.enable_tab_bar = false
config.font = wezterm.font {
	family = base_font,
	weight = "Regular",
}
config.font_rules = {
	{
		italic = false,
		intensity = 'Bold',
		font = wezterm.font {
			family = string_font,
			weight = 'Regular',
		}
	},
	{
		italic = true,
		intensity = 'Bold',
		font = wezterm.font {
			family = diagnostics_font,
			style = 'Normal',
			weight = 'Light',
		}
	},
	{
		italic = true,
		intensity = 'Half',
		font = wezterm.font {
			family = comment_font,
			weight = 'DemiBold',
		},
	},
	{
		italic = true,
		intensity = 'Normal',
		font = wezterm.font {
			family = comment_font,
			style = 'Italic',
			weight = 'Light',
		},
	},
}

config.font_size = 12
config.harfbuzz_features = {
	-- 'cv01',
	'cv02',
	-- 'cv03',
	-- 'cv04',
	'ss01',
	'ss02',
	'ss03',
	'ss04',
	'ss05',
	-- 'ss06',
	-- 'ss07',
	-- 'ss08',
	-- 'calt',
	-- 'dlig'
}
config.initial_rows = 30
config.initial_cols = 120
--config.term = 'wezterm'
-- config.window_decorations = "TITLE | RESIZE"
config.window_background_opacity = 0.9
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

return config
