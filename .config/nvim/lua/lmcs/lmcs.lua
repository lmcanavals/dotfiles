-- Vim color file
-- Name:       lmcs.lua
-- Version:    4.5
-- Maintainer: lmcanavals

local gui = vim.env.ISMOSHBRUH ~= 'yup'

vim.opt.termguicolors = gui

local lclr
if vim.env.LCLR ~= nil then
	lclr = vim.env.LCLR
else
	local f = assert(io.open(vim.env.HOME .. '/.config/zsh/colors', 'rb'))
	lclr = f:read('*all')
	f:close()
end

local guicolors = vim.split(lclr, '\n', { trimempty = true })
local termcolors = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
local specials = {
	'bold',
	'underline',
	'undercurl',
	'underdouble',
	'underdotted',
	'underdashed',
	'strikethrough',
	'reverse',
	'italic',
	'standout',
	'altfont',
	'nocombine',
	'none',
	'na'
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
	Normal                   = { bg = NON, fg = PAS, ui = NON },
	Underlined               = { bg = PAS, sp = BLU, ui = ULI },
	NonText                  = { bg = PAS, fg = BLA, ui = PAS },
	Special                  = { bg = PAS, fg = YEL, ui = PAS },
	SpecialKey               = { bg = PAS, fg = bla, ui = PAS },
	CursorColumn             = { bg = BLA, fg = PAS, ui = PAS },
	CursorLine               = { bg = BLA, fg = PAS, ui = PAS },
	CursorLineNr             = { bg = BLA, fg = gre, ui = { ITA, BLD } },
	ColorColumn              = { bg = PAS, sp = mag, ui = UDT },
	Conceal                  = { bg = PAS, fg = BLA, ui = PAS },
	LineNr                   = { bg = PAS, fg = bla, ui = { ITA, BLD } },
	FoldColumn               = { bg = PAS, fg = bla, ui = PAS },
	Folded                   = { bg = PAS, fg = CYA, sp = BLA, ui = UDA },
	MatchParen               = { bg = PAS, fg = MAG, ui = REV },
	IncSearch                = { bg = MAG, fg = whi, ui = PAS },
	Search                   = { bg = GRE, fg = whi, ui = PAS },
	QuickFixLine             = { bg = YEL, fg = whi, ui = PAS },
	Pmenu                    = { bg = BLA, fg = WHI, ui = { ITA, BLD } },
	PmenuSel                 = { bg = YEL, fg = BLA, ui = PAS },
	PmenuSbar                = { bg = bla, fg = BLA, ui = PAS },
	PmenuThumb               = { bg = WHI, fg = BLA, ui = PAS },
	VertSplit                = { bg = PAS, fg = bla, ui = PAS },
	StatusLine               = { bg = CYA, fg = whi, ui = PAS },
	StatusLineNC             = { bg = CYA, fg = bla, ui = PAS },
	TabLine                  = { bg = BLA, fg = bla, ui = PAS },
	TabLineSel               = { bg = PAS, fg = cya, ui = PAS },
	TabLineFill              = { bg = BLA, fg = bla, ui = PAS },
	SignColumn               = { bg = PAS, fg = red, ui = PAS },
	Visual                   = { bg = yel, fg = BLU, ui = PAS },
	VisualNOS                = { bg = RED, fg = BLU, ui = UDO },
	WildMenu                 = { bg = YEL, fg = BLA, ui = PAS },
	MsgArea                  = { bg = PAS, fg = CYA, ui = PAS },
	ModeMsg                  = { bg = PAS, fg = cya, ui = PAS },
	WarningMsg               = { bg = PAS, fg = YEL, ui = PAS },
	ErrorMsg                 = { bg = PAS, fg = RED, ui = PAS },
	MoreMsg                  = { bg = PAS, fg = GRE, ui = PAS },
	Comment                  = { bg = PAS, fg = bla, ui = ITA },
	Todo                     = { bg = PAS, sp = YEL, ui = SOU },
	Error                    = { bg = PAS, fg = RED, ui = PAS },
	Identifier               = { bg = PAS, fg = WHI, ui = PAS },
	Function                 = { bg = PAS, fg = yel, ui = PAS },
	PreProc                  = { bg = PAS, fg = yel, ui = PAS },
	Number                   = { bg = PAS, fg = cya, ui = PAS },
	Operator                 = { bg = PAS, fg = WHI, ui = PAS },
	Constant                 = { bg = PAS, fg = blu, ui = PAS },
	String                   = { bg = PAS, fg = blu, ui = BLD },
	Type                     = { bg = PAS, fg = GRE, ui = PAS },
	Statement                = { bg = PAS, fg = YEL, ui = PAS },
	Title                    = { bg = PAS, fg = YEL, ui = PAS },
	Directory                = { bg = PAS, fg = cya, ui = PAS },
	DiffDelete               = { bg = RED, fg = BLA, ui = PAS },
	DiffAdd                  = { bg = GRE, fg = BLA, ui = PAS },
	DiffChange               = { bg = YEL, fg = BLA, ui = PAS },
	DiffText                 = { bg = BLU, fg = BLA, ui = PAS },
	DiagnosticDeprecated     = { bg = PAS, sp = bla, ui = { STH, ITA, BLD } },
	DiagnosticError          = { bg = PAS, fg = RED, ui = { ITA, BLD } },
	DiagnosticHint           = { bg = PAS, fg = yel, ui = { ITA, BLD } },
	DiagnosticInfo           = { bg = PAS, fg = CYA, ui = { ITA, BLD } },
	DiagnosticWarn           = { bg = PAS, fg = YEL, ui = { ITA, BLD } },
	DiagnosticUnderlineError = { bg = PAS, sp = RED, ui = UCU },
	DiagnosticUnderlineHint  = { bg = PAS, sp = yel, ui = UCU },
	DiagnosticUnderlineInfo  = { bg = PAS, sp = CYA, ui = UCU },
	DiagnosticUnderlineWarn  = { bg = PAS, sp = YEL, ui = UCU },
	-- Notify nvim plugin
	NotifyBackground         = { ui = { ITA, BLD }, bg = BLA, fg = PAS },
}

local L = {}

function L.color()
	local colors = gui and guicolors or termcolors
	local target = gui and 'gui' or 'cterm'
	vim.cmd 'hi clear'
	vim.cmd 'syntax reset'
	vim.g.colors_name = 'lmcs'
	for hlGroup, attributes in pairs(theme) do
		vim.cmd('hi clear ' .. hlGroup)
		local hi = 'hi ' .. hlGroup
		local nonEmpty = false
		for attr, value in pairs(attributes) do
			local val = ''
			if attr == 'ui' and type(value) == 'table' then
				val = ''
				for i, vali in pairs(value) do
					val = val .. (i > 1 and ',' or '') .. specials[vali - 16]
				end
			else
				val = value < 17 and tostring(colors[value]) or specials[value - 16]
			end
			if value ~= PAS then
				hi = hi .. ' ' .. target .. (attr ~= 'ui' and attr or '') .. '=' .. val
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
DiagnosticHint DiagnosticVirtualTextHint
DiagnosticHint DiagnosticFloatingHint
DiagnosticHint DiagnosticSignHint
DiagnosticError DiagnosticVirtualTextError
DiagnosticError DiagnosticFloatingError
DiagnosticError DiagnosticSignError
DiagnosticWarn DiagnosticVirtualTextWarn
DiagnosticWarn DiagnosticFloatingWarn
DiagnosticWarn DiagnosticSignWarn
DiagnosticInfo DiagnosticVirtualTextInfo
DiagnosticInfo DiagnosticFloatingInfo
DiagnosticInfo DiagnosticSignInfo
--]]

-- vim: set ts=2:sw=2:noet:sts=2:
