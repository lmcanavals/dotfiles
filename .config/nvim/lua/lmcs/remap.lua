-- author:  lmcanavals
-- created: 2023-07-13

if vim.g.debug then print "lmcsnvim.remap" end

local vks       = vim.keymap.set

vim.g.mapleader = ' '

vks('n', '<leader><space>', ':noh<cr>', { desc = "(noh) Clear search" })
vks('n', '<leader>s', ':w<cr>', { desc = "(w) Save file" })
vks('n', '<leader>n', ':bn<cr>', { desc = "(bn) Next buffer" })
vks('n', '<leader>N', ':bp<cr>', { desc = "(bp) Previous buffer" })
vks('n', '<leader>d', ':bd<cr>', { desc = "(bd) Close buffer" })
vks('n', '<leader>t', ':NvimTreeToggle<cr>', { desc = "Toggle NvimTree" })

-- vim: set ts=2:sw=2:noet:sts=2:
