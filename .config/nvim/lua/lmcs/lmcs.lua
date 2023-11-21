-- Vim color file
-- Name:       lmcs.lua
-- Version:    4.5
-- Maintainer: lmcanavals

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
	Normal                   = { ui = NON, bg = PAS, fg = PAS },
	Underlined               = { ui = ULI, bg = PAS, sp = BLU },
	NonText                  = { ui = PAS, bg = PAS, fg = BLA },
	Special                  = { ui = PAS, bg = PAS, fg = MAG },
	SpecialKey               = { ui = PAS, bg = PAS, fg = bla },
	CursorColumn             = { ui = PAS, bg = BLA, fg = PAS },
	CursorLine               = { ui = PAS, bg = BLA, fg = PAS },
	CursorLineNr             = { ui = PAS, bg = BLA, fg = YEL },
	ColorColumn              = { ui = UDT, bg = PAS, sp = YEL },
	Conceal                  = { ui = PAS, bg = PAS, fg = BLA },
	LineNr                   = { ui = { ITA, BLD }, bg = PAS, fg = bla },
	FoldColumn               = { ui = PAS, bg = PAS, fg = bla },
	Folded                   = { ui = UDA, bg = PAS, sp = BLA },
	MatchParen               = { ui = REV, bg = PAS, fg = yel },
	IncSearch                = { ui = PAS, bg = MAG, fg = whi },
	Search                   = { ui = PAS, bg = GRE, fg = whi },
	QuickFixLine             = { ui = PAS, bg = YEL, fg = whi },
	Pmenu                    = { ui = { ITA, BLD }, bg = BLA, fg = WHI },
	PmenuSel                 = { ui = PAS, bg = YEL, fg = BLA },
	PmenuSbar                = { ui = PAS, bg = bla, fg = BLA },
	PmenuThumb               = { ui = PAS, bg = WHI, fg = BLA },
	VertSplit                = { ui = PAS, bg = PAS, fg = bla },
	StatusLine               = { ui = PAS, bg = CYA, fg = whi },
	StatusLineNC             = { ui = PAS, bg = CYA, fg = bla },
	TabLine                  = { ui = PAS, bg = BLA, fg = bla },
	TabLineSel               = { ui = PAS, bg = PAS, fg = cya },
	TabLineFill              = { ui = PAS, bg = BLA, fg = bla },
	SignColumn               = { ui = PAS, bg = PAS, fg = red },
	Visual                   = { ui = PAS, bg = yel, fg = BLU },
	VisualNOS                = { ui = UDO, bg = RED, fg = BLU },
	WildMenu                 = { ui = PAS, bg = YEL, fg = BLA },
	MsgArea                  = { ui = PAS, bg = PAS, fg = CYA },
	ModeMsg                  = { ui = PAS, bg = PAS, fg = cya },
	WarningMsg               = { ui = PAS, bg = PAS, fg = YEL },
	ErrorMsg                 = { ui = PAS, bg = PAS, fg = RED },
	MoreMsg                  = { ui = PAS, bg = PAS, fg = GRE },
	Comment                  = { ui = ITA, bg = PAS, fg = bla },
	Todo                     = { ui = SOU, bg = PAS, sp = YEL },
	Error                    = { ui = PAS, bg = PAS, fg = RED },
	Identifier               = { ui = PAS, bg = PAS, fg = blu },
	Function                 = { ui = PAS, bg = PAS, fg = BLU },
	PreProc                  = { ui = PAS, bg = PAS, fg = yel },
	Number                   = { ui = PAS, bg = PAS, fg = gre },
	Operator                 = { ui = PAS, bg = PAS, fg = GRE },
	Constant                 = { ui = PAS, bg = PAS, fg = YEL },
	String                   = { ui = BLD, bg = PAS, fg = YEL },
	Type                     = { ui = PAS, bg = PAS, fg = GRE },
	Statement                = { ui = PAS, bg = PAS, fg = mag },
	Title                    = { ui = PAS, bg = PAS, fg = mag },
	Directory                = { ui = PAS, bg = PAS, fg = cya },
	DiffDelete               = { ui = PAS, bg = RED, fg = BLA },
	DiffAdd                  = { ui = PAS, bg = GRE, fg = BLA },
	DiffChange               = { ui = PAS, bg = YEL, fg = BLA },
	DiffText                 = { ui = PAS, bg = BLU, fg = BLA },
	DiagnosticDeprecated     = { ui = { STH, ITA, BLD }, bg = PAS, sp = bla },
	DiagnosticError          = { ui = { ITA, BLD }, bg = PAS, fg = RED },
	DiagnosticHint           = { ui = { ITA, BLD }, bg = PAS, fg = yel },
	DiagnosticInfo           = { ui = { ITA, BLD }, bg = PAS, fg = CYA },
	DiagnosticWarn           = { ui = { ITA, BLD }, bg = PAS, fg = YEL },
	DiagnosticUnderlineError = { ui = UCU, bg = PAS, sp = RED },
	DiagnosticUnderlineHint  = { ui = UCU, bg = PAS, sp = yel },
	DiagnosticUnderlineInfo  = { ui = UCU, bg = PAS, sp = CYA },
	DiagnosticUnderlineWarn  = { ui = UCU, bg = PAS, sp = YEL },
	-- Notify nvim plugin
	NotifyBackground         = { ui = { ITA, BLD }, bg = BLA, fg = PAS },
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
			-- TODO there is a limitation, table type is valid only for ui element
			local theval = ""
			if type(value) == 'table' then
				theval = ""
				for i, vali in pairs(value) do
					theval = theval .. (i > 1 and "," or "") .. specials[vali - 16]
				end
			else
				theval = value < 17 and tostring(colors[value]) or specials[value - 16]
			end
			if value ~= PAS then
				hi = hi .. " " .. target .. attr[name] .. "=" .. theval
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
