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
	{ -- neovim/nvim-lspconfig
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
	{ -- hrsh7th/nvim-cmp
		'hrsh7th/nvim-cmp',
		dependencies = {
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
			'rafamadriz/friendly-snippets',
		},
	},
	{ -- folke/which-key.nvim
		'folke/which-key.nvim',
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {}
	},
	{ -- folke/noice.nvim
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		}
	},
	{ -- lewis6991/gitsigns.nvim
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
	{ -- lukas-reineke/indent-blankline.nvim
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = { char = '┆' },
			scope = { show_start = false, show_end = false },
		},
	},
	{ -- nvim-telescope/telescope.nvim
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{ -- nvim-telescope/telescope-fzf-native.nvim
		'nvim-telescope/telescope-fzf-native.nvim',
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	},
	{ -- nvim-treesitter/nvim-treesitter
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
	},
	{ -- mfussenegger/nvim-dap
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
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	'chrisbra/csv.vim',
	'dylon/vim-antlr',
	'norcalli/nvim-colorizer.lua',
	'nvim-tree/nvim-web-devicons',
	'nvim-lualine/lualine.nvim',
}, {})

-- vim: set ts=2:sw=2:noet:sts=2:
