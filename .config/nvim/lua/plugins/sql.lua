return {
	-- Tell Mason to automatically install pgformatter
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			table.insert(opts.ensure_installed, "pgformatter")
		end,
	},

	-- Tell Conform to use pg_format for sql filetypes
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				sql = { "pg_format" },
			},
		},
	},
}
