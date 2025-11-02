return {
	{
		"hat0uma/csvview.nvim",
		ft = { "csv" },
		opts = {
			parser = { comments = { "#", "//" } },
			keymaps = {
				textobject_field_inner = { "if", mode = { "o", "x" } },
				textobject_field_outer = { "af", mode = { "o", "x" } },
				jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
				jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
				jump_next_row = { "<Enter>", mode = { "n", "v" } },
				jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
			},
		},
		cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
	},
	{ "dylon/vim-antlr", ft = { "antlr3", "antlr4" } },
	{
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
		keys = { { "<leader>Xh", ":HighlightColors On<cr>", desc = "Highlight colors" } },
		opts = {
			render = "virtual",
			virtual_symbol = "■",
		},
	},
}
