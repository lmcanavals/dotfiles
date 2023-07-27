-- author:  lmcanavals
-- date:    2021-07-26
-- updated: 2023-07-25

if vim.g.debug then print "lmcsnvim.init" end

require 'lmcs.remap'
require 'lmcs.set'
require 'lmcs.lazy'
require 'lmcs.folds'

require 'hologram'.setup {
	auto_display = true
}

-- vim: set ts=2:sw=2:noet:sts=2:
