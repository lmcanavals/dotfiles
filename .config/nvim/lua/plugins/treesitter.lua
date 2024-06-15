return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"go",
				"html",
				"javascript",
				"llvm",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"regex",
				"rust",
				"vim",
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			--[[incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },]]
			indent = {
				enable = true,
			},
		},
	},
}
