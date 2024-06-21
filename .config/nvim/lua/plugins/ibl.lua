return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = function(_, opts)
			opts.indent.char = "┊"
			opts.indent.tab_char = "┆"
			opts.scope.char = "╎"
		end,
	},
}
