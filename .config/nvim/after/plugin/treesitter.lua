-- author:  lmcanavals
-- date:    2021-07-26

if vim.g.debug then print "after.plugin.treesitter" end

local opt = vim.opt

require 'nvim-treesitter.configs'.setup {
	modules = {},
	ignore_install = {},
	ensure_installed = {
		'bash', 'c', 'cpp', 'go', 'html', 'javascript', 'llvm', 'lua',
		'markdown', 'markdown_inline', 'python', 'regex', 'rust', 'vim',
	},
	sync_install = true,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection    = 'gnn',
			node_incremental  = 'grn',
			scope_incremental = 'grc',
			node_decremental  = 'grm',
		},
	},
	indent = {
		enable = true
	}
}
opt.foldcolumn = '1'
opt.foldmethod = 'expr'
opt.foldexpr   = 'nvim_treesitter#foldexpr()'

-- vim: set ts=2:sw=2:noet:sts=2:
