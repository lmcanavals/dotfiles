-- author:  lmcanavals
-- created: 2023-07-16
-- updated: 2023-07-16

if vim.g.debug then print "after.plugin.telescope" end

local builtin  = require('telescope.builtin')
local mappings = {
	["f"] = builtin.find_files,
	["r"] = builtin.git_files,
	["g"] = builtin.live_grep,
	["b"] = builtin.buffers,
	["h"] = builtin.help_tags,
}

for m, c in pairs(mappings) do
	vim.keymap.set('n', '<leader>f' .. m, c, {})
end

-- vim: set ts=2:sw=2:noet:sts=2:
