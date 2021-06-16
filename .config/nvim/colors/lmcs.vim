" Vim color file
" Name:       lmcs.vim
" Version:    2.0
" Maintainer: Luis Canaval (public02@canaval.org)
"

hi clear
if exists('syntax_on')
	syntax reset
endif
let g:colors_name = 'lmcs'

let s:c = [
			\ [       '#20201E',         'Black' ],
			\ [       '#DB4952',      'DarkBlue' ],
			\ [       '#57A128',     'DarkGreen' ],
			\ [       '#EE9D34',      'DarkCyan' ],
			\ [       '#538FD5',       'DarkRed' ],
			\ [       '#A646D3',   'DarkMagenta' ],
			\ [       '#32ABBA',    'DarkYellow' ],
			\ [       '#A09D80',          'Gray' ],
			\ [       '#786458',      'DarkGray' ],
			\ [       '#F6958F',          'Blue' ],
			\ [       '#9BC76F',         'Green' ],
			\ [       '#F5D277',          'Cyan' ],
			\ [       '#81AFF3',           'Red' ],
			\ [       '#CC8FD8',       'Magenta' ],
			\ [       '#78D2E0',        'Yellow' ],
			\ [       '#E0DDC0',         'White' ],
			\ [          'bold',          'bold' ],
			\ [     'underline',     'underline' ],
			\ [     'undercurl',     'undercurl' ],
			\ [       'reverse',       'reverse' ],
			\ [        'italic',        'italic' ],
			\ [      'standout',      'standout' ],
			\ [ 'strikethrough', 'strikethrough' ],
			\ [          'NONE',          'NONE' ]]

let s:o = [
			\ [       'Normal', -1, 23, 23 ],
			\ [   'Underlined', 12, -1, 17 ],
			\ [      'NonText',  0, -1, 23 ],
			\ [      'Special',  9, -1, -1 ],
			\ [   'SpecialKey',  8, -1, -1 ],
			\ [ 'CursorColumn', -1,  0, 23 ],
			\ [   'CursorLine', -1,  0, 23 ],
			\ [ 'CursorLineNr', 14,  0, 23 ],
			\ [  'ColorColumn',  8,  0, 18 ],
			\ [       'LineNr',  8, -1, -1 ],
			\ [   'FoldColumn',  7, 23, -1 ],
			\ [       'Folded',  7, 23, -1 ],
			\ [   'MatchParen', 11,  7, 23 ],
			\ [    'IncSearch', 15,  5, 23 ],
			\ [       'Search', 15,  2, 23 ],
			\ [ 'QuickFixLine', 11,  2, 23 ],
			\ [        'Pmenu',  7,  0, -1 ],
			\ [     'PmenuSel',  0,  3, -1 ],
			\ [    'PmenuSbar',  0,  8, -1 ],
			\ [   'PmenuThumb',  0,  7, -1 ],
			\ [    'VertSplit',  8, 23, 23 ],
			\ [   'StatusLine',  0,  7, 23 ],
			\ [ 'StatusLineNC',  8,  0, 23 ],
			\ [      'TabLine',  8,  0, 23 ],
			\ [   'TabLineSel', 14, 23, 23 ],
			\ [  'TabLineFill',  8,  0, 23 ],
			\ [   'SignColumn',  9,  1, -1 ],
			\ [       'Visual', 15,  7, 23 ],
			\ [    'VisualNOS',  4,  1, 23 ],
			\ [     'WildMenu',  0,  3, 23 ],
			\ [      'MsgArea',  6, -1, -1 ],
			\ [      'ModeMsg', 14, -1, 23 ],
			\ [   'WarningMsg',  3, -1, 23 ],
			\ [     'ErrorMsg',  1, 23, 23 ],
			\ [      'MoreMsg',  2, -1, 23 ],
			\ [      'Comment',  8, -1, 20 ],
			\ [         'Todo',  3, 23, -1 ],
			\ [        'Error', 15,  1, -1 ],
			\ [   'Identifier', 12, -1, 23 ],
			\ [     'Function',  4, -1, 23 ],
			\ [      'PreProc', 11, -1, -1 ],
			\ [       'Number', 10, -1, -1 ],
			\ [     'Operator',  2, -1, 23 ],
			\ [     'Constant',  3, -1, -1 ],
			\ [         'Type',  1, -1, 23 ],
			\ [    'Statement', 13, -1, 23 ],
			\ [        'Title', 13, -1, 23 ],
			\ [    'Directory', 14, -1, -1 ],
			\ [   'DiffDelete',  0,  1, 23 ],
			\ [      'DiffAdd',  0,  2, -1 ],
			\ [   'DiffChange',  0,  3, -1 ],
			\ [     'DiffText',  0,  4, 23 ]]

let s:i=( &term=='linux' ? 1 : 0 )
for o in s:o
	exe 'hi! '.o[0]
				\ .(o[1] >= 0 ? ' guifg='.s:c[o[1]][s:i] : '')
				\ .(o[2] >= 0 ? ' guibg='.s:c[o[2]][s:i] : '')
				\ .(o[3] >= 0 ?   ' gui='.s:c[o[3]][s:i] : '')
endfor

unlet s:i
unlet s:c
unlet s:o

"" Unused or linked stuff
" Conceal
" Ignore
" NormalNC
" NonText EndOfBuffer Whitespace
" Constant Boolean Character String
" Type StorageClass Structure Typedef
" Number Float
" Cursor
" CursorIM
" Menu
" StatusLine MsgSeparator
" Pmenu NormalFloat
" PreProc Define Include Macro PreCondit
" Question
" Scrollbar
" Search Substitute
" Special Debug Delimiter SpecialChar SpecialComment Tag
" SpellBad
" SpellCap
" SpellLocal
" SpellRare
" Statement Conditional Exception Keyword Label Repeat
" TermCursor
" TermCursorNC
" Tooltip
" User1
" User2
" User3
" User4
" User5
" User6
" User7
" User8
" User9
" VisualNC
" debugBreakpoint
" debugPC
" lCursor

" vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

