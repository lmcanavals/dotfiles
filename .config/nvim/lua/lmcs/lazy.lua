-- author:  lmcanavals
-- date:    2023-07-26

-- TODO: check:
--	kevinhwang91/nvim-hlslens
--	kevinhwang91/nvim-bqf
--	rktjmp/lush.nvim -- only if we need to do some low level color cool
--	ray-x/lsp_signature.nvim
--	https://github.com/rockerBOO/awesome-neovim#snippets

if vim.g.debug then print "lmcsnvim.lazy" end

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

local vks = vim.keymap.set

require 'lazy'.setup({
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{
				'williamboman/mason.nvim',
				config = true,
				opts = {
					ensure_installed = {
						'python-lsp-server',
						'bash-language-server',
						'black',
						'deno',
						'isort',
						'jdtls',
						'lua-language-server',
					}
				},
			},
			'williamboman/mason-lspconfig.nvim',
			{
				'j-hui/fidget.nvim',
				tag = 'legacy',
				opts = {},
			},
			{
				'folke/lazydev.nvim',
				ft = 'lua',
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = 'luvit-meta/library', words = { 'vim%.uv' } },
					},
				},
			},
		},
	},
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {}
	},
	{
		'folke/noice.nvim',
		event = 'VeryLazy',
		opts = {},
		dependencies = {
			'MunifTanjim/nui.nvim',
			'rcarriga/nvim-notify',
		}
	},
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			{
				'L3MON4D3/LuaSnip',
				dependencies = { 'rafamadriz/friendly-snippets' }
			},
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
		},
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = 'lazydev',
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
	},
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			on_attach = function(bufnr)
				local gs = require 'gitsigns'
				vks('n', '<leader>gp', gs.prev_hunk, {
					buffer = bufnr,
					desc = "Go to Previous Hunk",
				})
				vks('n', '<leader>gn', gs.next_hunk, {
					buffer = bufnr,
					desc = "Go to Next Hunk",
				})
				vks('n', '<leader>ph', gs.preview_hunk, {
					buffer = bufnr,
					desc = "Preview Hunk",
				})
			end,
		},
	},
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		opts = {
			indent = { char = '┆' },
			scope = { show_start = false, show_end = false },
		},
	},
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
	},
	{
		'mfussenegger/nvim-dap',
		dependencies = {
			{ 'sigmasd/deno-nvim',       ft = 'js' },
			{ 'mfussenegger/nvim-jdtls', ft = 'java' },
			'rcarriga/nvim-dap-ui',
			'theHamsta/nvim-dap-virtual-text',
			'nvim-neotest/nvim-nio',
			'williamboman/mason.nvim',
		},
	},
	{ 'Bilal2453/luvit-meta',        lazy = true },
	{ 'chrisbra/csv.vim',            ft = 'csv' },
	{ 'dylon/vim-antlr',             ft = { 'g', 'g4' } },
	{ 'norcalli/nvim-colorizer.lua', event = 'VeryLazy' },
	'folke/lazy.nvim',
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	'nvim-tree/nvim-web-devicons',
	'nvim-lualine/lualine.nvim',
}, {})

-- vim: set ts=2:sw=2:noet:sts=2:
