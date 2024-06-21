return {
	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				denols = {},
				pylsp = {},
			},
			setup = {
				pylsp = function(_, opts)
					opts.settings = {
						pylsp = {
							plugins = {
								pycodestyle = {
									ignore = { "W391" },
									maxLineLength = 80,
								},
							},
						},
					}
				end,
			},
		},
	},
}
