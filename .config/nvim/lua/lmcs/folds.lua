-- author:  lmcanavals
-- date:    2023-07-14

if vim.g.debug then print "lmcsnvim.folds" end

local v = vim.v
local fn = vim.fn

function LmcsFoldText()
	local lineCount = (v.foldend - v.foldstart + 1) .. " lines"
	local indent = fn.indent(v.foldstart)
	local newindent = string.rep(" ", indent)
	local line = string.gsub(fn.getline(v.foldstart), "^%s+", newindent)
	local llen = string.len(line)
	local lclen = string.len(lineCount)
	local width = 80 -- TODO min(80, window width)

	if llen < width - lclen then
		line = line .. string.rep(" ", width - llen - lclen)
	else
		line = string.sub(line, 1, width - lclen - 1) .. "…"
	end
	return line .. lineCount
end
vim.opt.foldtext = 'v:lua.LmcsFoldText()'

-- vim: set ts=2:sw=2:noet:sts=2:
