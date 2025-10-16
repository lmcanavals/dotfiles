return {
	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			servers = {
				denols = {},
				html = {},
			},
			setup = {
				-- TODO: check capabilities for everything
				html = function(_, opts)
					local capabilities = vim.lsp.protocol.make_client_capabilities()
					capabilities.textDocument.completion.completionItem.snippetSupport = true
					opts.capabilities = capabilities
				end,
			},
		},
	},
}
