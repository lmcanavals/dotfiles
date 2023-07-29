-- author:  lmcanavals
-- created: 2023-07-16

if vim.g.debug then print "after.plugin.telescope" end

local vks     = vim.keymap.set
local builtin = require('telescope.builtin')

vks('n', '<leader>ff', builtin.find_files, { desc = "[F]ind [F]iles" })
vks('n', '<leader>fr', builtin.git_files, { desc = "[F]ind in [R]epo" })
vks('n', '<leader>fg', builtin.live_grep, { desc = "[F]ind by [G]rep" })
vks('n', '<leader>fb', builtin.buffers, { desc = "[F]ind [B]uffers" })
vks('n', '<leader>fh', builtin.help_tags, { desc = "[F]ind [H]elp tags" })

-- vim: set ts=2:sw=2:noet:sts=2:
