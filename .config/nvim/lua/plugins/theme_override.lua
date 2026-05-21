return {
	-- Ensure other popular themes are installed/available
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "ellisonleao/gruvbox.nvim" },
	{ "nordtheme/vim" },

	-- Override LazyVim colorscheme dynamically
	{
		"LazyVim/LazyVim",
		opts = function(_, opts)
			local has_theme, theme = pcall(require, "config.theme")
			if has_theme and theme and theme.nvim_scheme then
				opts.colorscheme = theme.nvim_scheme
			end
		end,
	},
}
