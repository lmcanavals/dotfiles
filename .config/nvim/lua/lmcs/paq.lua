-- author: lmcanavals
-- date:   2021-07-26

-- TODO: check:
--	folke/which-key.nvim
--	kevinhwang91/nvim-hlslens
--	kevinhwang91/nvim-bqf
--	rktjmp/lush.nvim -- only if we need to do some low level color cool
--	ray-x/lsp_signature.nvim
--	https://github.com/rockerBOO/awesome-neovim#snippets

if vim.g.debug then print "lmcsnvim.paq" end

local fn = vim.fn

local path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if fn.empty(fn.glob(path)) > 0 then
	fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/savq/paq-nvim",
		path
	})
end
vim.opt.rtp:prepend(path)

require 'paq' {
	"savq/paq-nvim",
	"neovim/nvim-lspconfig",
	"nvim-tree/nvim-web-devicons",

	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"L3MON4D3/LuaSnip",

	{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
	"nvim-lua/plenary.nvim",
	{ "nvim-telescope/telescope.nvim", branch = "0.1.2" },
	"kyazdani42/nvim-tree.lua",
	"chrisbra/csv.vim",
	"norcalli/nvim-colorizer.lua",
	"edluffy/hologram.nvim",
	-- "github/copilot.vim"
}

-- vim: set ts=2:sw=2:noet:sts=2:
