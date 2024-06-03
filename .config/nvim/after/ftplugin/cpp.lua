-- author:  lmcanavals
-- date:    2024-06-3

if vim.g.debug then print "after.ftplugin.cpp" end

local vks = vim.keymap.set

vks('n', '<leader>b', ':!clang++ -std=c++23 -g %<cr>', { desc = "clang++" })

-- vim: set ts=2:sw=2:noet:sts=2:
