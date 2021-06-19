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
endif

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
set foldmethod=syntax
set foldcolumn=1
set fillchars=fold:\ ,
set number
set showbreak=▼\ 						" workaround no highlight escaped space bug
set list
set listchars=tab:┼─,trail:∙,extends:»,precedes:«,nbsp:§ " characters  			  
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

let g:polyglot_disabled = ['glsl']

if executable('ccls')
	au User lsp_setup call lsp#register_server({
				\ 'name': 'ccls',
				\ 'cmd': {server_info->['ccls']},
				\ 'root_uri': {server_info->lsp#utils#path_to_uri(
				\   lsp#utils#find_nearest_parent_file_directory(
				\     lsp#utils#get_buffer_path(),
				\     ['.ccls', 'compile_commands.json', '.git/']))},
				\ 'initialization_options': {
				\   'highlight': { 'lsRanges' : v:true },
				\   'cache': {'directory': stdpath('cache') . '/ccls' },
				\ },
				\ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc', 'h', 'hpp'],
				\ })
endif

call plug#begin()

	Plug 'prabirshrestha/vim-lsp'
	Plug 'Shougo/deoplete.nvim'
	Plug 'lighttiger2505/deoplete-vim-lsp'
	Plug 'junegunn/vim-easy-align'
	Plug 'scrooloose/nerdtree',      { 'on':  'NERDTreeToggle' }
	Plug 'sheerun/vim-polyglot'
	Plug 'beyondmarc/glsl.vim'
	Plug 'pprovost/vim-ps1',         { 'for': 'ps1' }

call plug#end()

colorscheme lmcs

" vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

