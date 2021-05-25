"
" My config
"

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
	let s:t='~/.local/share/nvim/site/autoload/plug.vim'
	let s:u='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	silent exec '!curl -fLo '.s:t.' --create-dirs '.s:u
	unlet s:t
	unlet s:u
	source $MYVIMRC
else
	set showmatch
	set tabstop=2
	set softtabstop=2
	set noexpandtab
	set smartindent
	set shiftwidth=2
	set wildmode=longest:full,full
	set wildignore+=*~,*.o,*.tmp
	set colorcolumn=81
	set cursorline
	set cursorcolumn
	set number
	set sbr=▼\ 
	set list
	set listchars=tab:┼─,trail:∙,extends:»,precedes:«,nbsp:§
" Example characters
		   
	set scrolloff=5
	set statusline=%f%M%Y%R%H%W,%{&ff},%{&fenc?&fenc:&enc}%=%-10(%l,%c%V%)%P
	set laststatus=0
	set background=dark
	set termguicolors
	set title
	set mouse=a

	map <space> \

	nnoremap <leader><space> :noh<cr>
	nnoremap <leader>w :w<cr>
	nnoremap <leader>n :bn<cr>
	nnoremap <leader>N :bp<cr>
	nnoremap <leader>d :bd<cr>

	xmap <leader>a <Plug>(EasyAlign)
	nmap <leader>a <Plug>(EasyAlign)

	call plug#begin()

	Plug 'junegunn/vim-easy-align'
	Plug 'scrooloose/nerdtree',      { 'on':  'NERDTreeToggle' }
	Plug 'beyondmarc/glsl.vim'
	Plug 'fatih/vim-go',             { 'for': 'go' } " 'do': ':GoUpdateBinaries'
	Plug 'pprovost/vim-ps1',         { 'for': 'ps1' }

	call plug#end()

	colorscheme lmcs

endif

" vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

