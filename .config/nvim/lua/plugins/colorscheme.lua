-- 3 year time skip

local has_theme, theme = pcall(require, "config.theme")
if not (has_theme and theme and theme.nvim_scheme) then
	return {}
end
vim.o.background = theme.background
return {
	{ "nordtheme/vim", lazy = true },
	{
		"ellisonleao/gruvbox.nvim",
		lazy = true,
		opts = {
			overrides = {
				LspInlayHint = { bold = true, italic = true, fg = "#665c54" },
				BufferLineBackground = { bold = true, italic = true, fg = "#7c6f64" },
				BufferLineBufferVisible = { bold = true, italic = true, fg = "#b16286" },
				CursorLineNr = { bold = true, italic = true, fg = "#fabd2f" },
				DiagnosticError = { bold = true, italic = true, fg = "#fb4934" },
				DiagnosticWarn = { bold = true, italic = true, fg = "#fabd2f" },
				DiagnosticInfo = { bold = true, italic = true, fg = "#83a598" },
				DiagnosticHint = { bold = true, italic = true, fg = "#8ec07c" },
				DiagnosticOk = { bold = true, italic = true, fg = "#b8bb26" },
				DiagnosticVirtualTextError = { bold = true, italic = true, fg = "#fb4934" },
				DiagnosticVirtualTextWarn = { bold = true, italic = true, fg = "#fabd2f" },
				DiagnosticVirtualTextInfo = { bold = true, italic = true, fg = "#83a598" },
				DiagnosticVirtualTextHint = { bold = true, italic = true, fg = "#8ec07c" },
				DiagnosticUnnecessary = { bold = true, italic = true, fg = "#928374" },
				Folded = { bold = true, italic = true, fg = "#928374", bg = "#3c3836" },
				LineNr = { bold = true, italic = true, fg = "#7c6f64" },
				NormalFloat = { bold = true, italic = true, fg = "#ebdbb2" },
				SnacksIndentScope = { fg = "#fe8019" },
				String = { bold = true, italic = false, fg = "#b8bb26" },
			},
			transparent_mode = true,
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			style = theme.tokyonight_style or "night",
			transparent = true,
			---@param hl tokyonight.Highlights
			---@param c ColorScheme
			on_highlights = function(hl, c)
				local Util = require("tokyonight.util")
				hl.BufferLineBackground = { bold = true, italic = true, fg = c.comment }
				hl.BufferLineBufferVisible = { bold = true, italic = true, fg = c.purple }
				hl.CursorLineNr = { bold = true, italic = true, fg = c.orange }
				hl.DiagnosticError = { bold = true, italic = true, fg = c.error }
				hl.DiagnosticWarn = { bold = true, italic = true, fg = c.warning }
				hl.DiagnosticInfo = { bold = true, italic = true, fg = c.info }
				hl.DiagnosticHint = { bold = true, italic = true, fg = c.hint }
				hl.DiagnosticOk = { bold = true, italic = true, fg = "NvimLightGreen" }
				hl.DiagnosticVirtualTextError = {
					bold = true,
					italic = true,
					bg = Util.blend_bg(c.error, 0.1),
					fg = c.error,
				}
				hl.DiagnosticVirtualTextWarn = {
					bold = true,
					italic = true,
					bg = Util.blend_bg(c.warning, 0.1),
					fg = c.warning,
				}
				hl.DiagnosticVirtualTextInfo = {
					bold = true,
					italic = true,
					bg = Util.blend_bg(c.info, 0.1),
					fg = c.info,
				}
				hl.DiagnosticVirtualTextHint = {
					bold = true,
					italic = true,
					bg = Util.blend_bg(c.hint, 0.1),
					fg = c.hint,
				}
				hl.DiagnosticUnnecessary = {
					bold = true,
					italic = true,
					fg = c.terminal_black,
				}
				hl.Folded = {
					bold = true,
					italic = true,
					fg = c.blue,
					bg = c.fg_gutter,
				}
				hl.LineNr = { bold = true, italic = true, fg = c.fg_gutter }
				hl.LineNrAbove = "LineNr"
				hl.LineNrBelow = "LineNr"
				hl.LspInlayHint = {
					bold = true,
					italic = true,
					bg = Util.blend_bg(c.blue7, 0.1),
					fg = c.dark3,
				}
				hl.NormalFloat = {
					bold = true,
					italic = true,
					bg = c.bg_float,
					fg = c.fg_float,
				}
				hl.SnacksIndentScope = { fg = c.hint }
				hl.String = { bold = true, fg = c.green }
				-- hl.VisualNOS = { fg = colors.red, underdouble = true }
			end,
		},

		-- Setting the theme and stuff
		{
			"LazyVim/LazyVim",
			opts = {
				colorscheme = theme.nvim_scheme or "tokyonight",
			},
		},
	},
}
