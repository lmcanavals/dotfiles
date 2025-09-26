return {
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				sections = {
					{
						section = "terminal",
						cmd = "cat ~/.config/logaso; sleep .1",
						random = 10,
						height = 21,
						width = 44,
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
