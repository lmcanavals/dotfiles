-- author: lmcanavals
-- date:   2021-06-18
-- TODO: check:
--	TimUntersberger/neogit
--	folke/which-key.nvim
--	kevinhwang91/nvim-hlslens
--	kevinhwang91/nvim-bqf

local cmd  = vim.cmd
local fn   = vim.fn
local g    = vim.g
local map  = vim.api.nvim_set_keymap
local ncmd = vim.api.nvim_command
local opt  = vim.opt

local setupOptions = function()
	opt.background   = "dark"
	opt.colorcolumn  = "81"
	opt.completeopt  = {"menuone", "noselect"}
	opt.cursorcolumn = true
	opt.cursorline   = true
	opt.expandtab    = false
	opt.fillchars    = {fold=" "}
	opt.laststatus   = 0
	opt.list         = true
	opt.listchars    = {tab="┼─", trail="∙", extends="»", precedes="«", nbsp="§"}
	opt.mouse        = "a"
	opt.number       = true
	opt.scrolloff    = 5
	opt.shiftwidth   = 2
	opt.showbreak    = "▼ "
	opt.showmatch    = true
	opt.smartindent  = true
	opt.softtabstop  = 2
	opt.statusline   = "%f%M%Y%R%H%W,%{&ff},%{&fenc?&fenc:&enc}%=%-10(%l,%c%V%)%P"
	opt.tabstop      = 2
	opt.title        = true
	opt.wildignore   = "*~,*.o,*.tmp"
	opt.wildmode     = {"longest:full", "full"}

	opt.termguicolors = true

	g.mapleader = " "
	local opts  = {noremap = true}
	local l     = "<leader>"
	map("n", l.."<space>", ":noh<cr>",             opts)
	map("n", l.."w",       ":w<cr>",               opts)
	map("n", l.."n",       ":bn<cr>",              opts)
	map("n", l.."p",       ":bp<cr>",              opts)
	map("n", l.."d",       ":bd<cr>",              opts)
	map("n", l.."t",       ":NvimTreeToggle<cr>",  opts)

	cmd'colorscheme lmcs'
end

local setupPackages = function()
	local pm_path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
	if fn.empty(fn.glob(pm_path)) > 0 then
		ncmd("!git clone --depth 1 https://github.com/savq/paq-nvim "..pm_path)
	end

	require'paq-nvim' {
		"savq/paq-nvim";
		"neovim/nvim-lspconfig";
		"hrsh7th/nvim-compe";
		{"nvim-treesitter/nvim-treesitter", run="TSUpdate"};
		"junegunn/fzf";
		"junegunn/fzf.vim";
		"ojroques/nvim-lspfuzzy";
		"kyazdani42/nvim-tree.lua";
		-- "rktjmp/lush.nvim"; -- only if we need to do some low level color cool
	}
end

local setupLspconfig = function()
	local nvim_lsp = require'lspconfig'
	nvim_lsp.ccls.setup {
		init_options = {
			compilationDatabaseDirectory = "build";
			index = {
				threads = 0;
			};
			clang = {
				excludeArgs = {"-frounding-math"};
			};
		}
	}
	nvim_lsp.gopls.setup {
		-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
		cmd = {"gopls", "serve"},
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
			},
		},
	}
	nvim_lsp.pyright.setup {
	}

	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	local on_attach = function(client, bufnr)
		local function bsk(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
		local function bso(...) vim.api.nvim_buf_set_option(bufnr, ...) end

		--Enable completion triggered by <c-x><c-o>
		bso("omnifunc", "v:lua.vim.lsp.omnifunc")

		-- Mappings.
		local opts = {noremap=true, silent=true}
		local cl   = "<cmd>lua "
		local clv  = cl.."vim.lsp."

		-- See `:help vim.lsp.*` for documentation on any of the below functions
		bsk("n", "gD",        clv.."buf.declaration()<CR>", opts)
		bsk("n", "gd",        clv.."buf.definition()<CR>", opts)
		bsk("n", "K",         clv.."buf.hover()<CR>", opts)
		bsk("n", "gi",        clv.."buf.implementation()<CR>", opts)
		bsk("n", "<C-k>",     clv.."buf.signature_help()<CR>", opts)
		bsk("n", "<space>wa", clv.."buf.add_workspace_folder()<CR>", opts)
		bsk("n", "<space>wr", clv.."buf.remove_workspace_folder()<CR>", opts)
		bsk("n", "<space>wl",
			cl.."print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
		bsk("n", "<space>D",  clv.."buf.type_definition()<CR>", opts)
		bsk("n", "<space>rn", clv.."buf.rename()<CR>", opts)
		bsk("n", "<space>ca", clv.."buf.code_action()<CR>", opts)
		bsk("n", "gr",        clv.."buf.references()<CR>", opts)
		bsk("n", "<space>e",  clv.."diagnostic.show_line_diagnostics()<CR>", opts)
		bsk("n", "[d",        clv.."diagnostic.goto_prev()<CR>", opts)
		bsk("n", "]d",        clv.."diagnostic.goto_next()<CR>", opts)
		bsk("n", "<space>q",  clv.."diagnostic.set_loclist()<CR>", opts)
		bsk("n", "<space>f",  clv.."buf.formatting()<CR>", opts)

	end

	-- Use a loop to conveniently call "setup" on multiple servers and
	-- map buffer local keybindings when the language server attaches
	local servers = {"ccls", "gopls", "pyright"}
	for _, lsp in ipairs(servers) do
		nvim_lsp[lsp].setup {on_attach = on_attach}
	end
end

local setupCompe = function()
	require'compe'.setup {
		enabled = true;
		autocomplete = true;
		debug = false;
		min_length = 1;
		preselect = 'enable';
		throttle_time = 80;
		source_timeout = 200;
		incomplete_delay = 400;
		max_abbr_width = 100;
		max_kind_width = 100;
		max_menu_width = 100;
		documentation = true;

		source = {
			path = true;
			nvim_lsp = true;
		};
	}

	local t = function(str)
		return vim.api.nvim_replace_termcodes(str, true, true, true)
	end

	local check_back_space = function()
		local col = fn.col('.') - 1
		return col == 0 or fn.getline('.'):sub(col, col):match('%s')
	end

	-- Use (s-)tab to:
	--- move to prev/next item in completion menuone
	--- jump to prev/next snippet's placeholder
	_G.tab_complete = function()
		if fn.pumvisible() == 1 then
			return t "<C-n>"
		elseif check_back_space() then
			return t "<Tab>"
		else
			return fn['compe#complete']()
		end
	end
	_G.s_tab_complete = function()
		if fn.pumvisible() == 1 then return t "<C-p>" else return t "<S-Tab>" end
	end

	map("i", "<Tab>",   "v:lua.tab_complete()",   {expr = true})
	map("s", "<Tab>",   "v:lua.tab_complete()",   {expr = true})
	map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
	map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
end

local setupTreesitter = function()
	require'nvim-treesitter.configs'.setup {
		highlight = {
			enable = true,
			custom_captures = {
				-- Highlight the @foo.bar capture group with the "Identifier" hl-group.
				["foo.bar"] = "Identifier",
			},
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection    = "gnn",
				node_incremental  = "grn",
				scope_incremental = "grc",
				node_decremental  = "grm",
			},
		},
		indent = {
			enable = true
		}
	}
	opt.foldcolumn = "1"
	opt.foldmethod = "expr"
	opt.foldexpr   = "nvim_treesitter#foldexpr()"
end

local setupLspfuzzy = function()
	require('lspfuzzy').setup {}
end

setupOptions()
setupPackages()
setupLspconfig()
setupCompe()
setupTreesitter()
setupLspfuzzy()

-- vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

