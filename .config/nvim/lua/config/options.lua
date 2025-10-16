-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local v = vim.v
local fn = vim.fn
local opt = vim.opt

-- TODO: unify the 88 and 90 because they are related

function LmcsFoldText()
	local lineCount = (v.foldend - v.foldstart + 1)
	local indent = fn.indent(v.foldstart)
	local newindent = string.rep(" ", indent)
	local winid = vim.api.nvim_get_current_win()
	local cols = vim.fn.winwidth(winid) - vim.fn.getwininfo(winid)[1].textoff
	local width = math.min(88, cols - 2)
	local line
	local goodline = false
	local i = 0
	repeat
		line = fn.getline(v.foldstart + i)
		i = i + 1
		if string.gsub(line, "%s+", "") ~= "{" then
			goodline = true
		end
	until goodline or v.foldstart + i > v.foldend
	if i > 1 then
		line = string.gsub(line, "^%s+", newindent .. "{ ")
	else
		line = string.gsub(line, "^%s+", newindent)
	end
	local llen = string.len(line) -- line length
	local lclen = string.len(lineCount) -- line count length

	if llen < width - lclen then
		line = line .. string.rep(" ", width - llen - lclen)
	else
		line = string.sub(line, 1, width - lclen - 1) .. "…"
	end
	return line .. lineCount .. " "
end

opt.colorcolumn = "90"
opt.background = vim.env.LCTHEME or "dark"
opt.expandtab = false
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.foldtext = "v:lua.LmcsFoldText()"
opt.listchars = {
	tab = "╎ ",
	trail = "∙",
	extends = "»",
	precedes = "«",
	nbsp = "§",
}
