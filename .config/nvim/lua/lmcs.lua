-- Vim color file
-- Name:				lmcs.lua
-- Version:			4.1
-- Maintainer:	lmcanavals

local gui = vim.env.ISMOSHBRUH ~= "yup"

vim.opt.termguicolors = gui

local lclr
if vim.env.LCLR ~= nil then
	lclr = vim.env.LCLR
else
	local f = assert(io.open(vim.env.HOME.."/.config/zsh/colors", "rb"))
	lclr = f:read("*all")
	f:close()
end

local guicolors = vim.split(lclr, "\n", true)
local termcolors = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
local specials = {
	"bold",
	"underline",
	"undercurl",
	"reverse",
	"italic",
	"standout",
	"strikethrough",
	"none",
	"na"
}

local BG = 1
local RE = 2
local GR = 3
local YE = 4
local BL = 5
local MA = 6
local CY = 7
local WH = 8
local bg = 9
local re = 10
local gr = 11
local ye = 12
local bl = 13
local ma = 14
local cy = 15
local wh = 16

local BO = 17
local UL = 18
local UC = 19
local RV = 20
local IT = 21
local SO = 22
local ST = 23
local NO = 24
local NA = 25

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
	Error        = { ui = NA, bg = NA, fg = RE },
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
	local colors = gui and guicolors or termcolors
	local target = gui and "gui" or "cterm"
	vim.cmd'hi clear'
	vim.cmd'syntax reset'
	vim.g.colors_name = 'lmcs'
	for hlGroup, attributes in pairs(theme) do
		vim.cmd("hi clear "..hlGroup)
		local hi = "hi "..hlGroup
		local attr = { ui = "", bg = "bg", fg = "fg", sp = gui and "sp" or "fg" }
		local nonEmpty = false
		for name, value in pairs(attributes) do
			if value ~= NA then
				hi = hi.." "..target..attr[name].."="..(value < 17 and colors[value] or specials[value - 16])
				nonEmpty = true
			end
		end
		if nonEmpty then vim.cmd(hi) end
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

-- vim: set ts=2:sw=2:noet:sts=2:
