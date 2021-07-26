-- author: lmcanavals
-- date:   2021-07-26
-- TODO: check:
--	TimUntersberger/neogit
--	folke/which-key.nvim
--	kevinhwang91/nvim-hlslens
--	kevinhwang91/nvim-bqf
--	rktjmp/lush.nvim -- only if we need to do some low level color cool
--	ray-x/lsp_signature.nvim
--	https://github.com/rockerBOO/awesome-neovim#snippets

local cmd  = vim.cmd
local map  = vim.api.nvim_set_keymap
local opt  = vim.opt

opt.background   = "dark"
opt.colorcolumn  = "81"
opt.completeopt  = {"menuone", "noselect"}
opt.cursorcolumn = true
opt.cursorline   = true
opt.expandtab    = false
opt.fillchars    = {fold=" ", stl="-", stlnc="-"}
opt.laststatus   = 0
opt.list         = true
opt.listchars    = {tab="┼─", trail="∙", extends="»", precedes="«", nbsp="§"}
opt.mouse        = "a"
opt.number       = true
opt.scrolloff    = 5
opt.shiftwidth   = 2
opt.showbreak    = "▼ "
opt.showmatch    = true
opt.smartindent  = true
opt.softtabstop  = 2
opt.statusline   = "%t%M%=%v" --%{&ff},%{&fenc?&fenc:&enc}
opt.tabstop      = 2
opt.title        = true
opt.wildignore   = "*~,*.o,*.tmp"
opt.wildmode     = {"longest:full", "full"}

opt.termguicolors = true

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

cmd'colorscheme lmcs'
cmd'autocmd TermOpen * setlocal nonumber foldcolumn=0'

require'paqsetup'
require'lspsetup'
require'compesetup'
require'treesittersetup'

require'lspfuzzy'.setup {}

-- vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

