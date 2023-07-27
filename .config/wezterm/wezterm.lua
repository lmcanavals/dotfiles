-- my own cool config
-- @author lmcs

local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = 'BlulocoDark'
config.enable_tab_bar = false
config.font = wezterm.font { family = 'JetBrains Mono' }
config.font_rules = {
	{
		intensity = 'Bold',
		italic = true,
		font = wezterm.font {
			family = 'VictorMono Nerd Font',
			weight = 'Bold',
			style = 'Italic',
		},
	},
	{
		italic = true,
		intensity = 'Half',
		font = wezterm.font {
			family = 'VictorMono Nerd Font',
			weight = 'DemiBold',
			style = 'Italic',
		},
	},
	{
		italic = true,
		intensity = 'Normal',
		font = wezterm.font {
			family = 'VictorMono Nerd Font',
			style = 'Italic',
		},
	},
}
config.initial_rows = 30
config.initial_cols = 130
config.window_background_opacity = 0.8
config.window_padding = {
	left = 1,
	right = 1,
	top = 1,
	bottom = 1,
}

return config
