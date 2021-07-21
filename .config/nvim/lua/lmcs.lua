-- Vim color file
-- Name:				lmcs.lua
-- Version:			3.0
-- Maintainer:	lmcanavals

local BG = "#20201e"
local RE = "#db4952"
local GR = "#57a128"
local YE = "#ee9d34"
local BL = "#538fd5"
local MA = "#a646d3"
local CY = "#32abba"
local WH = "#a09d80"
local bg = "#786458"
local re = "#f6958f"
local gr = "#9bc76f"
local ye = "#f5d277"
local bl = "#81aff3"
local ma = "#cc8fd8"
local cy = "#78d2e0"
local wh = "#e0ddc0"

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
	--              gui  bg  fg|sp
	Normal       = { gui = NA, guibg = NA, guifg = NA },
	Underlined   = { gui = UL, guibg = NA, guisp = BL },
	NonText      = { gui = NA, guibg = NA, guifg = BG },
	Special      = { gui = NA, guibg = NA, guifg = MA },
	SpecialKey   = { gui = NA, guibg = NA, guifg = bg },
	CursorColumn = { gui = NA, guibg = BG, guifg = NA },
	CursorLine   = { gui = NA, guibg = BG, guifg = NA },
	CursorLineNr = { gui = NA, guibg = BG, guifg = cy },
	ColorColumn  = { gui = UC, guibg = NA, guisp = bg },
	LineNr       = { gui = NA, guibg = NA, guifg = bg },
	FoldColumn   = { gui = NA, guibg = NA, guifg = bg },
	Folded       = { gui = NA, guibg = NA, guifg = WH },
	MatchParen   = { gui = BO, guibg = NA, guifg = wh },
	IncSearch    = { gui = NA, guibg = MA, guifg = wh },
	Search       = { gui = NA, guibg = GR, guifg = wh },
	QuickFixLine = { gui = NA, guibg = GR, guifg = ye },
	Pmenu        = { gui = NA, guibg = BG, guifg = WH },
	PmenuSel     = { gui = NA, guibg = YE, guifg = BG },
	PmenuSbar    = { gui = NA, guibg = bg, guifg = BG },
	PmenuThumb   = { gui = NA, guibg = WH, guifg = BG },
	VertSplit    = { gui = NA, guibg = NA, guifg = bg },
	StatusLine   = { gui = NA, guibg = NA, guifg = cy },
	StatusLineNC = { gui = NA, guibg = NA, guifg = bg },
	TabLine      = { gui = NA, guibg = BG, guifg = bg },
	TabLineSel   = { gui = NA, guibg = NA, guifg = cy },
	TabLineFill  = { gui = NA, guibg = BG, guifg = bg },
	SignColumn   = { gui = NA, guibg = NA, guifg = re },
	Visual       = { gui = NA, guibg = WH, guifg = wh },
	VisualNOS    = { gui = NA, guibg = RE, guifg = BL },
	WildMenu     = { gui = NA, guibg = YE, guifg = BG },
	MsgArea      = { gui = NA, guibg = NA, guifg = CY },
	ModeMsg      = { gui = NA, guibg = NA, guifg = cy },
	WarningMsg   = { gui = NA, guibg = NA, guifg = YE },
	ErrorMsg     = { gui = NA, guibg = NA, guifg = RE },
	MoreMsg      = { gui = NA, guibg = NA, guifg = GR },
	Comment      = { gui = IT, guibg = NA, guifg = bg },
	Todo         = { gui = NA, guibg = NA, guifg = YE },
	Error        = { gui = NA, guibg = RE, guifg = BG },
	Identifier   = { gui = NA, guibg = NA, guifg = bl },
	Function     = { gui = NA, guibg = NA, guifg = BL },
	PreProc      = { gui = NA, guibg = NA, guifg = ye },
	Number       = { gui = NA, guibg = NA, guifg = gr },
	Operator     = { gui = NA, guibg = NA, guifg = GR },
	Constant     = { gui = NA, guibg = NA, guifg = YE },
	Type         = { gui = NA, guibg = NA, guifg = GR },
	Statement    = { gui = NA, guibg = NA, guifg = ma },
	Title        = { gui = NA, guibg = NA, guifg = ma },
	Directory    = { gui = NA, guibg = NA, guifg = cy },
	DiffDelete   = { gui = NA, guibg = RE, guifg = BG },
	DiffAdd      = { gui = NA, guibg = GR, guifg = BG },
	DiffChange   = { gui = NA, guibg = YE, guifg = BG },
	DiffText     = { gui = NA, guibg = BL, guifg = BG },
	LspDiagnosticsDefaultError         = { gui = NA, guibg = NA, guifg = RE },
	LspDiagnosticsDefaultWarning       = { gui = NA, guibg = NA, guifg = YE },
	LspDiagnosticsDefaultInformation   = { gui = NA, guibg = NA, guifg = CY },
	LspDiagnosticsDefaultHint          = { gui = NA, guibg = NA, guifg = ye },
	LspDiagnosticsUnderlineError       = { gui = UC, guibg = NA, guisp = RE },
	LspDiagnosticsUnderlineWarning     = { gui = UC, guibg = NA, guisp = YE },
	LspDiagnosticsUnderlineInformation = { gui = UC, guibg = NA, guisp = CY },
	LspDiagnosticsUnderlineHint        = { gui = UC, guibg = NA, guisp = ye },
}

local L = {}

function L.color()
	vim.cmd'hi clear'
	vim.cmd'syntax reset'
	vim.g.colors_name = 'lmcs'
	for k, attrs in pairs(theme) do
		vim.cmd("hi clear "..k)
		local hi = "hi "..k
		for a, v in pairs(attrs) do
			if v ~= NA then hi = hi.." "..a.."="..v end
		end
		if hi ~= "hi "..k then vim.cmd(hi) end
	end
end

return L

--[[ Unused or linked stuff
Conceal
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

