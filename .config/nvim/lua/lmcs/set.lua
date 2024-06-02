-- author:  lmcanavals
-- date:    2023-07-14

if vim.g.debug then print "lmcsnvim.set" end

local opt          = vim.opt

opt.background     = 'dark'
opt.colorcolumn    = '81'
opt.completeopt    = { 'menuone', 'noselect' }
opt.cursorcolumn   = true
opt.cursorline     = true
opt.expandtab      = false
opt.fillchars      = { fold = ' ' --[[, vert = '┃' ]] }
opt.list           = true
opt.listchars      = {
	tab = '┼─',
	trail = '∙',
	extends = '»',
	precedes = '«',
	nbsp = '§'
}
opt.mouse          = 'a'
opt.number         = true
opt.relativenumber = true
opt.scrolloff      = 8
opt.shiftwidth     = 2
opt.showbreak      = '▼ '
opt.showmatch      = true
opt.smartindent    = true
opt.softtabstop    = 2
opt.statusline     = '%t%M%=%l,%v' --%{&ff},%{&fenc?&fenc:&enc}
opt.tabstop        = 2
opt.title          = true
opt.undofile       = true
opt.wildignore     = { '*~', '*.o', '*.tmp' }
opt.wildmode       = { 'longest:full', 'full' }

opt.ignorecase     = true
opt.smartcase      = true

vim.cmd 'colorscheme lmcs'
vim.cmd 'autocmd TermOpen * setlocal nonumber foldcolumn=0'

-- vim: set ts=2:sw=2:noet:sts=2:
