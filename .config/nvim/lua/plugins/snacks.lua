return {
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				sections = {
					{
						section = "terminal",
						-- iosevka width to height ratio is 10/24 so 50x21 grid is almost square
						cmd = "chafa $XDG_DATA_HOME/artwork/corplogo.png -f symbols -s 50x21 --stretch; sleep .1",
						height = 21,
					},
					{
						pane = 2,
						{ section = "keys", gap = 1, padding = 1 },
						{ section = "startup" },
					},
				},
			},
			indent = {
				indent = {
					char = "┆",
				},
				chunk = {
					enabled = true,
					char = {
						arrow = "╼",
					},
				},
			},
		},
	},
}
