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

require 'lazy'.setup({
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	'chrisbra/csv.vim',
	'dylon/vim-antlr',
	'norcalli/nvim-colorizer.lua',
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{
				'williamboman/mason.nvim',
				config = true,
				opts = {
					ensure_installed = {
						"python-lsp-server",
						"bash-language-server",
						"black",
						"deno",
						"isort",
						"jdtls",
						"lua-language-server",
					}
				},
			},
			'williamboman/mason-lspconfig.nvim',
			{
				'j-hui/fidget.nvim',
				tag = 'legacy',
				opts = {},
			},
			'folke/neodev.nvim',
		},
	},
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
			'rafamadriz/friendly-snippets',
		},
	},
	{
		'folke/which-key.nvim',
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {}
	},
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			on_attach = function(bufnr)
				vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
					{ buffer = bufnr, desc = "[G]o to [P]revious Hunk" })
				vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
					{ buffer = bufnr, desc = "[G]o to [N]ext Hunk" })
				vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
					{ buffer = bufnr, desc = "[P]review [H]unk" })
			end,
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = { char = '┆' },
			scope = { show_start = false, show_end = false },
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		}
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
			'rcarriga/nvim-dap-ui',
			'theHamsta/nvim-dap-virtual-text',
			'nvim-neotest/nvim-nio',
			'williamboman/mason.nvim',
			'sigmasd/deno-nvim',
			'mfussenegger/nvim-jdtls',
		},
	},
	'nvim-tree/nvim-web-devicons',
	'nvim-lualine/lualine.nvim',
}, {})

-- vim: set ts=2:sw=2:noet:sts=2:
