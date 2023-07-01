-- my own cool config
-- @author lmcs

local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = 'Jason Wryan (terminal.sexy)'
config.enable_tab_bar = false
config.initial_rows = 30
config.initial_cols = 130
config.window_background_opacity = 0.9

return config
