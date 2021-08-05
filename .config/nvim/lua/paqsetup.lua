-- author: lmcanavals
-- date:   2021-07-26

local fn = vim.fn

local path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if fn.empty(fn.glob(path)) > 0 then
	vim.cmd("!git clone --depth 1 https://github.com/savq/paq-nvim "..path)
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
	"chrisbra/csv.vim";
	{"glacambre/firenvim", run=function() vim.fn['firenvim#install'](0) end};
	"norcalli/nvim-colorizer.lua";
}

-- vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

