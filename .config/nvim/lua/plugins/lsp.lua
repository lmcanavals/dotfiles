return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				bashls = {
					filetypes = { "bash", "sh", "zsh" },
				},
			},
		},
	},
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			table.insert(opts.ensure_installed, "pgformatter")
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				sql = { "pg_format" },
			},
		},
	},
}
