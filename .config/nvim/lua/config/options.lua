-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.colorcolumn = "90"
opt.background = vim.env.LCTHEME or "dark"
opt.expandtab = false
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.listchars = {
	tab = "╎ ",
	trail = "∙",
	extends = "»",
	precedes = "«",
	nbsp = "§",
}

vim.g.lazyvim_python_lsp = "ty"
