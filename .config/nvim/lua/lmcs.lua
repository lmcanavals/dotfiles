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
	local f = assert(io.open(vim.env.HOME .. "/.config/zsh/colors", "rb"))
	lclr = f:read("*all")
	f:close()
end

local guicolors = vim.split(lclr, "\n", { trimempty = true })
local termcolors = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
local specials = {
	"bold",
	"underline",
	"undercurl",
	"underdouble",
	"underdotted",
	"underdashed",
	"strikethrough",
	"reverse",
	"italic",
	"standout",
	"altfont",
	"nocombine",
	"none",
	"na"
}

local BLA = 1
local RED = 2
local GRE = 3
local YEL = 4
local BLU = 5
local MAG = 6
local CYA = 7
local WHI = 8
local bla = 9
local red = 10
local gre = 11
local yel = 12
local blu = 13
local mag = 14
local cya = 15
local whi = 16

local BLD = 17
local ULI = 18
local UCU = 19
local UDO = 20
local UDT = 21
local UDA = 22
local STH = 23
local REV = 24
local ITA = 25
local SOU = 26
local AFO = 27
local NCO = 28
local NON = 29
local PAS = 30

local theme = {
	Normal                             = { ui = PAS, bg = PAS, fg = PAS },
	Underlined                         = { ui = ULI, bg = PAS, sp = BLU },
	NonText                            = { ui = PAS, bg = PAS, fg = BLA },
	Special                            = { ui = PAS, bg = PAS, fg = MAG },
	SpecialKey                         = { ui = PAS, bg = PAS, fg = bla },
	CursorColumn                       = { ui = PAS, bg = BLA, fg = PAS },
	CursorLine                         = { ui = PAS, bg = BLA, fg = PAS },
	CursorLineNr                       = { ui = PAS, bg = BLA, fg = YEL },
	ColorColumn                        = { ui = UDT, bg = PAS, sp = YEL },
	Conceal                            = { ui = PAS, bg = PAS, fg = BLA },
	LineNr                             = { ui = PAS, bg = PAS, fg = bla },
	FoldColumn                         = { ui = PAS, bg = PAS, fg = bla },
	Folded                             = { ui = PAS, bg = PAS, fg = WHI },
	MatchParen                         = { ui = BLD, bg = PAS, fg = whi },
	IncSearch                          = { ui = UDO, bg = PAS, sp = MAG },
	Search                             = { ui = UDO, bg = PAS, sp = GRE },
	QuickFixLine                       = { ui = UDO, bg = PAS, sp = YEL },
	Pmenu                              = { ui = PAS, bg = BLA, fg = WHI },
	PmenuSel                           = { ui = PAS, bg = YEL, fg = BLA },
	PmenuSbar                          = { ui = PAS, bg = bla, fg = BLA },
	PmenuThumb                         = { ui = PAS, bg = WHI, fg = BLA },
	VertSplit                          = { ui = PAS, bg = PAS, fg = bla },
	StatusLine                         = { ui = PAS, bg = CYA, fg = whi },
	StatusLineNC                       = { ui = PAS, bg = CYA, fg = bla },
	TabLine                            = { ui = PAS, bg = BLA, fg = bla },
	TabLineSel                         = { ui = PAS, bg = PAS, fg = cya },
	TabLineFill                        = { ui = PAS, bg = BLA, fg = bla },
	SignColumn                         = { ui = PAS, bg = PAS, fg = red },
	Visual                             = { ui = PAS, bg = yel, fg = BLU },
	VisualNOS                          = { ui = PAS, bg = RED, fg = BLU },
	WildMenu                           = { ui = PAS, bg = YEL, fg = BLA },
	MsgArea                            = { ui = PAS, bg = PAS, fg = CYA },
	ModeMsg                            = { ui = PAS, bg = PAS, fg = cya },
	WarningMsg                         = { ui = PAS, bg = PAS, fg = YEL },
	ErrorMsg                           = { ui = PAS, bg = PAS, fg = RED },
	MoreMsg                            = { ui = PAS, bg = PAS, fg = GRE },
	Comment                            = { ui = ITA, bg = PAS, fg = bla },
	Todo                               = { ui = UDA, bg = PAS, sp = YEL },
	Error                              = { ui = PAS, bg = PAS, fg = RED },
	Identifier                         = { ui = PAS, bg = PAS, fg = blu },
	Function                           = { ui = PAS, bg = PAS, fg = BLU },
	PreProc                            = { ui = PAS, bg = PAS, fg = yel },
	Number                             = { ui = PAS, bg = PAS, fg = gre },
	Operator                           = { ui = PAS, bg = PAS, fg = GRE },
	Constant                           = { ui = PAS, bg = PAS, fg = YEL },
	Type                               = { ui = PAS, bg = PAS, fg = GRE },
	Statement                          = { ui = PAS, bg = PAS, fg = mag },
	Title                              = { ui = PAS, bg = PAS, fg = mag },
	Directory                          = { ui = PAS, bg = PAS, fg = cya },
	DiffDelete                         = { ui = PAS, bg = YEL, fg = BLA },
	DiffAdd                            = { ui = PAS, bg = GRE, fg = BLA },
	DiffChange                         = { ui = PAS, bg = YEL, fg = BLA },
	DiffText                           = { ui = PAS, bg = BLU, fg = BLA },
	LspDiagnosticsDefaultError         = { ui = PAS, bg = PAS, fg = RED },
	LspDiagnosticsDefaultWarning       = { ui = PAS, bg = PAS, fg = YEL },
	LspDiagnosticsDefaultInformation   = { ui = PAS, bg = PAS, fg = CYA },
	LspDiagnosticsDefaultHint          = { ui = PAS, bg = PAS, fg = yel },
	LspDiagnosticsUnderlineError       = { ui = UCU, bg = PAS, sp = RED },
	LspDiagnosticsUnderlineWarning     = { ui = UCU, bg = PAS, sp = YEL },
	LspDiagnosticsUnderlineInformation = { ui = UCU, bg = PAS, sp = CYA },
	LspDiagnosticsUnderlineHint        = { ui = UCU, bg = PAS, sp = yel },
}

local L = {}

function L.color()
	local colors = gui and guicolors or termcolors
	local target = gui and "gui" or "cterm"
	vim.cmd 'hi clear'
	vim.cmd 'syntax reset'
	vim.g.colors_name = 'lmcs'
	for hlGroup, attributes in pairs(theme) do
		vim.cmd("hi clear " .. hlGroup)
		local hi = "hi " .. hlGroup
		local attr = { ui = "", bg = "bg", fg = "fg", sp = gui and "sp" or "fg" }
		local nonEmpty = false
		for name, value in pairs(attributes) do
			if value ~= PAS then
				hi = hi .. " " .. target .. attr[name] .. "="
						.. (value < 17 and colors[value] or specials[value - 16])
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
