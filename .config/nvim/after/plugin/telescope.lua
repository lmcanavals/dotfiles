-- author:  lmcanavals
-- created: 2023-07-16

if vim.g.debug then print "after.plugin.telescope" end

local vks     = vim.keymap.set
local builtin = require('telescope.builtin')

vks('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
vks('n', '<leader>fr', builtin.git_files, { desc = "Find in Repo" })
vks('n', '<leader>fg', builtin.live_grep, { desc = "Find by Grep" })
vks('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers" })
vks('n', '<leader>fh', builtin.help_tags, { desc = "Find Help tags" })

-- vim: set ts=2:sw=2:noet:sts=2:
