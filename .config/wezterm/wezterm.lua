-- my own cool config
-- @author lmcs

local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = 'BlulocoDark'
config.enable_tab_bar = false
config.initial_rows = 30
config.initial_cols = 130
config.window_background_opacity = 0.9
config.window_padding = {
	left = 1,
	right = 1,
	top = 1,
	bottom = 1,
}

return config
