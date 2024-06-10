-- author:  lmcanavals
-- date:    2024-05-31

if vim.g.debug then print "after.plugin.catppuccin" end

require 'catppuccin'.setup {
	custom_highlights = function(colors)
		return {
			ColorColumn  = { style = { 'underdotted' }, bg = 'none' },
			CursorLineNr = { style = { 'italic', 'bold' }, bg = colors.surface0 },
			Folded       = { style = { 'underdashed', }, bg = 'none' },
			LineNr       = { style = { 'italic', 'bold' } },
			NormalFloat  = { style = { 'italic', 'bold' } },
			Pmenu        = { style = { 'italic', 'bold' } },
			VisualNOS    = { style = { 'underdouble' } },
			String       = { style = { 'bold' } },
		}
	end,
	integrations = {
		noice = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { 'italic', 'bold' },
				hints = { 'italic', 'bold' },
				warnings = { 'italic', 'bold' },
				information = { 'italic', 'bold' },
				ok = { 'italic', 'bold' },
			},
			underlines = {
				errors = { 'undercurl' },
				hints = { 'undercurl' },
				warnings = { 'undercurl' },
				information = { 'undercurl' },
				ok = { 'undercurl' },
			},
			inlay_hints = {
				background = true,
			},
		},
		notify = true,
		which_key = true,
	},
}

vim.cmd.colorscheme 'catppuccin-mocha'

-- vim: set ts=2:sw=2:noet:sts=2:
