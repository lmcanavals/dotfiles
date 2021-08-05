-- Vim color file
-- Name:				lmcs.lua
-- Version:			4.1
-- Maintainer:	lmcanavals

local ok = vim.env.ISMOSHBRAH ~= "yup"

vim.opt.termguicolors = ok

local BG = ok and "#20201e" or 0
local RE = ok and "#db4952" or 1
local GR = ok and "#57a128" or 2
local YE = ok and "#ee9d34" or 3
local BL = ok and "#538fd5" or 4
local MA = ok and "#a646d3" or 5
local CY = ok and "#32abba" or 6
local WH = ok and "#a09d80" or 7
local bg = ok and "#786458" or 8
local re = ok and "#f6958f" or 9
local gr = ok and "#9bc76f" or 10
local ye = ok and "#f5d277" or 11
local bl = ok and "#81aff3" or 12
local ma = ok and "#cc8fd8" or 13
local cy = ok and "#78d2e0" or 14
local wh = ok and "#e0ddc0" or 15

local BO = "bold"
local UL = "underline"
local UC = "undercurl"
local RV = "reverse"
local IT = "italic"
local SO = "standout"
local ST = "strikethrough"
local NO = "none"
local NA = "na"

local theme = {
	Normal       = { ui = NA, bg = NA, fg = NA },
	Underlined   = { ui = UL, bg = NA, sp = BL },
	NonText      = { ui = NA, bg = NA, fg = BG },
	Special      = { ui = NA, bg = NA, fg = MA },
	SpecialKey   = { ui = NA, bg = NA, fg = bg },
	CursorColumn = { ui = NA, bg = BG, fg = NA },
	CursorLine   = { ui = NA, bg = BG, fg = NA },
	CursorLineNr = { ui = NA, bg = BG, fg = cy },
	ColorColumn  = { ui = UC, bg = NA, sp = bg },
	Conceal      = { ui = NA, bg = NA, fg = BG },
	LineNr       = { ui = NA, bg = NA, fg = bg },
	FoldColumn   = { ui = NA, bg = NA, fg = bg },
	Folded       = { ui = NA, bg = NA, fg = WH },
	MatchParen   = { ui = BO, bg = NA, fg = wh },
	IncSearch    = { ui = NA, bg = MA, fg = wh },
	Search       = { ui = NA, bg = GR, fg = wh },
	QuickFixLine = { ui = NA, bg = GR, fg = ye },
	Pmenu        = { ui = NA, bg = BG, fg = WH },
	PmenuSel     = { ui = NA, bg = YE, fg = BG },
	PmenuSbar    = { ui = NA, bg = bg, fg = BG },
	PmenuThumb   = { ui = NA, bg = WH, fg = BG },
	VertSplit    = { ui = NA, bg = NA, fg = bg },
	StatusLine   = { ui = NA, bg = bg, fg = wh },
	StatusLineNC = { ui = NA, bg = bg, fg = WH },
	TabLine      = { ui = NA, bg = BG, fg = bg },
	TabLineSel   = { ui = NA, bg = NA, fg = cy },
	TabLineFill  = { ui = NA, bg = BG, fg = bg },
	SignColumn   = { ui = NA, bg = NA, fg = re },
	Visual       = { ui = NA, bg = ye, fg = BL },
	VisualNOS    = { ui = NA, bg = RE, fg = BL },
	WildMenu     = { ui = NA, bg = YE, fg = BG },
	MsgArea      = { ui = NA, bg = NA, fg = CY },
	ModeMsg      = { ui = NA, bg = NA, fg = cy },
	WarningMsg   = { ui = NA, bg = NA, fg = YE },
	ErrorMsg     = { ui = NA, bg = NA, fg = RE },
	MoreMsg      = { ui = NA, bg = NA, fg = GR },
	Comment      = { ui = IT, bg = NA, fg = bg },
	Todo         = { ui = NA, bg = NA, fg = YE },
	Error        = { ui = NA, bg = RE, fg = BG },
	Identifier   = { ui = NA, bg = NA, fg = bl },
	Function     = { ui = NA, bg = NA, fg = BL },
	PreProc      = { ui = NA, bg = NA, fg = ye },
	Number       = { ui = NA, bg = NA, fg = gr },
	Operator     = { ui = NA, bg = NA, fg = GR },
	Constant     = { ui = NA, bg = NA, fg = YE },
	Type         = { ui = NA, bg = NA, fg = GR },
	Statement    = { ui = NA, bg = NA, fg = ma },
	Title        = { ui = NA, bg = NA, fg = ma },
	Directory    = { ui = NA, bg = NA, fg = cy },
	DiffDelete   = { ui = NA, bg = RE, fg = BG },
	DiffAdd      = { ui = NA, bg = GR, fg = BG },
	DiffChange   = { ui = NA, bg = YE, fg = BG },
	DiffText     = { ui = NA, bg = BL, fg = BG },
	LspDiagnosticsDefaultError         = { ui = NA, bg = NA, fg = RE },
	LspDiagnosticsDefaultWarning       = { ui = NA, bg = NA, fg = YE },
	LspDiagnosticsDefaultInformation   = { ui = NA, bg = NA, fg = CY },
	LspDiagnosticsDefaultHint          = { ui = NA, bg = NA, fg = ye },
	LspDiagnosticsUnderlineError       = { ui = UC, bg = NA, sp = RE },
	LspDiagnosticsUnderlineWarning     = { ui = UC, bg = NA, sp = YE },
	LspDiagnosticsUnderlineInformation = { ui = UC, bg = NA, sp = CY },
	LspDiagnosticsUnderlineHint        = { ui = UC, bg = NA, sp = ye },
}

local L = {}

function L.color()
	vim.cmd'hi clear'
	vim.cmd'syntax reset'
	vim.g.colors_name = 'lmcs'
	for k, attrs in pairs(theme) do
		vim.cmd("hi clear "..k)
		local hi = "hi "..k
		local term = ok and "gui" or "cterm"
		local attr = ""
		for a, v in pairs(attrs) do
			if a == "ui" then
				attr = term
			elseif a == "bg" or a == "fg" or ok then
				attr = term..a
			else
				attr = term.."fg"
			end
			if v ~= NA then hi = hi.." "..attr.."="..v end
		end
		if hi ~= "hi "..k then vim.cmd(hi) end
	end
end

return L

--[[ Unused or linked stuff
Ignore
NormalNC
NonText EndOfBuffer Whitespace
Constant Boolean Character String
Type StorageClass Structure Typedef
Number Float
Cursor
CursorIM
Menu
StatusLine MsgSeparator
Pmenu NormalFloat
PreProc Define Include Macro PreCondit
Question
Scrollbar
Search Substitute
Special Debug Delimiter SpecialChar SpecialComment Tag
SpellBad
SpellCap
SpellLocal
SpellRare
Statement Conditional Exception Keyword Label Repeat
TermCursor
TermCursorNC
Tooltip
User1
User2
User3
User4
User5
User6
User7
User8
User9
VisualNC
debugBreakpoint
debugPC
lCursor
LspDiagnosticsDefaultHint LspDiagnosticsVirtualTextHint
LspDiagnosticsDefaultHint LspDiagnosticsFloatingHint
LspDiagnosticsDefaultHint LspDiagnosticsSignHint
LspDiagnosticsDefaultError LspDiagnosticsVirtualTextError
LspDiagnosticsDefaultError LspDiagnosticsFloatingError
LspDiagnosticsDefaultError LspDiagnosticsSignError
LspDiagnosticsDefaultWarning LspDiagnosticsVirtualTextWarning
LspDiagnosticsDefaultWarning LspDiagnosticsFloatingWarning
LspDiagnosticsDefaultWarning LspDiagnosticsSignWarning
LspDiagnosticsDefaultInformation LspDiagnosticsVirtualTextInformation
LspDiagnosticsDefaultInformation LspDiagnosticsFloatingInformation
LspDiagnosticsDefaultInformation LspDiagnosticsSignInformation
--]]

-- vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

