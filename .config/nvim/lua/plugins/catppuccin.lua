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
					-- ColorColumn = { bg = "none", style = { "underdotted" }, },
					Conditional = { style = {} },
					CursorLineNr = { bg = colors.surface0, style = { "italic", "bold" } },
					Folded = { fg = colors.blue, style = { "italic", "bold" } },
					LineNr = { style = { "italic", "bold" } },
					NormalFloat = { style = { "italic", "bold" } },
					VisualNOS = { style = { "underdouble" } },
					String = { style = { "bold" } },
					IblScope = { fg = colors.overlay0 },
					LspInlayHint = { fg = colors.surface1, style = { "italic", "bold" } },
					-- RenderMarkdownCode = { bg = colors.surface1 },
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
