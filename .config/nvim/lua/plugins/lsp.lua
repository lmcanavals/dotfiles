return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				bashls = {
					filetypes = { "bash", "sh", "zsh" },
				},
				qmlls = {
					cmd = { "qmlls6" },
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
				qml = { "qmlformat" },
				qmljs = { "qmlformat" },
			},
			formatters = {
				qmlformat = {
					command = "/usr/lib/qt6/bin/qmlformat",
					args = { "-i", "$FILENAME" },
					stdin = false,
				},
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				qml = { "qmllint" },
				qmljs = { "qmllint" },
			},
			linters = {
				qmllint = {
					cmd = "/usr/lib/qt6/bin/qmllint",
					stdin = false,
					parser = require("lint.parser").from_errorformat(
						"%f:%l:%c: %trror: %m,%f:%l:%c: %twarning: %m",
						{ source = "qmllint" }
					),
				},
			},
		},
	},
}
