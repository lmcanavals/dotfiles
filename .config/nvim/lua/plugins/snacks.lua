return {
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				sections = {
					{
						section = "terminal",
						--[[
						Do not attempt to generate the file here programatically. looks ugly
						As of 2026-06-15 kitty and sixels don't work
						example of how to generate the logo:
						infile="$XDG_DATA_HOME/artwork/corplogo.png"
						outfile="$XDG_DATA_HOME/artwork/logo.txt"
						chafa $file -f symbols -s 46x21 --stretch > $outfile
						--]]
						cmd = "cat $XDG_DATA_HOME/artwork/logo.txt; sleep .1",
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
