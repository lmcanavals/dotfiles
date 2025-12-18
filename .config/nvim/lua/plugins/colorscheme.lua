local Util = require("tokyonight.util")
return {
	{
		"folke/tokyonight.nvim",
		opts = {
			style = "night",
			transparent = true,
			---@param hl tokyonight.Highlights
			---@param c ColorScheme
			on_highlights = function(hl, c)
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
	},
}
