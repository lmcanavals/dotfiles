-- author:  lmcanavals
-- created: 2023-07-16
-- updated: 2023-07-26

if vim.g.debug then print "after.plugin.telescope" end

local vks = vim.keymap.set
local builtin  = require('telescope.builtin')

vks("n", "<leader>ff", builtin.find_files, {})
vks("n", "<leader>fr", builtin.git_files, {})
vks("n", "<leader>fg", builtin.live_grep, {})
vks("n", "<leader>fb", builtin.buffers, {})
vks("n", "<leader>fh", builtin.help_tags, {})

-- vim: set ts=2:sw=2:noet:sts=2:
