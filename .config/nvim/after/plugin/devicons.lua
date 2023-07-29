-- author:  lmcanavals
-- date:    2023-06-28

if vim.g.debug then print "after.plugin.devicons" end

require 'nvim-web-devicons'.setup {
	override = {
		zsh = {
			icon = "",
			color = "#428850",
			cterm_color = "10",
			name = "Zsh"
		}
	},
	color_icons = true,
	default = true,
	strict = true,
	override_by_filename = {
		[".gitignore"] = {
			icon = "",
			color = "#f1502f",
			name = "Gitignore"
		}
	},
	override_by_extension = {
		["log"] = {
			icon = "",
			color = "#81e043",
			name = "Log"
		}
	},
}

-- vim: set ts=2:sw=2:noet:sts=2:
