-- author:  lmcanavals
-- date:    2024-06-04

if vim.g.debug then print "after.plugin.luasnip" end

local ls = require 'luasnip'
local vks = vim.keymap.set

vks({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
vks({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
vks({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })
vks({ "i", "s" }, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })

require 'luasnip.loaders.from_vscode'.lazy_load()

-- vim: set ts=2:sw=2:noet:sts=2:
