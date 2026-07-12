local has_theme, theme = pcall(require, "config.theme")
if not (has_theme and theme and theme.nvim_scheme) then
	return {}
end

return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = theme.nvim_scheme or "tokyonight",
		},
	},
}
