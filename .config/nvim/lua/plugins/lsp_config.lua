return {
	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			servers = {
				bashls = {},
				html = {},
			},
			setup = {
				-- TODO: check capabilities for everything
				bashls = function(_, opts)
					local capabilities = vim.lsp.protocol.make_client_capabilities()
					capabilities.textDocument.completion.completionItem.snippetSupport = true
					opts.capabilities = capabilities
					opts.filetypes = { "bash", "sh", "zsh" }
				end,
				html = function(_, opts)
					local capabilities = vim.lsp.protocol.make_client_capabilities()
					capabilities.textDocument.completion.completionItem.snippetSupport = true
					opts.capabilities = capabilities
				end,
			},
		},
	},
}
