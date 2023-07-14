-- author:  lmcanavals
-- date:    2023-07-14
-- updated: 2023-07-14

if vim.g.debug then print "lmcsnvim.folds" end

_G.myFoldText    = function()
	local lineCount = (vim.v.foldend - vim.v.foldstart + 1) .. " lines"
	local line = vim.fn.getline(vim.v.foldstart)
	local llen = string.len(line)
	local lclen = string.len(lineCount)
	local width = 80 -- TODO min(80, window width)
	if llen < width - lclen then
		line = line .. string.rep("·", width - llen - lclen)
	else
		line = string.sub(line, 1, width - lclen) .. "…"
	end
	return line .. lineCount
end
vim.opt.foldtext = 'v:lua.myFoldText()'

-- vim: set ts=2:sw=2:noet:sts=2:
