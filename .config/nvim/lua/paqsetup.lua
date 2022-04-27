-- author: lmcanavals
-- date:   2021-07-26

-- TODO: check:
--	folke/which-key.nvim
--	kevinhwang91/nvim-hlslens
--	kevinhwang91/nvim-bqf
--	rktjmp/lush.nvim -- only if we need to do some low level color cool
--	ray-x/lsp_signature.nvim
--	https://github.com/rockerBOO/awesome-neovim#snippets

local fn = vim.fn

local path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if fn.empty(fn.glob(path)) > 0 then
	vim.cmd("!git clone --depth 1 https://github.com/savq/paq-nvim "..path)
end

require'paq' {
	"savq/paq-nvim";
	"neovim/nvim-lspconfig";
	"hrsh7th/nvim-compe";
	{"nvim-treesitter/nvim-treesitter", run="TSUpdate"};
	"ojroques/nvim-lspfuzzy";
	"kyazdani42/nvim-tree.lua";
	"beyondmarc/glsl.vim";
	"chrisbra/csv.vim";
	{"glacambre/firenvim", run=function() vim.fn['firenvim#install'](0) end};
	"norcalli/nvim-colorizer.lua";
	"github/copilot.vim"
}

-- vim: set ts=2:sw=2:noet:sts=2:
