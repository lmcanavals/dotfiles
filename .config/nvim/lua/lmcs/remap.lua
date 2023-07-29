-- author:  lmcanavals
-- created: 2023-07-13

if vim.g.debug then print "lmcsnvim.remap" end

local vks       = vim.keymap.set
local opts      = { noremap = true }

vim.g.mapleader = ' '

vks('n', '<leader><space>', ':noh<cr>', opts)
vks('n', '<leader>s', ':w<cr>', opts)
vks('n', '<leader>n', ':bn<cr>', opts)
vks('n', '<leader>N', ':bp<cr>', opts)
vks('n', '<leader>d', ':bd<cr>', opts)
vks('n', '<leader>t', ':NvimTreeToggle<cr>', opts)

-- vim: set ts=2:sw=2:noet:sts=2:
