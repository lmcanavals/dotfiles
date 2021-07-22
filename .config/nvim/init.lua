-- author: lmcanavals
-- date:   2021-06-18
-- TODO: check:
--	TimUntersberger/neogit
--	folke/which-key.nvim
--	kevinhwang91/nvim-hlslens
--	kevinhwang91/nvim-bqf
--	rktjmp/lush.nvim -- only if we need to do some low level color cool
--	ray-x/lsp_signature.nvim
--	https://github.com/rockerBOO/awesome-neovim#snippets

local cmd  = vim.cmd
local fn   = vim.fn
local g    = vim.g
local map  = vim.api.nvim_set_keymap
local opt  = vim.opt

local setup = function(fun)
	fun()
end

setup(function() -- options
	opt.background   = "dark"
	opt.colorcolumn  = "81"
	opt.completeopt  = {"menuone", "noselect"}
	opt.cursorcolumn = true
	opt.cursorline   = true
	opt.expandtab    = false
	opt.fillchars    = {fold=" ", stl="-", stlnc="-"}
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
	opt.statusline   = "%t%M%=%v" --%{&ff},%{&fenc?&fenc:&enc}
	opt.tabstop      = 2
	opt.title        = true
	opt.wildignore   = "*~,*.o,*.tmp"
	opt.wildmode     = {"longest:full", "full"}

	opt.termguicolors = true

	g.mapleader = " "
	local mappings = {
		["<space>"] = "noh",
		["s"]       = "w",
		["n"]       = "bn",
		["p"]       = "bp",
		["d"]       = "bd",
		["t"]       = "NvimTreeToggle"
	}
	for m, c in pairs(mappings) do
		map("n", "<leader>"..m, ":"..c.."<cr>", {noremap = true})
	end

	cmd'colorscheme lmcs'
	cmd'autocmd TermOpen * setlocal nonumber foldcolumn=0'
end)

setup(function() -- packages
	local pm_path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
	if fn.empty(fn.glob(pm_path)) > 0 then
		cmd("!git clone --depth 1 https://github.com/savq/paq-nvim "..pm_path)
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
		"beyondmarc/glsl.vim";
		"norcalli/nvim-colorizer.lua";
	}
end)

setup(function() -- lspconfig
	local nvim_lsp = require'lspconfig'

	local on_attach = function(client, bufnr)
		local function bsk(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
		local function bso(...) vim.api.nvim_buf_set_option(bufnr, ...) end

		--Enable completion triggered by <c-x><c-o>
		bso("omnifunc", "v:lua.vim.lsp.omnifunc")

		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local mappings = {
			["<space>wa"] = "buf.add_workspace_folder()",
			["<space>ca"] = "buf.code_action()",
			["gD"]        = "buf.declaration()",
			["gd"]        = "buf.definition()",
			["<space>f"]  = "buf.formatting()",
			["K"]         = "buf.hover()",
			["gi"]        = "buf.implementation()",
			["gr"]        = "buf.references()",
			["<space>wr"] = "buf.remove_workspace_folder()",
			["<space>rn"] = "buf.rename()",
			["<C-k>"]     = "buf.signature_help()",
			["<space>D"]  = "buf.type_definition()",
			["]d"]        = "diagnostic.goto_next()",
			["[d"]        = "diagnostic.goto_prev()",
			["<space>q"]  = "diagnostic.set_loclist()",
			["<space>e"]  = "diagnostic.show_line_diagnostics()",
		}
		for m, c in pairs(mappings) do
			bsk("n", m, "<cmd>lua vim.lsp."..c.."<CR>", {noremap=true, silent=true})
		end
		--"<space>wl"
		--"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))"
	end

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
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
			},
		},
	}
	nvim_lsp.pyright.setup {}
	nvim_lsp.denols.setup {
		init_options = {
			lint = true
		},
	}

	local servers = {"ccls", "gopls", "pyright", "denols"}
	for _, lsp in ipairs(servers) do
		nvim_lsp[lsp].setup {on_attach = on_attach}
	end
end)

setup(function() -- compe
	require'compe'.setup {
		enabled          = true;
		autocomplete     = true;
		debug            = false;
		min_length       = 1;
		preselect        = "enable";
		throttle_time    = 80;
		source_timeout   = 200;
		incomplete_delay = 400;
		max_abbr_width   = 100;
		max_kind_width   = 100;
		max_menu_width   = 100;
		documentation    = true;

		source = {
			path     = true;
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
end)

setup(function() -- treesitter
	require'nvim-treesitter.configs'.setup {
		highlight = {
			enable = true,
			custom_captures = {
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
end)

setup(function() -- lspfuzzy
	require'lspfuzzy'.setup {}
end)

-- vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

