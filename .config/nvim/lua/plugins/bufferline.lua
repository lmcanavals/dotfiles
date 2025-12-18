return {
	{
		"akinsho/bufferline.nvim",
		opts = {
			options = {
				buffer_close_icon = "",
				modified_icon = "",
				close_icon = "",
				numbers = function(opts)
					return string.format("%s%s", opts.raise(opts.id), opts.lower(opts.ordinal))
				end,
				style_preset = require("bufferline").style_preset.no_italic,
			},
		},
	},
}
