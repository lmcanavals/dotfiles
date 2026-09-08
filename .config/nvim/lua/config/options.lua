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

-- Gate OSC 52 provider strictly to SSH sessions
local is_ssh = os.getenv("SSH_CONNECTION") ~= nil or os.getenv("SSH_TTY") ~= nil

if is_ssh then
	vim.opt.clipboard = "unnamedplus"
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
end
