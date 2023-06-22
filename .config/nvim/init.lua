-- author: lmcanavals
-- date:   2021-07-26

local cmd  = vim.cmd
local map  = vim.api.nvim_set_keymap
local opt  = vim.opt

opt.background   = "dark"
opt.colorcolumn  = "81"
opt.completeopt  = {"menuone", "noselect"}
opt.cursorcolumn = true
opt.cursorline   = true
opt.expandtab    = false
opt.fillchars    = {fold=" ", vert="┃"}
opt.laststatus   = 2
opt.list         = true
opt.listchars    = {tab="┼─", trail="∙", extends="»", precedes="«", nbsp="§"}
opt.mouse        = "a"
-- opt.number       = true
opt.scrolloff    = 5
opt.shiftwidth   = 2
opt.showbreak    = "▼ "
opt.showmatch    = true
opt.smartindent  = true
opt.softtabstop  = 2
opt.statusline   = "%t%M%=%l,%v" --%{&ff},%{&fenc?&fenc:&enc}
opt.tabstop      = 2
opt.title        = true
opt.wildignore   = "*~,*.o,*.tmp"
opt.wildmode     = {"longest:full", "full"}

vim.g.mapleader = " "
local mappings = {
	["<space>"] = "noh",
	["s"]       = "w",
	["n"]       = "bn",
	["p"]       = "bp",
	["d"]       = "bd",
	["t"]       = "NvimTreeToggle"
}
for m, c in pairs(mappings) do
	map("n", "<leader>"..m, ":"..c.."<cr>", {noremap = true})
end

_G.myFoldText = function()
	local lineCount = (vim.v.foldend - vim.v.foldstart + 1).." lines"
	local line = vim.fn.getline(vim.v.foldstart)
	local llen = string.len(line)
	local lclen = string.len(lineCount)
	local width = 80 -- TODO min(80, window width)
	if llen < width - lclen then
		line = line..string.rep("·", width - llen - lclen)
	else
		line = string.sub(line, 1, width - lclen).."…"
	end
	return line..lineCount
end
opt.foldtext = 'v:lua.myFoldText()'

cmd'colorscheme lmcs'
cmd'autocmd TermOpen * setlocal nonumber foldcolumn=0'

require'paqsetup'
require'lspsetup'
require'cmpsetup'
require'treesittersetup'

require'lspfuzzy'.setup {}
require'nvim-tree'.setup {}
require'hologram'.setup {
	auto_display = true
}

-- vim: set ts=2:sw=2:noet:sts=2:
