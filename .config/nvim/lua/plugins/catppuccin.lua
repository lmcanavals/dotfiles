return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			background = {
				light = "latte",
				dark = "mocha",
			},
			custom_highlights = function(colors)
				return {
					ColorColumn = { style = { "underdotted" }, bg = "none" },
					CursorLineNr = { style = { "italic", "bold" }, bg = colors.surface0 },
					-- Folded = { style = { "underdashed" }, bg = "none" },
					LineNr = { style = { "italic", "bold" } },
					NormalFloat = { style = { "italic", "bold" } },
					VisualNOS = { style = { "underdouble" } },
					String = { style = { "bold" } },
				}
			end,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			flavour = "auto",
			integrations = {
				noice = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic", "bold" },
						hints = { "italic", "bold" },
						warnings = { "italic", "bold" },
						information = { "italic", "bold" },
						ok = { "italic", "bold" },
					},
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
						ok = { "undercurl" },
					},
					inlay_hints = {
						background = true,
					},
				},
				notify = true,
				which_key = true,
			},
			show_end_of_buffer = true,
			transparent_background = true,
		},
	},
}
