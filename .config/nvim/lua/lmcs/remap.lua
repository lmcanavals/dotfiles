-- author:  lmcanavals
-- created: 2023-07-13
-- updated: 2023-07-13

if vim.g.debug then print "lmcsnvim.remap" end

vim.g.mapleader = " "
local mappings  = {
	["<space>"] = "noh",
	["s"]       = "w",
	["n"]       = "bn",
	["p"]       = "bp",
	["d"]       = "bd",
	["t"]       = "NvimTreeToggle"
}
for m, c in pairs(mappings) do
	vim.keymap.set("n", "<leader>" .. m, ":" .. c .. "<cr>", { noremap = true })
end

-- vim: set ts=2:sw=2:noet:sts=2:
