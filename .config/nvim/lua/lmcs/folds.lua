-- author:  lmcanavals
-- date:    2023-07-14

if vim.g.debug then print "lmcsnvim.folds" end

local v = vim.v
local fn = vim.fn

function LmcsFoldText()
	local lineCount = (v.foldend - v.foldstart + 1)
	local indent = fn.indent(v.foldstart)
	local newindent = string.rep(" ", indent)
	local line
	local goodline = false
	local i = 0
	repeat
		line = string.gsub(fn.getline(v.foldstart + i), "^%s+", newindent)
		i = i + 1
		if string.gsub(line, '%s+', '') ~= '{' then
			goodline = true
		end
	until goodline or v.foldstart + i > v.foldend
	local llen = string.len(line)      -- line length
	local lclen = string.len(lineCount) -- line count length
	local width = 78                   -- TODO min(78, window width)

	if llen < width - lclen then
		line = line .. string.rep(" ", width - llen - lclen)
	else
		line = string.sub(line, 1, width - lclen - 1) .. "…"
	end
	return line .. lineCount .. " "
end

vim.opt.foldtext = 'v:lua.LmcsFoldText()'

-- vim: set ts=2:sw=2:noet:sts=2:
