-- author: lmcanavals
-- date:   2021-07-26

local opt = vim.opt

require 'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		custom_captures = {
			["foo.bar"] = "Identifier",
		},
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection    = "gnn",
			node_incremental  = "grn",
			scope_incremental = "grc",
			node_decremental  = "grm",
		},
	},
	indent = {
		enable = true
	}
}
opt.foldcolumn = "1"
opt.foldmethod = "expr"
opt.foldexpr   = "nvim_treesitter#foldexpr()"

-- vim: set ts=2:sw=2:noet:sts=2:
