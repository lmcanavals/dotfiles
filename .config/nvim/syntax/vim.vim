" Description: Displays highlight objects color inside colorscheme file
" Name:        vim.vim
" Version:     3.0
" Maintainer:  Luis Canaval (public02@canaval.org)
"

let s:tokens=[
			\ 'Boolean',      'Character',    'ColorColumn',    'Comment',
			\ 'Conceal',      'Conditional',  'Constant',       'Cursor',
			\ 'CursorColumn', 'CursorIM',     'CursorLine',     'CursorLineNr',
			\ 'Debug',        'Define',       'Delimiter',      'DiffAdd',
			\ 'DiffChange',   'DiffDelete',   'DiffText',       'Directory',
			\ 'EndOfBuffer',  'Error',        'ErrorMsg',       'Exception',
			\ 'Float',        'FoldColumn',   'Folded',         'Function',
			\ 'Identifier',   'Ignore',       'IncSearch',      'Include',
			\ 'Keyword',      'Label',        'LineNr',         'Macro',
			\ 'MatchParen',   'Menu',         'ModeMsg',        'MoreMsg',
			\ 'MsgArea',      'MsgSeparator', 'NonText',        'Normal',
			\ 'NormalFloat',  'NormalNC',     'Number',         'Operator',
			\ 'Pmenu',        'PmenuSbar',    'PmenuSel',       'PmenuThumb',
			\ 'PreCondit',    'PreProc',      'Question',       'QuickFixLine',
			\ 'Repeat',       'Scrollbar',    'Search',         'SignColumn',
			\ 'Special',      'SpecialChar',  'SpecialComment', 'SpecialKey',
			\ 'SpellBad',     'SpellCap',     'SpellLocal',     'SpellRare',
			\ 'Statement',    'StatusLine',   'StatusLineNC',   'StorageClass',
			\ 'String',       'Structure',    'Substitute',     'TabLine',
			\ 'TabLineFill',  'TabLineSel',   'Tag',            'TermCursor',
			\ 'TermCursorNC', 'Title',        'Todo',           'Tooltip',
			\ 'Type',         'Typedef',      'Underlined',     'User1',
			\ 'User2',        'User3',        'User4',          'User5',
			\ 'User6',        'User7',        'User8',          'User9',
			\ 'VertSplit',    'Visual',       'VisualNC',       'VisualNOS',
			\ 'WarningMsg',   'Whitespace',   'WildMenu',       'debugBreakpoint',
			\ 'debugPC',      'lCursor',
			\ 'DiagnosticDefaultError',
			\ 'DiagnosticDefaultHint',
			\ 'DiagnosticDefaultInfo',
			\ 'DiagnosticDefaultWarn',
			\ 'DiagnosticFloatingError',
			\ 'DiagnosticFloatingHint',
			\ 'DiagnosticFloatingInfo',
			\ 'DiagnosticFloatingWarn',
			\ 'DiagnosticSignError',
			\ 'DiagnosticSignHint',
			\ 'DiagnosticSignInfo',
			\ 'DiagnosticSignWarn',
			\ 'DiagnosticUnderlineError',
			\ 'DiagnosticUnderlineHint',
			\ 'DiagnosticUnderlineInfo',
			\ 'DiagnosticUnderlineWarn',
			\ 'DiagnosticVirtualTextError',
			\ 'DiagnosticVirtualTextHint',
			\ 'DiagnosticVirtualTextInfo',
			\ 'DiagnosticVirtualTextWarn']

for token in s:tokens
	exe 'sy match lmcs'.token.' "\<'.token.'\>" containedin=vimString contained'
	exe 'hi def link lmcs'.token.' '.token
endfor

unlet s:tokens

" vim: set ts=2:sw=2:noet:sts=2:
