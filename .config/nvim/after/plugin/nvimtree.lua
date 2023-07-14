-- author:  lmcanavals
-- date:    2021-07-26
-- updated: 2023-07-14

if vim.g.debug then print "after.plugin.nvimtree" end

require 'nvim-tree'.setup {
	filters = {
		dotfiles = true,
	}
}

-- vim: set ts=2:sw=2:noet:sts=2:
