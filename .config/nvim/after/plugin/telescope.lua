-- author:  lmcanavals
-- created: 2023-07-16
-- updated: 2023-07-16

if vim.g.debug then print "after.plugin.telescope" end

local vks = vim.keymap.set
local builtin  = require('telescope.builtin')

vks("n", "<leader>pf", builtin.find_files, {})
vks("n", "<leader>pr", builtin.git_files, {})
vks("n", "<leader>pg", builtin.live_grep, {})
vks("n", "<leader>pb", builtin.buffers, {})
vks("n", "<leader>ph", builtin.help_tags, {})

-- vim: set ts=2:sw=2:noet:sts=2:
