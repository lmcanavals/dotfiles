return {
	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				denols = {},
				html = {},
				pylsp = {},
				qmlls = {},
			},
			setup = {
				-- TODO check capabilities for everything
				html = function(_, opts)
					local capabilities = vim.lsp.protocol.make_client_capabilities()
					capabilities.textDocument.completion.completionItem.snippetSupport =
						true
					opts.capabilities = capabilities
				end,
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
				qmlls = function(_, opts)
					opts.cmd = { "qmlls", "-E" }
				end,
			},
		},
	},
}
