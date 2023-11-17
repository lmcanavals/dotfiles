-- my own cool config
-- @author lmcs

local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = 'BlulocoDark'
config.enable_tab_bar = false
--config.font = wezterm.font { family = 'JetBrains Mono' }
config.font = wezterm.font { family = 'Monaspace Neon' }
config.font_rules = {
	{
		italic = true,
		intensity = 'Bold',
		font = wezterm.font {
			--family = 'VictorMono Nerd Font',
			family = 'Monaspace Radon',
			weight = 'Bold',
			style = 'Italic',
		},
	},
	{
		italic = true,
		intensity = 'Half',
		font = wezterm.font {
			--family = 'VictorMono Nerd Font',
			family = 'Monaspace Radon',
			weight = 'DemiBold',
			style = 'Italic',
		},
	},
	{
		italic = true,
		intensity = 'Normal',
		font = wezterm.font {
			--family = 'VictorMono Nerd Font',
			family = 'Monaspace Radon',
			style = 'Italic',
		},
	},
}
config.harfbuzz_features = {
	'ss01', 'ss02', 'ss03', 'ss04',
	'ss05', 'ss06', 'ss07', 'ss08',
	'calt', 'dlig'
}
config.initial_rows = 30
config.initial_cols = 130
config.term = 'wezterm'
config.window_background_opacity = 0.8
config.window_padding = {
	left = 1,
	right = 1,
	top = 1,
	bottom = 1,
}

return config
